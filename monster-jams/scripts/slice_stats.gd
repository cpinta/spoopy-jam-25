class_name SliceStats

var toppings: Array[GM.Toppings]
var toppingMap = {}
var percents: Array[float]

var breadType: GM.BreadType

const MARGIN_OF_ERROR: float = .3

func _init(bread: GM.BreadType, topp:Array[GM.Toppings] = []):
	for i in range(0, topp.size()):
		add_topping_percent(topp[i], 1/topp.size())
	breadType = bread
	pass

func add_topping_percent(topping: GM.Toppings, percent: float):
	toppings.append(topping)
	toppingMap[topping] = toppings.size()-1
	percents.append(percent)
	pass

func is_valid_stats(stats:SliceStats):
	if toppings.size() != stats.toppings.size():
		return false
	if stats.breadType != breadType:
		return false
	
	for i in range(0, stats.toppings.size()):
		if abs(stats.get_topping_percent(stats.toppings[i]) - get_topping_percent(stats.toppings[i])) > MARGIN_OF_ERROR:
			return false
		pass
	return true

func get_topping_percent(topping: GM.Toppings):
	return toppings[toppingMap[topping]]
