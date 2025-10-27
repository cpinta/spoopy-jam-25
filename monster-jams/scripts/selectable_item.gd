extends Node3D
class_name SelectableItem

var BeingHoveredCursorMode:GM.CursorMode = GM.CursorMode.NONE

var target: Variant

signal WasSelected(Variant)
signal BeingHovered(int)
signal ExitBeingHovered()
var WasSelectedSentItem

var _isSelectable: bool = true
var _isSelectableHoveredBuffer: bool = false

var _isTargetable: bool = true

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

func set_if_is_selectable(newIsSelectable: bool):
	self._isSelectable = newIsSelectable
	if newIsSelectable:
		if _isSelectableHoveredBuffer:
			BeingHovered.emit(BeingHoveredCursorMode)
	else:
		if _isSelectableHoveredBuffer:
			ExitBeingHovered.emit()
			pass
		pass
	pass

func set_if_is_targetable(newTargetable: bool):
	self._isTargetable = newTargetable
	if _isTargetable:
		if _isSelectableHoveredBuffer:
			if _isSelectable:
				BeingHovered.emit(BeingHoveredCursorMode)
		pass
	else:
		ExitBeingHovered.emit()
		pass
	pass

func _left_click():
	if not _isTargetable:
		return
	if not _isSelectable:
		return
	WasSelected.emit(WasSelectedSentItem)
	pass

func _enter():
	_isSelectableHoveredBuffer = true
	if not _isTargetable:
		return
	if not _isSelectable:
		return
	BeingHovered.emit(BeingHoveredCursorMode)
	pass

func _exit():
	_isSelectableHoveredBuffer = false
	if not _isTargetable:
		return
	if not _isSelectable:
		return
	ExitBeingHovered.emit()
	pass
