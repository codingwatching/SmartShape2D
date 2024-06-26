extends "res://addons/gut/test.gd"


func test_edges_correct_ranges() -> void:
	# Two normals that don't overlap
	# Right semicircle
	var nr1 := SS2D_NormalRange.new(90.0, -180.0)
	# Left semicircle
	var nr2 := SS2D_NormalRange.new(91.0, 179.0)

	var edge_mat_1 := SS2D_Material_Edge.new()
	var edge_mat_2 := SS2D_Material_Edge.new()

	var edge_mat_meta_1 := SS2D_Material_Edge_Metadata.new()
	var edge_mat_meta_2 := SS2D_Material_Edge_Metadata.new()
	edge_mat_meta_1.edge_material = edge_mat_1
	edge_mat_meta_2.edge_material = edge_mat_2
	edge_mat_meta_1.normal_range = nr1
	edge_mat_meta_2.normal_range = nr2

	var shape_material := SS2D_Material_Shape.new()
	shape_material.add_edge_material(edge_mat_meta_1)
	shape_material.add_edge_material(edge_mat_meta_2)

	# Vectors that match normal 1
	var vectors_nr1: Array[Vector2] = [Vector2(1, 1), Vector2(1, 0), Vector2(1, -1)]
	# Vectors that match normal 2
	var vectors_nr2: Array[Vector2] = [Vector2(-1, 1), Vector2(-1, 0.1), Vector2(-1, -0.1)]

	for v in vectors_nr1:
		var materials := shape_material.get_edge_meta_materials(v)
		gut.p("Testing %s" % v)
		assert_eq(materials.size(), 1, "Exactly one material returned")
		if materials.size() > 0:
			assert_eq(materials[0].edge_material, edge_mat_1, "Matches material 1")

	for v in vectors_nr2:
		var materials := shape_material.get_edge_meta_materials(v)
		assert_eq(materials.size(), 1, "Exactly one material returned")
		if materials.size() > 0:
			assert_eq(materials[0].edge_material, edge_mat_2, "Matches material 2")

	for v in vectors_nr1:
		var materials := shape_material.get_edge_meta_materials(v)
		assert_eq(materials.size(), 1, "Exactly one material returned")
		if materials.size() > 0:
			assert_ne(materials[0].edge_material, edge_mat_2, "Doesn't match material 2")

	for v in vectors_nr2:
		var materials := shape_material.get_edge_meta_materials(v)
		assert_eq(materials.size(), 1, "Exactly one material returned")
		if materials.size() > 0:
			assert_ne(materials[0].edge_material, edge_mat_1, "Doesn't match material 1")

	var m := shape_material.get_all_edge_meta_materials()
	assert_true(m[0] == edge_mat_meta_1)
	assert_true(m[1] == edge_mat_meta_2)
