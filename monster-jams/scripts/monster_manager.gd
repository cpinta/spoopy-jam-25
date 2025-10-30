class_name MonsterManager
extends Node3D

@onready var MONSTER_LIST = {\
	GM.Monster.Franken: load("res://scenes/franken.tscn"),
	GM.Monster.Skeleton: load("res://scenes/skeleton.tscn"),
	GM.Monster.Slime: load("res://scenes/slime.tscn"),
	GM.Monster.Witch: load("res://scenes/witch.tscn")
}

var AVAILABLE_MONSTERS: Array[GM.Monster] = []
var MIN_TIME_BT_MONSTERS: float = 4
var MAX_TIME_BT_MONSTERS: float = 8

var MAX_MONSTERS_AT_A_TIME: int = 5

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
signal monsterOrderTimeOut(monster: Monster)

func _ready():
	spawnLocations.append($"right side".global_position)
	spawnLocations.append($"left side".global_position)
	
	leaveNode = $"leave node"
	leaveNode.monster_arrived.connect(monster_exited_scene)
	
	monsterWasClickedWhileWaitingForOrder.connect(GM.plate.check_if_has_monster_order)
	monsterGivenCorrectOrder.connect(GM.order_given_correctly)
	monsterOrderTimeOut.connect(GM.order_timed_out)
	
	GM.levelManager.endLevel.connect(reset)
	
	entrance.monster_arrived.connect(monster_at_front)
	pass

func _process(delta):
	if _spawningActive:
		if spawnTimer > 0:
			spawnTimer -= delta
		else:
			if monsters.size() < MAX_MONSTERS_AT_A_TIME:
				spawn_rand_monster()
				spawnTimer = randf_range(MIN_TIME_BT_MONSTERS, MAX_TIME_BT_MONSTERS)
	pass

func activate():
	_spawningActive = true
	spawnTimer = randf_range(MIN_TIME_BT_MONSTERS, MAX_TIME_BT_MONSTERS)
	pass

func reset(level: Level):
	for i in range(0,monsters.size()):
		monsters[i].remove()
	monsters.clear()
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
	monster.set_pos_state(Monster.MonsterPositionState.LeavingRestaurant)
	monster.leave_current_line_queue()
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
	var monster: Monster = await GM.spawn(scene) as Monster
	monster.global_position = location
	
	monster.orderWasTaken.connect(orderWasTaken)
	monster.pathNode = entrance
	monster.set_walk_dest(entrance.global_position)
	monster.wasGivenOrder.connect(monster_given_order)
	
	monster.clickedWhileWaitingForOrder.connect(monster_was_clicked_while_waiting_for_order)
	monster.orderTimedOutToCounter.connect(monster_order_timed_out_going_to_counter)
	monster.orderTimedOut.connect(monster_order_timed_out_leaving)
	
	var order = generate_order()
	
	monster.set_order(order)
	
	monsters.append(monster)
	spawnCount += 1
	return monster

func monster_order_timed_out_leaving(monster: Monster):
	monster.leave_current_line_queue()
	monster.pathNode = leaveNode
	monster.set_walk_dest(leaveNode.global_position)
	monster.set_pos_state(Monster.MonsterPositionState.Angry)
	monsterOrderTimeOut.emit(monster)
	pass

func monster_order_timed_out_going_to_counter(monster: Monster):
	monster.set_line_position(counterQueue.add_monster_to_queue_front(monster))
	pass

func monster_was_clicked_while_waiting_for_order(monster: Monster):
	monsterWasClickedWhileWaitingForOrder.emit(monster)

func monster_was_clicked_order_was_wrong(monster: Monster):
	monster.think_of_food()
	pass

func generate_order() -> Order:
	return Order.generate_new()
