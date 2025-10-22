extends Node3D
class_name JellyTable

var col: CollisionObject3D
var mesh: MeshInstance3D

var toppings: Array[SelectableTopping] = []

var curBreadLocation: Vector3
var curBread: Bread3D

var breadstacks = {}

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
	breadstacks[GM.BreadType.Wheat] = breadstack
	
	curBreadLocation = $CurrentBreadLocation.global_position
	pass

func spawn_bread():
	pass

func _bread_selected(bread: int):
	var stack: SelectableBread = breadstacks[bread]
	
	var spawnedBread: Bread3D = GM.spawn(GM.dictBread[stack.bread].scene) as Bread3D
	await get_tree().physics_frame
	spawnedBread.global_position = stack.global_position
	spawnedBread.set_destination(curBreadLocation)
	curBread = spawnedBread
	pass
	
func _topping_selected(topping: int):
	ToppingSelected.emit(topping)
	pass
