extends Control
class_name InputHandler

enum GameInput {MOUSE=0, TOUCH=1}

var curInputMethod: GameInput

var inputVector: Vector2

var touchScene: PackedScene
#var touchUI: TouchControls
var touchUI: Node

var cursor: Cursor

signal inputLeftClickPressed(Vector2)
signal inputLeftClickReleased(Vector2)
var leftClickCurrentlyPressed: bool = false

signal inputSet(input: GameInput)


# Called when the node enters the scene tree for the first time.
func _ready():
	if touchScene == null:
		#touchScene = load("res://scripts/input/touch_controls.tscn")
		pass
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	match curInputMethod:
		GameInput.MOUSE:
			if Input.is_action_just_pressed("left_click"):
				left_click_pressed(get_global_mouse_position())
			if Input.is_action_just_released("left_click"):
				left_click_released(get_global_mouse_position())
			pass
			if GM.cursor:
				match(GM.camState):
					GM.CamView.Counter:
						GM.cursor.visible = false
						pass
					GM.CamView.JellyTable:
						GM.cursor.global_position = get_global_mouse_position()
						GM.cursor.visible = true
						pass
		GameInput.TOUCH:
			pass
	pass
	
func left_click_pressed(pos: Vector2):
	inputLeftClickPressed.emit(pos)
	leftClickCurrentlyPressed = true
func left_click_released(pos: Vector2):
	inputLeftClickReleased.emit(pos)
	leftClickCurrentlyPressed = false
	
	

func load_controls():
	match curInputMethod:
		GameInput.MOUSE:
			pass
		GameInput.TOUCH:
			load_touch_controls()
			#touchUI.btnDash.released.connect(input_dash)
			#touchUI.btnInteract.released.connect(input_interact)
			#touchUI.btnDrop.released.connect(input_drop)
			
			pass
	pass
	
func unload_controls():
	match curInputMethod:
		GameInput.MOUSE:
			pass
		GameInput.TOUCH:
			unload_touch_controls()
			pass
	pass

func set_input_method(newInput: GameInput):
	if touchScene == null:
		_ready()

	curInputMethod = newInput
	match curInputMethod:
		GameInput.MOUSE:
			unload_touch_controls()
			pass
		GameInput.TOUCH:
			load_touch_controls()
			pass
	load_controls()
	pass

func load_touch_controls():
	if touchUI == null:
		touchUI = touchScene.instantiate()
		self.add_child(touchUI)
		touchUI._ready()
	pass
	
func unload_touch_controls():
	if touchUI != null:
		touchUI.queue_free()
	pass
