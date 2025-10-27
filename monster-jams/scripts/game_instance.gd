class_name GameInstance

var doIncreaseTimer: bool = false
var timer: float = 0

var score: int = 0
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
	pass

func add_order(order: Order):
	currentOrders.append(order)
	new_order_added.emit(order)
	pass
