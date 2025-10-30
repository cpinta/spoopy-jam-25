extends CanvasLayer
class_name TitleScreen

var introText: Array[String] = [
	"Pam loves jam. In her work, she put her soul",
	"Pam sold jam but needed profits sixfold",
	"Pam met Gram Gram, a book she was sold",
	"Gram handed it over with promises of gold",
	"Pam made a pentagram to help hit her goal",
	"Pam's night began, and the streets got cold",
	"Pam's product was no longer undersold",
	"but Pam's Jams' was now where monsters patrolled",
	"Pam needed to withstand to pass the rent's threshold",
	"Pam didn't scram. She was determined and bold",
	"Pam's Jam sandwiches would feed til monsters were consoled"
]

var introSounds: Array[AudioStream] = [
	load("res://sounds/intro1.mp3"),
	load("res://sounds/intro2.mp3"),
	load("res://sounds/intro3.mp3"),
	load("res://sounds/intro4.mp3"),
	load("res://sounds/intro5.mp3"),
	load("res://sounds/intro2.mp3"),
	load("res://sounds/intro6.mp3"),
	load("res://sounds/intro7.mp3"),
	load("res://sounds/intro8.mp3"),
	load("res://sounds/intro9.mp3"),
	load("res://sounds/intro10.mp3"),
]

var button: Button
var shopdoor: Panel
var lblIntroTxt: Label
var pnlIntro: Panel
var audio: AudioStreamPlayer

var sprite: AnimatedSprite2D
var pnlNonIntro: Panel

var INTRO_TEXT_SCROLL_SPEED: float = 10

signal start_clicked

func _ready() -> void:
	visible = true
	button = $Control/background/Button
	button.pressed.connect(func_start_clicked)
	
	$"Control/background/Intro Panel/Control/Skip".pressed.connect(skip_intro)
	lblIntroTxt = $"Control/background/Intro Panel/intro text"
	lblIntroTxt.text = introText[0]
	pnlIntro = $"Control/background/Intro Panel"
	pnlIntro.visible = true
	
	pnlNonIntro = $"Control/background/NonIntro Panel"
	pnlNonIntro.visible = false
	
	sprite = $"Control/background/Intro Panel/AnimatedSprite2D"
	sprite.play(intro_anim_prefix + str(0))
	
	audio = $audio
	
	shopdoor = $"Control/background/shop door"
	shopdoor.visible = false
	
	if GM.debug:
		skip_intro()
	
	pass

var intro_anim_prefix: String = "new_animation_"
var intro_frame_time: float = 6
var timer: float = 0

var stepTimer: float = 0
var stepTime: float = 1.25
var stepTilt: float = 2
var stepCount: int = 0

var intro_index: int = 0
var frame_count: int = 11

var wasPressed: bool = false

func _process(delta: float) -> void:
	if pnlIntro:
		sprite.global_position = $Control.size/2
		if timer > 0:
			timer -= delta
		else:
			intro_goto_frame(intro_index)
		if stepTimer > 0:
			stepTimer -= delta
		else:
			if stepCount % 2 == 0:
				sprite.rotation_degrees = stepTilt
			else:
				sprite.rotation_degrees = -stepTilt
			stepTimer = stepTime
			stepCount += 1
		if wasPressed:
			button.hover
			pass
	pass

func intro_goto_frame(index: int):
	if index < frame_count:
		sprite.play(intro_anim_prefix + str(index))
		timer = intro_frame_time
		lblIntroTxt.text = introText[intro_index]
		audio.stream = introSounds[intro_index]
		audio.play()
		intro_index += 1
	else:
		skip_intro()
	pass

func func_start_clicked():
	shopdoor.visible = true
	button.queue_free()
	start_clicked.emit()
	pass

func hide_title():
	queue_free()
	pass

func skip_intro():
	pnlIntro.queue_free()
	pnlNonIntro.visible = true
	pass
