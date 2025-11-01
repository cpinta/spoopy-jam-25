extends SelectableItem
class_name SelectableShoe

func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame
	
	BeingHoveredCursorMode = GM.CursorMode.NONE
	
	super._ready()
	pass
