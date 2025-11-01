extends Level
class_name Level1

func _init() -> void:
	MAX_TOPPINGS_PER_SLICE = 1
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 4
	MAX_TIME_BT_MONSTERS = 8
	
	#
	#MIN_TIME_BT_MONSTERS = 0.1
	#MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 10
	ORDER_TIME = 20
	
	MAX_MONSTERS_AT_A_TIME = 5
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
		ORDER_TIME = 1
		MAX_MONSTERS_AT_A_TIME = 1
		NEEDED_PROFIT = 0
	
	WORLD_COLOR = Color.hex(0x7200ff)
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam
	]
	
	INTRO_TEXT = "you've got customers!\nmake $"+str(NEEDED_PROFIT)+" before 4 a.m."
	pass
