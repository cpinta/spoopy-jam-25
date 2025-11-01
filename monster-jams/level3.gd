extends Level
class_name Level3

func _init() -> void:
	
	MAX_TOPPINGS_PER_SLICE = 2
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 3
	MAX_TIME_BT_MONSTERS = 6
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 25
	ORDER_TIME = 15
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
		GM.Monster.Slime,
		GM.Monster.Franken
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam
	]
	WORLD_COLOR = Color.hex(0x007873)
	INTRO_TEXT = "ya need $"+str(NEEDED_PROFIT)+", STAT\ncareful not to annoy Frankenstein's monster"

	pass
