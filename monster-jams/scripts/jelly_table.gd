extends Node3D
class_name JellyTable

var col: CollisionObject3D
var mesh: MeshInstance3D

var toppings: Array[SelectableTopping] = []

var curBreadLocation: Vector3

signal ToppingSelected(int)
signal BreadSelected(int)

func _ready():
	var jams = $Jams
	for i in range(0, jams.get_child_count()):
		toppings.append(jams.get_child(i))
		toppings[i].WasSelected.connect(_topping_selected)
		pass
	
	var breadstack: SelectableBread = $BreadStack
	breadstack.WasSelected.connect(_bread_selected)
	
	curBreadLocation = $CurrentBreadLocation.global_position
	pass

func _bread_selected(bread: int):
	#BreadSelected.emit(bread)
	
	pass
	
func _topping_selected(topping: int):
	ToppingSelected.emit(topping)
	pass
