class_name MonsterManager
extends Node3D

@onready var MONSTER_LIST = {\
	GM.Monster.Franken: load("res://scenes/franken.tscn")
}

var spawnLocations: Array[Vector3]
var counterQueue: LineQueue
var waitingQueue: LineQueue

func _ready():
	spawnLocations.append($"right side".global_position)
	spawnLocations.append($"left side".global_position)
	
	spawn_monster_rand_loc(GM.Monster.Franken)
	pass

func _process(delta):
	pass

func initialize(counter:LineQueue, waiting:LineQueue):
	counterQueue = counter
	waitingQueue = waiting
	pass

func spawn_monster_rand_loc(selection:GM.Monster):
	var monster: Monster = await spawn_monster(selection, spawnLocations[randi_range(0, spawnLocations.size()-1)])
	return monster

func orderWasTaken(monster: Monster, order: Order):
	monster.set_pos_state(Monster.MonsterPositionState.WaitingForFood)
	monster.set_line_position(waitingQueue.add_monster_to_queue(monster))
	pass

func spawn_monster(selection: GM.Monster, location: Vector3):
	var scene: PackedScene = MONSTER_LIST[selection] 
	#GM.spawn(scene)
	var monster: Monster = scene.instantiate()
	add_child(monster)
	await get_tree().physics_frame
	
	monster.orderWasTaken.connect(orderWasTaken)
	monster.set_line_position(counterQueue.add_monster_to_queue(monster))
	monster.global_position = location
	
	var stats: Array[SliceStats] = [SliceStats.new([GM.Toppings.StrawberryJam, GM.Toppings.GrapeJam], GM.BreadType.Wheat), SliceStats.new([GM.Toppings.StrawberryJam], GM.BreadType.Wheat), SliceStats.new([], GM.BreadType.Wheat), ]
	var order = Order.new(stats)
	
	monster.set_order(order)
	
	return monster
