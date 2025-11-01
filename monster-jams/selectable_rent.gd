extends SelectableItem
class_name SelectableRent

func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame

	BeingHoveredCursorMode = GM.CursorMode.RENT
	
	super._ready()
	pass
