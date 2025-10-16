extends Node3D
class_name JellyTable

var col: CollisionObject3D

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	print("jklafsd")
	pass
