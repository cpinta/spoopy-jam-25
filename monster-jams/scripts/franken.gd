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
	pass
