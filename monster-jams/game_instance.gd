class_name GameInstance

var score: int = 0
var currentOrders: Array[Order] = []

signal new_order_added(order:Order)

func add_order(order: Order):
	currentOrders.append(order)
	new_order_added.emit(order)
	pass
