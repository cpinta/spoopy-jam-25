extends Node3D
class_name JellyTable

var col: CollisionObject3D
var mesh: MeshInstance3D

var toppings: Array[SelectableTopping] = []

signal ToppingSelected(int)

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	
	var jams = $Jams
	for i in range(0, jams.get_child_count()):
		toppings.append(jams.get_child(i))
		toppings[i].WasSelected.connect(topping_selected)
		pass
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	pass

func topping_selected(topping: int):
	ToppingSelected.emit(topping)
	pass
