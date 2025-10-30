class_name Skeleton
extends Monster

func _ready():
	super._ready()
	WALK_SPEED = 2
	STEP_EVERY = 0.05
	STEP_TILT = 2
	
	soundsTalking = [
		load("res://sounds/skele1.mp3"),
		load("res://sounds/skele2.mp3"),
		load("res://sounds/skele3.mp3"),
	]
	soundsAngry = [
		load("res://sounds/skele4.mp3"),
		load("res://sounds/skele5.mp3"),
	]
	soundsPleased = [
		load("res://sounds/skele6.mp3"),
		load("res://sounds/skele7.mp3"),
	]
	
	soundsStep = [
		load("res://sounds/skelestep1.mp3"),
		load("res://sounds/skelestep2.mp3"),
		load("res://sounds/skelestep3.mp3"),
		load("res://sounds/skelestep4.mp3"),
	]
	pass
