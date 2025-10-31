class_name Franken
extends Monster

func _ready():
	super._ready()
	WALK_SPEED = 1
	STEP_EVERY = 0.5
	STEP_TILT = 10
	
	soundsTalking = [
		load("res://sounds/franken1.mp3"),
		load("res://sounds/franken2.mp3"),
		load("res://sounds/franken3.mp3"),
		load("res://sounds/franken10.mp3"),
	]
	soundsAngry = [
		load("res://sounds/franken5.mp3"),
		load("res://sounds/franken6.mp3"),
		load("res://sounds/franken7.mp3"),
		load("res://sounds/franken9.mp3"),
	]
	soundsPleased = [
		load("res://sounds/franken4.mp3"),
	]
	soundsSpecial = [
		load("res://sounds/franken8.mp3"),
	]
	
	soundsStep = [
		load("res://sounds/frankenstep1.mp3"),
		load("res://sounds/frankenstep2.mp3"),
		load("res://sounds/frankenstep3.mp3"),
		load("res://sounds/frankenstep4.mp3"),
	]
	 

var strSLAM1: String = "slam1"
var slam1Length: float = 0.5
var strSLAM2: String = "slam2"
var slam2Length: float = 0.2

var SLAM_POINT_DECREASE: int = 10

var SHAKE_RATE: float = 0.05
var SHAKE_DIST: float = 0.01
var shakeCount: int = 0
var shakeTimer: float = 0

var SLAM_DEPTH: float = 0.1

var ogSpritePos: Vector3

func at_counter_angry_reaction():
	ogSpritePos = sprite.position
	sprite.play(strSLAM1)
	await get_tree().create_timer(slam1Length, true, false,true).timeout
	
	sprite.position = ogSpritePos
	play_rand_special()
	sprite.play(strSLAM2)
	sprite.position.y = ogSpritePos.y - SLAM_DEPTH
	GM.add_score(-SLAM_POINT_DECREASE, global_position)
	await get_tree().create_timer(slam2Length, true, false,true).timeout
	sprite.position = ogSpritePos
	await get_tree().create_timer(slam2Length, true, false,true).timeout
	sprite.play("default")
	orderTimedOut.emit(self, false)
	pass

func _process(delta):
	super._process(delta)
	if posState == MonsterPositionState.Angry:
		if sprite.animation == strSLAM1:
			if shakeTimer > 0:
				shakeTimer -= delta
				pass
			else:
				shakeTimer = SHAKE_RATE
				shakeCount += 1
				if shakeCount % 2 == 0:
					sprite.position.x = SHAKE_DIST
				else:
					sprite.position.x = -SHAKE_DIST
			pass
		if sprite.animation == strSLAM2:
			if sprite.position.y < ogSpritePos.y:
				sprite.position.y += delta
				pass
			else:
				sprite.position.y = ogSpritePos.y
	pass

func order_timed_out():
	play_rand_angry()
	set_pos_state(MonsterPositionState.Angry)
	meter.visible = false
	orderTimedOutToCounter.emit(self)
	order = null
	pass
