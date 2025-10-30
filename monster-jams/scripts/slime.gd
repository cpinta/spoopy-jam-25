class_name Slime
extends Monster

func _ready():
	super._ready()
	WALK_SPEED = 1
	STEP_EVERY = 0.25
	STEP_SCALE_ADD = Vector2(0.5, 0.25)
	walkAnim = MonsterWalkAnim.Squash
	
	soundsTalking = [
		load("res://sounds/slime1.mp3"),
		load("res://sounds/slime2.mp3"),
		load("res://sounds/slime3.mp3"),
		load("res://sounds/slime7.mp3"),
		load("res://sounds/slime11.mp3"),
		load("res://sounds/slime10.mp3"),
	]
	soundsAngry = [
		load("res://sounds/slime8.mp3"),
	]
	soundsPleased = [
		load("res://sounds/slime4.mp3"),
		load("res://sounds/slime5.mp3"),
		load("res://sounds/slime6.mp3"),
	]
	
	soundsStep = [
		load("res://sounds/slimestep1.mp3"),
		load("res://sounds/slimestep2.mp3"),
		load("res://sounds/slimestep3.mp3"),
		load("res://sounds/slimestep4.mp3"),
	]
	pass
