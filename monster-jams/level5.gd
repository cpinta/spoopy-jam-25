extends Level
class_name Level5

func _init() -> void:
	
	MAX_TOPPINGS_PER_SLICE = 3
	MAX_SANDWICH_SIZE = 2
	
	MIN_TIME_BT_MONSTERS = 3
	MAX_TIME_BT_MONSTERS = 6
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 40
	ORDER_TIME = 10
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
		GM.Monster.Slime,
		GM.Monster.Franken,
		GM.Monster.Witch
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam,
		GM.Toppings.GrapeJam
		#GM.Toppings.AppleJam
	]
	WORLD_COLOR = Color.hex(0xc50003)
	INTRO_TEXT = "they're extra rowdy tonight!\nsurvive with $"+str(NEEDED_PROFIT)+" and the monsters will leave!"
	
	pass
