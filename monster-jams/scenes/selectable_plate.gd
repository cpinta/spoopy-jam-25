extends SelectableItem
class_name SelectablePlate

func _ready():
	target = self
	
	BeingHoveredCursorMode = GM.CursorMode.PLATE
	
	super._ready()
	pass
