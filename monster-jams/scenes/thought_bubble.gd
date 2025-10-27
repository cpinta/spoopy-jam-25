extends SpeechBubble
class_name ThoughtBubble

var _isAlive: bool = false
const ALIVE_TIME: float = 2
var _timer: float = 0

func _ready() -> void:
	super._ready()
	
	TIME_BT_PIECE = 0
	KEEP_SPRITES_VISIBLE_ON_CREATION = true
	pass

func _process(delta: float) -> void:
	if _isAlive:
		if _timer > 0:
			_timer -= delta
		else:
			_isAlive = false
			visible = false
	pass

func show_bubble_for_a_time(time: float = -1):
	if time == -1:
		time = ALIVE_TIME
	_timer = time
	visible = true
	_isAlive = true
	pass
