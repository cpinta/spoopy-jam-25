extends Level
class_name Level3

func _init() -> void:
	INTRO_TEXT = "ya need $60, STAT\ncareful not to annoy Frankenstein's creation"
	
	MAX_TOPPINGS_PER_SLICE = 2
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 3
	MAX_TIME_BT_MONSTERS = 6
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 60
	ORDER_TIME = 20
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
		GM.Monster.Slime,
		GM.Monster.Franken
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam
	]
	pass
