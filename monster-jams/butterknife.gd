class_name Cursor
extends Node2D

enum CursorMode {NONE, KNIFE, BREAD, BAGEL, HAM}

var mode: CursorMode
var sprite: AnimatedSprite2D
var curTopping: GM.Toppings

const strNONE: String = "none"
const strKNIFE: String = "knife"
const strBREAD: String = "bread"
const strBAGEL: String = "bagel"
const strHAM: String = "ham"

var currentImage: Image
var targetTexture: ImageTexture

var jamOverlay: Sprite2D

func _ready():
	jamOverlay = $sprite/jam
	pass

func _process(delta):
	pass

func topping_selected(topping: GM.Toppings):
	if GM.is_knife_topping(topping):
		set_cursor(CursorMode.KNIFE)
	else:
		match(topping):
			GM.Toppings.Ham:
				set_cursor(CursorMode.HAM)
				pass
	pass

func set_cursor(mode:CursorMode):
	self.mode = mode
	match(mode):
		CursorMode.NONE:
			sprite.play(strNONE)
			pass
		CursorMode.KNIFE:
			sprite.play(strKNIFE)
			pass
		CursorMode.BREAD:
			pass
		CursorMode.BAGEL:
			pass
		CursorMode.HAM:
			sprite.play(strHAM)
			pass
	pass

func write_around_point(pos: Vector2i, color:Color):
	currentImage.set_pixelv(pos, color)
	pass
