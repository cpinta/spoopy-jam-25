class_name GameInstance

var doIncreaseTimer: bool = false


var timer: float = 0
var prevHour: int = 0

var score: int = 0

signal scoreChanged(value:int)
signal hourPassed(value:int)
signal nightDone()

func _process(delta):
	if doIncreaseTimer:
		timer += delta
		if timer > (prevHour +1) * GM.HOUR_LENGTH:
			prevHour += 1
			hourPassed.emit(prevHour)
			if prevHour == GM.NIGHT_LENGTHS_HOURS:
				nightDone.emit()
				pass
			pass
	pass

func start():
	doIncreaseTimer = true
	set_time(0)
	set_score(0)
	pass

func add_score(value: int):
	set_score(score + value)
	pass

func set_score(value: int):
	score = value
	scoreChanged.emit(score)
	pass

func set_time(value: int):
	timer = value
	prevHour = floor(value/GM.HOUR_LENGTH)
	hourPassed.emit(prevHour)
	pass

func end():
	doIncreaseTimer = false
