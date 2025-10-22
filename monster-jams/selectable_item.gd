extends Node3D
class_name SelectableItem

var BeingHoveredCursorMode:GM.CursorMode = GM.CursorMode.NONE

var target: Variant

signal WasSelected(Variant)
signal BeingHovered(int)
signal ExitBeingHovered()
var WasSelectedSentItem

func _ready() -> void:
	target.input_event.connect(_input_event)
	target.mouse_entered.connect(_enter)
	target.mouse_exited.connect(_exit)
	
	BeingHovered.connect(GM.cursor.set_cursor)
	ExitBeingHovered.connect(GM.cursor.remove_cursor)
	pass

func _input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.is_action("left_click"):
				_left_click()
			elif event.is_action("right_click"):
				pass

func _left_click():
	WasSelected.emit(WasSelectedSentItem)
	pass

func _enter():
	BeingHovered.emit(BeingHoveredCursorMode)
	pass

func _exit():
	ExitBeingHovered.emit()
	pass
