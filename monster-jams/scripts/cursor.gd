class_name Cursor
extends Node2D


var mode: GM.CursorMode
var sprite: AnimatedSprite2D
var curTopping: GM.Toppings = GM.Toppings.None

const strNONE: String = "none"
const strKNIFE: String = "knife"
const strBREAD: String = "bread"
const strBAGEL: String = "bagel"
const strHAM: String = "ham"

var currentImage: Image
var targetTexture: ImageTexture

var jamOverlay: Sprite2D
var curColor: Color = Color.GREEN

const JAM_MIN_ALPHA: float = .1
const MAX_JAM_AMOUNT: int = 100
const JAM_DECREASE_PER_PX: float = 0.1
var amountJamOnKnife: float = 0

var jamAmountsApplied: = {}

func _ready():
	sprite = $sprite
	jamOverlay = $sprite/jam
	jamOverlay.visible = false
	
	amountJamOnKnife = MAX_JAM_AMOUNT
	pass

func _process(delta):
	pass

func get_current_jam() -> GM.Toppings:
	return curTopping

func apply_jam_pixels(pxCount: int):
	if curTopping == GM.Toppings.None:
		return
	amountJamOnKnife -= pxCount * JAM_DECREASE_PER_PX
	if amountJamOnKnife < 0:
		amountJamOnKnife = 0
		jamOverlay.modulate = Color.TRANSPARENT
		amountJamOnKnife = 0
		curTopping = GM.Toppings.None
	else:
		var alpha: float = JAM_MIN_ALPHA + (amountJamOnKnife/MAX_JAM_AMOUNT)
		jamOverlay.modulate = Color(curColor, alpha)
	pass

func has_jam_left_on_it():
	if amountJamOnKnife > 0:
		return true
	return false

func topping_selected(topping: GM.Toppings):
	if GM.is_knife_topping(topping):
		set_cursor(GM.CursorMode.KNIFE)
		jamOverlay.visible = true
		curColor = GM.dictToppings[topping].color
		curTopping = topping
		jamOverlay.modulate = curColor
		
		amountJamOnKnife = MAX_JAM_AMOUNT
	else:
		match(topping):
			GM.Toppings.Ham:
				set_cursor(GM.CursorMode.HAM)
				pass
	pass

func set_cursor(mode:GM.CursorMode):
	self.mode = mode
	match(mode):
		GM.CursorMode.NONE:
			sprite.play(strNONE)
			pass
		GM.CursorMode.KNIFE:
			sprite.play(strKNIFE)
			pass
		GM.CursorMode.BREAD:
			pass
		GM.CursorMode.BAGEL:
			pass
		GM.CursorMode.HAM:
			sprite.play(strHAM)
			pass
	pass

func remove_cursor():
	if curTopping == GM.Toppings.None:
		set_cursor(GM.CursorMode.NONE)
		pass
	pass
