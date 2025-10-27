extends SelectableItem
class_name SelectableMonster


func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame
	BeingHoveredCursorMode = GM.CursorMode.TALK
	WasSelectedSentItem = self
	super._ready()
	pass

func at_counter():
	BeingHoveredCursorMode = GM.CursorMode.TALK
	pass

func in_line():
	BeingHoveredCursorMode = GM.CursorMode.BREAD
	pass
