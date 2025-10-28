class_name Level

var MAX_TOPPINGS_PER_SLICE: int = 1
var MAX_SANDWICH_SIZE: int = 1

var AVAILABLE_MONSTERS: Array[GM.Monster] = []
var AVAILABLE_TOPPINGS = {}

var MIN_TIME_BT_MONSTERS: float = 4
var MAX_TIME_BT_MONSTERS: float = 8

var INTRO_TEXT: String = ""

func add_toppings(arr: Array[GM.Toppings]):
	for i in range(0, arr.size()):
		AVAILABLE_TOPPINGS[arr[i]] = true
		pass
	pass
