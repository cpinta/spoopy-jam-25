extends Level
class_name Level4

func _init() -> void:
	
	MAX_TOPPINGS_PER_SLICE = 2
	MAX_SANDWICH_SIZE = 2
	
	MIN_TIME_BT_MONSTERS = 3
	MAX_TIME_BT_MONSTERS = 6
	
	
	if GM.debug:
		MIN_TIME_BT_MONSTERS = 0.1
		MAX_TIME_BT_MONSTERS = 0.2
	
	NEEDED_PROFIT = 30
	ORDER_TIME = 15
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton,
		GM.Monster.Slime,
		GM.Monster.Franken
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam,
		GM.Toppings.BlueberryJam,
		GM.Toppings.GrapeJam
	]
	WORLD_COLOR = Color.hex(0x9a5300)
	INTRO_TEXT = "$"+str(NEEDED_PROFIT)+"!? lock in!\nuse that new jam we ordered"
	
	pass
