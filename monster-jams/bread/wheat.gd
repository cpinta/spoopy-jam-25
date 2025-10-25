extends Bread
class_name Wheat

func _init():
	breadType = GM.BreadType.Wheat
	breadName = "Wheat"
	desc = "yep. Thats wheat bread"
	scene = load("res://scenes/bread.tscn")
	icon = load("res://sprites/bread icon.png")
	pass
