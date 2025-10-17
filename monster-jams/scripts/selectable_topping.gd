extends Node
class_name SelectableTopping

@export var toppingEnum: GM.Toppings
var col: CollisionObject3D

signal WasSelected(int)

func _ready():
	col = $StaticBody3D
	col.input_event.connect(clicked)
	col.mouse_entered.connect(enter)
	var jam: Sprite3D = $jam
	await get_tree().physics_frame
	var top:Topping = GM.dictToppings.get(toppingEnum)
	jam.modulate = GM.dictToppings[toppingEnum].color
	#($jam).modulate = GM.dictToppings[topping]
	
	pass

func clicked(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
	if event.is_action("left_click"):
		if event.is_pressed():
			WasSelected.emit(toppingEnum)
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
