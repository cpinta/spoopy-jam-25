extends Node3D
class_name JellyTable

var col: CollisionObject3D
var mesh: MeshInstance3D

var toppings: Array[SelectableTopping] = []

var bottomBreadLocation: Vector3
var bottomBread: Bread3D

var breadstacks = {}

signal ToppingSelected(int)
signal BreadSelected(int)

func _ready():
	var jams = $Jams
	for i in range(0, jams.get_child_count()):
		toppings.append(jams.get_child(i))
		toppings[i].WasSelected.connect(_topping_selected)
		pass
	
	ToppingSelected.connect(GM.cursor.topping_selected)
	BreadSelected.connect(GM.cursor.bread_selected)
	
	var breadstack: SelectableBread = $BreadStack
	breadstack.WasSelected.connect(_bread_selected)
	breadstack.WasSelected.connect(GM.cursor.bread_selected)
	breadstacks[GM.BreadType.Wheat] = breadstack
	
	bottomBreadLocation = $CurrentBreadLocation.global_position
	cam_looking_at_counter()
	pass

func transfer_to_sandwich(plate: Plate):
	if plate:
		if bottomBread:
			plate.add_sandwich(bottomBread)
			bottomBread = null
	pass

func _bread_selected(bread: int):
	var stack: SelectableBread = breadstacks[bread]
	
	var spawnedBread: Bread3D = await GM.spawn(GM.dictBread[stack.bread].scene) as Bread3D
	await get_tree().physics_frame
	
	spawnedBread.set_state(Bread3D.BreadState.MovingToSandwich)
	if bottomBread:
		var topBread = bottomBread.get_top_bread()
		spawnedBread.reparent(topBread)
		#await get_tree().physics_frame
		spawnedBread.global_position = stack.global_position
		topBread.breadOnTop = spawnedBread
		var topY = topBread.get_bread_global_pos_above().y
		var botY = bottomBread.global_position.y
		var diff = topY - botY
		
		spawnedBread.set_destination(bottomBread.NEXT_BREAD_DIST * Vector3.UP)
	else:
		bottomBread = spawnedBread
		spawnedBread.global_position = stack.global_position
		bottomBread.set_destination(bottomBreadLocation)
	pass

func set_default_jam_placements():
	toppings[0].toppingEnum = GM.Toppings.StrawberryJam
	toppings[1].toppingEnum = GM.Toppings.BlueberryJam
	toppings[2].toppingEnum = GM.Toppings.GrapeJam

#func shuffle_jams():
	#var toppingEnums: Array[GM.Toppings] = []
	#var toppingIndexes = {}
	#for i in range(0, toppings.size()):
		#if toppings[i].visible:
			#toppingIndexes[toppings[i].toppingEnum] = i
			#toppingEnums.append(toppings[i].toppingEnum)
		#pass
	#
	#var ind: int = 0
	#while toppingEnums.size() > 0:
		#var randind: int = randi_range(1, toppingIndexes.size()-1)
		#var selected = toppingEnums[randind]
		#toppings[ind].toppingEnum = selected
		#toppingIndexes.remove
		#pass

func cam_looking_at_counter():
	cam_looking(true)
func cam_looking_at_jam_table():
	cam_looking(false)

func available_jams_match_orders():
	for i in range(0, toppings.size()):
		toppings[i].visible = false
		for j in range(0, Order.TOPPING_CHOICES.size()):
			if toppings[i].toppingEnum == Order.TOPPING_CHOICES[j]:
				toppings[i].visible = true
			pass
	pass

func cam_looking(lookingAway:bool):
	for i in range(0, toppings.size()):
		toppings[i].set_if_is_selectable(not lookingAway)
		pass
	pass
	
func _topping_selected(topping: int):
	ToppingSelected.emit(topping)
	pass
