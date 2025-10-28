class_name GameInstance

var doIncreaseTimer: bool = false
var timer: float = 0

var score: int = 0

func _process(delta):
	if doIncreaseTimer:
		timer += delta
	pass

func start():
	doIncreaseTimer = true
	timer = 0
	score = 0
	pass

func add_score(value: int):
	score += value
	pass

func end():
	doIncreaseTimer = false
