class_name GameInstance

var doIncreaseTimer: bool = false
var timer: float = 0

var score: int = 0
var highscore: int = 0
var currentOrders: Array[Order] = []

var jamsAvailibleTilIndex: int = 0
var maxToppingsPerSlice: int = 1
var maxSandwichSize: int = 1

signal new_order_added(order:Order)

func _process(delta):
	if doIncreaseTimer:
		timer += delta
	pass

func start():
	doIncreaseTimer = true
	timer = 0
	score = 0
	jamsAvailibleTilIndex = 0
	maxToppingsPerSlice = 1
	maxSandwichSize = 1
	pass

func add_order(order: Order):
	currentOrders.append(order)
	new_order_added.emit(order)
	pass

func add_score(value: int):
	score += value
	pass

func round_ended():
	if score > highscore:
		highscore = score
	pass
