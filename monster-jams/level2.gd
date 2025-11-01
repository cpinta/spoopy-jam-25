extends Level
class_name Level2

func _init() -> void:
	
	MAX_TOPPINGS_PER_SLICE = 2
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 3
	MAX_TIME_BT_MONSTERS = 6
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 20
	ORDER_TIME = 20
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
		GM.Monster.Slime
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam
	]
	WORLD_COLOR = Color.hex(0x0064c8)

	INTRO_TEXT = "make $"+str(NEEDED_PROFIT)+" tonight\ncustomers want more variety"
	pass
