extends Node
class_name SelectableTopping

@export var topping: GM.Toppings
var col: CollisionObject3D

signal WasSelected(int)

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	col.mouse_entered.connect(enter)
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	WasSelected.emit(topping)
	if event.is_action("left_click"):
		if event.is_pressed():
			WasSelected.emit(topping)
			pass
		elif event.is_released():
			pass
		pass
	elif event.is_action("right_click"):
		if event.is_pressed():
			pass
		elif event.is_released():
			pass
		pass
	pass

func enter():
	pass
