extends "res://addons/gut/test.gd"

var FUNC := load("res://addons/rmsmartshape/plugin_functionality.gd")
var PLUGIN := load("res://addons/rmsmartshape/plugin.gd")


func test_intersect_control_point() -> void:
	var shape := SS2D_Shape_Closed.new()
	var pa := shape.get_point_array()
	add_child_autofree(shape)
	var vert_p := Vector2(100, 100)
	var key := pa.add_point(vert_p)
	pa.set_point_in(key, Vector2(-32, 0))
	pa.set_point_out(key, Vector2(32, 0))
	var et := Transform2D()
	var grab := 16.0
	var f1 := Callable(FUNC, "get_intersecting_control_point_out")
	var f2 := Callable(FUNC, "get_intersecting_control_point_in")
	var functions: Array[Callable] = [f1, f2]
	var f_name: Array[String] = ["out", "in"]
	var f_offset: Array[Vector2] = [Vector2(32, 0), Vector2(-32, 0)]
	var intersect := []
	for i in range(0, functions.size(), 1):
		var f: Callable = functions[i]
		var s := f_name[i]
		var o := f_offset[i]
		shape.position = Vector2(0, 0)
		intersect = f.call(shape, et, Vector2(0, 0), grab)
		assert_eq(intersect.size(), 0, s)
		intersect = f.call(shape, et, vert_p, grab)
		assert_eq(intersect.size(), 0, s)
		intersect = f.call(shape, et, vert_p + o - Vector2(grab, 0), grab)
		assert_eq(intersect.size(), 1, s)
		intersect = f.call(shape, et, vert_p + o - Vector2(grab + 1, 0), grab)
		assert_eq(intersect.size(), 0, s)
		intersect = f.call(shape, et, vert_p + o + Vector2(grab, 0), grab)
		assert_eq(intersect.size(), 1, s)
		intersect = f.call(shape, et, vert_p + o + Vector2(grab + 1, 0), grab)
		assert_eq(intersect.size(), 0, s)

		shape.position.x = 1
		intersect = f.call(shape, et, vert_p + o + Vector2(grab + 1, 0), grab)
		assert_eq(intersect.size(), 1, s)


func test_snapping() -> void:
	var shape := SS2D_Shape_Closed.new()
	var identity := Transform2D.IDENTITY
	var step := Vector2(8, 8)
	add_child_autofree(shape)
	var p1 := Vector2(17, 19)
	assert_eq(
		SS2D_PluginFunctionality.snap_position(p1, Vector2(0, 0), step, shape.get_global_transform()), Vector2(16, 16)
	)

	shape.global_position = Vector2(1, 2)
	var expected := (
		SS2D_PluginFunctionality.snap_position(p1 + shape.global_position, Vector2(0, 0), step, identity)
		- shape.global_position
	)
	assert_eq(SS2D_PluginFunctionality.snap_position(p1, Vector2(0, 0), step, shape.get_global_transform()), expected)

	var offset := Vector2(3, 3)
	expected = (
		SS2D_PluginFunctionality.snap_position(p1 + shape.global_position, Vector2(0, 0), step, identity)
		- shape.global_position
		+ offset
	)
	assert_eq(SS2D_PluginFunctionality.snap_position(p1, offset, step, shape.get_global_transform()), expected)

	var p2 := Vector2(23.2, 20)
	assert_eq(SS2D_PluginFunctionality.snap_position(p2, Vector2(0, 0), step, identity), Vector2(24, 24))
