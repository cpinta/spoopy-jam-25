extends Panel
class_name Fade

enum Type {ToBlack, FromBlack}
var _isFading: bool = false
var type: Type
var FADE_TIME: float = 1
var timer: float = 0

var styleBox: StyleBoxFlat

func _ready():
	styleBox = StyleBoxFlat.new()
	styleBox.bg_color = Color.BLACK
	

func _process(delta: float) -> void:
	if _isFading:
		styleBox.bg_color = Color(Color.BLACK, timer/FADE_TIME)
	pass

func fade(type:Type):
	match type:
		Type.ToBlack:
			timer = 0
			pass
		Type.FromBlack:
			timer = FADE_TIME
			pass
	pass
