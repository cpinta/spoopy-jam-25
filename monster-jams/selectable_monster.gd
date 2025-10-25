extends SelectableItem
class_name SelectableMonster

func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame
	BeingHoveredCursorMode = GM.CursorMode.TALK
	
	super._ready()
	pass
