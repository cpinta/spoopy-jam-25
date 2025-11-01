class_name GameInstance

var doIncreaseTimer: bool = false


var timer: float = 0
var prevHour: int = 0

var score: int = 0

var MINUTE_LENGTH: float = GM.HOUR_LENGTH/60
var prevMinute: int = 0

signal scoreChanged(value:int)
signal hourPassed(value:int)
signal intervalPassed(value:int)
signal nightDone()

func _process(delta):
	if GM.debug:
		timer += delta * 100
		pass
	if doIncreaseTimer:
		timer += delta
		if timer > (prevHour + 1) * GM.HOUR_LENGTH:
			prevHour = timer/GM.HOUR_LENGTH
			hourPassed.emit(prevHour)
			if prevHour == GM.NIGHT_LENGTHS_HOURS:
				nightDone.emit()
				pass
			pass
		if timer > (prevMinute+1) * MINUTE_LENGTH:
			prevMinute = timer/MINUTE_LENGTH
			#prevInterval = timer/GM.HOUR_LENGTH/12
			if prevMinute % 5 == 0:
				intervalPassed.emit(prevMinute)
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
