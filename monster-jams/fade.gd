extends CanvasModulate
class_name Fade

enum Type {ToBlack = 1, FromBlack = 0}
var _isFading: bool = false
var type: Type
var FADE_TIME: float = 1
var timer: float = 0

signal faded(type: Fade.Type)

func _process(delta: float) -> void:
	if _isFading:
		if timer > 0:
			match(type):
				Type.ToBlack:
					color.a = 1- timer/FADE_TIME
				Type.FromBlack:
					color.a = timer/FADE_TIME
			timer -= delta
		else:
			color.a = type
			_isFading = false
			faded.emit(type)
	pass

func fade(type:Type):
	_isFading = true
	timer = FADE_TIME
	self.type = type
	pass
