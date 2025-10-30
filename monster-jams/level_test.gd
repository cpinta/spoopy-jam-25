extends Level
class_name Level_Test

func _init() -> void:
	INTRO_TEXT = "Tonight should be an easy night"
	
	MAX_TOPPINGS_PER_SLICE = 2
	MAX_SANDWICH_SIZE = 2
	
	MIN_TIME_BT_MONSTERS = 0.1
	MAX_TIME_BT_MONSTERS = 0.2
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 100
	ORDER_TIME = 20
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Franken
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam,
		GM.Toppings.GrapeJam,
		#GM.Toppings.AppleJam
	]
	pass
