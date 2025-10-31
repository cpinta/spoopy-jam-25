class_name Witch
extends Monster


func _ready():
	super._ready()
	WALK_SPEED = 1.5
	STEP_EVERY = 0.5
	STEP_TILT = 3
	
	soundsTalking = [
		load("res://sounds/witch1.mp3"),
		load("res://sounds/witch3.mp3"),
		load("res://sounds/witch4.mp3"),
	]
	soundsAngry = [
		load("res://sounds/witch7.mp3"),
		load("res://sounds/witch8.mp3"),
	]
	soundsPleased = [
		load("res://sounds/witch5.mp3"),
		load("res://sounds/witch2.mp3"),
	]
	
	soundsStep = [
		load("res://sounds/skelestep1.mp3"),
		load("res://sounds/skelestep2.mp3"),
		load("res://sounds/skelestep3.mp3"),
		load("res://sounds/skelestep4.mp3"),
	]
	
	soundsSpecial = [
		load("res://sounds/witch6.mp3"),
	]
	pass

var strCAST: String = "cast"

var PRE_CAST_LENGTH: float = 0.5
var PRE_CAST_DEPTH: float = 0.001
var POST_CAST_LENGTH: float = 0.5

var castAnimPhase: int = 0 

var ogSpritePos: Vector3

func at_counter_angry_reaction():
	ogSpritePos = sprite.position
	castAnimPhase = 1
	sprite.position.y = -PRE_CAST_DEPTH
	await get_tree().create_timer(PRE_CAST_LENGTH, true, false,true).timeout
	castAnimPhase = 2
	sprite.play(strCAST)
	sprite.position = ogSpritePos
	play_rand_special()
	sprite.position = ogSpritePos
	await get_tree().create_timer(POST_CAST_LENGTH, true, false,true).timeout
	sprite.play("default")
	orderTimedOut.emit(self, false)
	pass

func _process(delta):
	super._process(delta)
	if posState == MonsterPositionState.Angry:
		if castAnimPhase != 0:
			if castAnimPhase == 1:
				if sprite.position.y < ogSpritePos.y:
					sprite.position.y += delta
					pass
				else:
					sprite.position.y = ogSpritePos.y
					pass
				pass
			pass
	pass

func order_timed_out():
	play_rand_angry()
	set_pos_state(MonsterPositionState.Angry)
	meter.visible = false
	orderTimedOutToCounter.emit(self)
	order = null
	pass
