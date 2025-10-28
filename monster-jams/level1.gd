extends Level
class_name Level1

func _init() -> void:
	INTRO_TEXT = "Tonight should be an easy night"
	
	MAX_TOPPINGS_PER_SLICE = 1
	MAX_SANDWICH_SIZE = 1
	
	MIN_TIME_BT_MONSTERS = 4
	MAX_TIME_BT_MONSTERS = 8
	
	AVAILABLE_MONSTERS = [
		GM.Monster.Skeleton
	]
	AVAILABLE_TOPPINGS = [
		GM.Toppings.StrawberryJam
	]
	pass
