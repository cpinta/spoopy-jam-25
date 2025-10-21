extends SelectableItem
class_name SelectableTopping

@export var toppingEnum: GM.Toppings

func _ready():
	target = $StaticBody3D
	var jam: Sprite3D = $jam
	await get_tree().physics_frame
	var top:Topping = GM.dictToppings.get(toppingEnum)
	jam.modulate = GM.dictToppings[toppingEnum].color
	
	WasSelectedSentItem = toppingEnum
	BeingHoveredCursorMode = GM.CursorMode.KNIFE
	
	super._ready()
	pass
