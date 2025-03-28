extends SS2D_Action
class_name SS2D_ActionCutEdge


## A delegate action that selects an action to perform based on the edge
## location and shape state.

var _shape: SS2D_Shape
var _action: SS2D_Action


func _init(shape: SS2D_Shape, key_edge_start: int, key_edge_end: int) -> void:
	_shape = shape
	var pa := _shape.get_point_array()

	var key_first: int = pa.get_point_key_at_index(0)
	var key_last: int = pa.get_point_key_at_index(pa.get_point_count()-1)
	if pa.is_shape_closed():
		_action = SS2D_ActionOpenShape.new(shape, key_edge_start)
	elif key_edge_start == key_first:
		_action = SS2D_ActionDeletePoint.new(shape, key_edge_start)
	elif  key_edge_end == key_last:
		_action = SS2D_ActionDeletePoint.new(shape, key_edge_end)
	else:
		_action = SS2D_ActionSplitShape.new(shape, key_edge_start)


func get_name() -> String:
	return _action.get_name()


func do() -> void:
	_action.do()


func undo() -> void:
	_action.undo()

