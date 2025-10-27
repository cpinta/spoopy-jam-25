class_name MonsterManager
extends Node3D

@onready var MONSTER_LIST = {\
	GM.Monster.Franken: load("res://scenes/franken.tscn"),
	GM.Monster.Skeleton: load("res://scenes/skeleton.tscn")
	
}

var spawnLocations: Array[Vector3]
var counterQueue: LineQueue
var waitingQueue: LineQueue
var entrance: PathNode

const SPAWN_EVERY: float = 1
var spawnTimer: float = 0
var spawnCount: int = 0

func _ready():
	spawnLocations.append($"right side".global_position)
	spawnLocations.append($"left side".global_position)
	
	spawn_monster_rand_loc(GM.Monster.Franken)
	pass

func _process(delta):
	if spawnTimer > 0:
		spawnTimer -= delta
	else:
		if spawnCount < 2:
			spawn_monster_rand_loc(GM.Monster.Skeleton)
			spawnTimer = SPAWN_EVERY
	pass

func initialize(counter:LineQueue, waiting:LineQueue):
	counterQueue = counter
	waitingQueue = waiting
	pass

func monster_at_front(monster:Monster):
	monster.set_line_position(counterQueue.add_monster_to_queue_back(monster))
	pass

func spawn_monster_rand_loc(selection:GM.Monster):
	var monster: Monster = await spawn_monster(selection, spawnLocations[randi_range(0, spawnLocations.size()-1)])
	spawnCount += 1
	return monster

func orderWasTaken(monster: Monster, order: Order):
	monster.linePos.leave_queue()
	monster.set_line_position(waitingQueue.add_monster_to_queue_back(monster))
	pass

func spawn_monster(selection: GM.Monster, location: Vector3):
	var scene: PackedScene = MONSTER_LIST[selection] 
	var monster: Monster = scene.instantiate()
	add_child(monster)
	await get_tree().physics_frame
	
	monster.orderWasTaken.connect(orderWasTaken)
	monster.pathNode = entrance
	monster.set_walk_dest(entrance.global_position)
	monster.global_position = location
	
	#var stats: Array[SliceStats] = [
		#SliceStats.new(GM.BreadType.Wheat, [GM.Toppings.StrawberryJam, GM.Toppings.GrapeJam]), 
		#SliceStats.new(GM.BreadType.Wheat, [GM.Toppings.StrawberryJam]), 
		#SliceStats.new(GM.BreadType.Wheat, []), ]
	
	var order = generate_order()
	
	monster.set_order(order)
	
	return monster

func generate_order() -> Order:
	return Order.generate_new(GM.get_current_jams_available(), GM.get_current_max_toppings(), GM.get_current_max_sandwich_size())
