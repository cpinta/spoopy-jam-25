extends Level
class_name Level1

func _init() -> void:
	INTRO_TEXT = "you've got customers!\nmake $20 before 4 a.m."
	
	MAX_TOPPINGS_PER_SLICE = 1
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 5
	MAX_TIME_BT_MONSTERS = 8
	
	
	MIN_TIME_BT_MONSTERS = 0.1
	MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 20
	ORDER_TIME = 20
	
	MAX_MONSTERS_AT_A_TIME = 5
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
		ORDER_TIME = 1
		MAX_MONSTERS_AT_A_TIME = 1
	
	
	AVAILABLE_MONSTERS = [
		#GM.Monster.Skeleton,
		GM.Monster.Witch
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam
	]
	pass
