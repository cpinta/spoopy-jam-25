extends Node
class_name SelectableBread

@export var bread: GM.BreadType
var col: CollisionObject3D

signal WasSelected(int)

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	WasSelected.emit(bread)
	pass
