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
