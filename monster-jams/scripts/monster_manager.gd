class_name MonsterManager
extends Node3D

@onready var MONSTER_LIST = {\
	GM.Monster.Franken: load("res://scenes/franken.tscn"),
	GM.Monster.Skeleton: load("res://scenes/skeleton.tscn")
}

var AVAILABLE_MONSTERS: Array[GM.Monster] = []
var MIN_TIME_BT_MONSTERS: float = 4
var MAX_TIME_BT_MONSTERS: float = 8

var monsters: Array[Monster]
var spawnLocations: Array[Vector3]
var counterQueue: LineQueue
var waitingQueue: LineQueue
var entrance: PathNode

var leaveNode: PathNode

var _spawningActive: bool = false
var spawnTimer: float = 0
var spawnCount: int = 0

signal monsterWasClickedWhileWaitingForOrder(monster: Monster)
signal monsterGivenCorrectOrder(monster: Monster)

func _ready():
	spawnLocations.append($"right side".global_position)
	spawnLocations.append($"left side".global_position)
	
	leaveNode = $"leave node"
	leaveNode.monster_arrived.connect(monster_exited_scene)
	
	spawn_monster_rand_loc(GM.Monster.Franken)
	pass

func _process(delta):
	if _spawningActive:
		if spawnTimer > 0:
			spawnTimer -= delta
		else:
			if spawnCount < 2:
				spawn_rand_monster()
				spawnTimer = randf_range(MIN_TIME_BT_MONSTERS, MAX_TIME_BT_MONSTERS)
	pass

func activate():
	_spawningActive = true
	spawnTimer = randf_range(MIN_TIME_BT_MONSTERS, MAX_TIME_BT_MONSTERS)
	pass

func deactivate():
	_spawningActive = false
	pass

func set_monsters_targetability(value: bool):
	for i in range(0, monsters.size()):
		monsters[i].set_targetability(value)
		pass
	pass

func initialize(counter:LineQueue, waiting:LineQueue):
	counterQueue = counter
	counterQueue.lineType = LineQueue.Type.Counter
	waitingQueue = waiting
	waitingQueue.lineType = LineQueue.Type.WaitingForFood
	pass

func monster_at_front(monster:Monster):
	monster.set_line_position(counterQueue.add_monster_to_queue_back(monster))
	pass

func spawn_rand_monster():
	var monster: Monster = await spawn_monster(
		AVAILABLE_MONSTERS[randi_range(0, AVAILABLE_MONSTERS.size()-1)], 
		spawnLocations[randi_range(0, spawnLocations.size()-1)]
	)
	pass

func spawn_monster_rand_loc(selection:GM.Monster):
	var monster: Monster = await spawn_monster(selection, spawnLocations[randi_range(0, spawnLocations.size()-1)])
	return monster

func orderWasTaken(monster: Monster, order: Order):
	#monster.linePos.leave_queue()
	monster.set_line_position(waitingQueue.add_monster_to_queue_back(monster))
	pass

func monster_given_order(monster: Monster):
	monster.pathNode = leaveNode
	monster.set_walk_dest(leaveNode.global_position)
	monsterGivenCorrectOrder.emit(monster)
	pass

func monster_exited_scene(monster: Monster):
	monsters.erase(monster)
	monster.remove()
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
	monster.wasGivenOrder.connect(monster_given_order)
	
	monster.clickedWhileWaitingForOrder.connect(monster_was_clicked_while_waiting_for_order)
	
	#var stats: Array[SliceStats] = [
		#SliceStats.new(GM.BreadType.Wheat, [GM.Toppings.StrawberryJam, GM.Toppings.GrapeJam]), 
		#SliceStats.new(GM.BreadType.Wheat, [GM.Toppings.StrawberryJam]), 
		#SliceStats.new(GM.BreadType.Wheat, []), ]
	
	var order = generate_order()
	
	monster.set_order(order)
	
	monsters.append(monster)
	spawnCount += 1
	return monster

func monster_was_clicked_while_waiting_for_order(monster: Monster):
	monsterWasClickedWhileWaitingForOrder.emit(monster)

func monster_was_clicked_order_was_wrong(monster: Monster):
	monster.think_of_food()
	pass

func generate_order() -> Order:
	return Order.generate_new(GM.get_current_jams_available(), GM.get_current_max_toppings(), GM.get_current_max_sandwich_size())
