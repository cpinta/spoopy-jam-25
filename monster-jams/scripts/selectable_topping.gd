extends SelectableItem
class_name SelectableTopping

@export var toppingEnum: GM.Toppings

func _ready():
	target = $StaticBody3D
	var jam: Sprite3D = $jam
	await get_tree().physics_frame
	jam.modulate = GM.dictToppings[toppingEnum].color
	
	WasSelectedSentItem = toppingEnum
	BeingHoveredCursorMode = GM.CursorMode.KNIFE
	
	super._ready()
	pass

func change_jam(topping: GM.Toppings):
	toppingEnum = topping
	var jam: Sprite3D = $jam
	jam.modulate = GM.dictToppings[toppingEnum].color
	pass
