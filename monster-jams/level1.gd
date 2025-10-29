extends Level
class_name Level1

func _init() -> void:
	INTRO_TEXT = "Tonight should be an easy night"
	
	MAX_TOPPINGS_PER_SLICE = 1
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 4
	MAX_TIME_BT_MONSTERS = 8
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 40
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam
	]
	pass
