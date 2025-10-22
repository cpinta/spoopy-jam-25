extends SelectableItem
class_name SelectableBread

@export var bread: GM.BreadType


func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame
	
	WasSelectedSentItem = bread
	match bread:
		GM.BreadType.Wheat:
			BeingHoveredCursorMode = GM.CursorMode.BREAD
		GM.BreadType.Bagel:
			BeingHoveredCursorMode = GM.CursorMode.BAGEL
	
	super._ready()
	pass
