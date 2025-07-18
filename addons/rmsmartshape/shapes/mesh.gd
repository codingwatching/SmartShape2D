@tool
extends Resource
class_name SS2D_Mesh

## This is essentially a serializable data buffer with Node2D properties that will be assigned to a
## rendering node later.

@export var texture: Texture2D = null
@export var mesh: ArrayMesh
@export var material: Material = null
@export var z_index: int = 0
@export var z_as_relative: bool = true
@export var show_behind_parent: bool = false
@export var force_no_tiling: bool = false
