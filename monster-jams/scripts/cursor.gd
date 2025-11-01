class_name Cursor
extends Node2D


var mode: GM.CursorMode
var sprite: AnimatedSprite2D
var curTopping: GM.Toppings = GM.Toppings.None
var audio: AudioStreamPlayer
var audioJam: AudioStreamPlayer

const strNONE: String = "none"
const strKNIFE: String = "knife"
const strBREAD: String = "bread"
const strBAGEL: String = "bagel"
const strHAM: String = "ham"
const strTALK: String = "talk"
const strPLATE: String = "plate"
const strRENT: String = "rent"

var soundsJam: Array[AudioStream] = [
	load("res://sounds/jam1.mp3"),
	load("res://sounds/jam2.mp3"),
	load("res://sounds/jam3.mp3"),
	load("res://sounds/jam4.mp3"),
	load("res://sounds/jam5.mp3"),
]

var soundsTsss: Array[AudioStream] = [
	load("res://sounds/tsss.mp3"),
	load("res://sounds/tsss2.mp3"),
	load("res://sounds/tsss3.mp3"),
]

var soundsPlate: Array[AudioStream] = [
	load("res://sounds/plate1.mp3"),
	load("res://sounds/plate2.mp3"),
	load("res://sounds/plate3.mp3"),
	load("res://sounds/plate4.mp3"),
	load("res://sounds/plate5.mp3"),
	load("res://sounds/plate6.mp3")
]

var soundsJamSpread: AudioStream = load("res://sounds/spread.mp3")

var currentImage: Image
var targetTexture: ImageTexture

var jamOverlay: Sprite2D
var curColor: Color = Color.GREEN

const JAM_MIN_ALPHA: float = .1
const MAX_JAM_AMOUNT: int = 20000
const JAM_DECREASE_PER_PX: float = 1
var amountJamOnKnife: float = 0

var jamAmountsApplied: = {}

func _ready():
	sprite = $sprite
	jamOverlay = $sprite/jam
	audio = $audio
	audioJam = $audioJam
	jamOverlay.visible = false
	
	amountJamOnKnife = MAX_JAM_AMOUNT
	pass

func get_current_jam() -> GM.Toppings:
	return curTopping

func apply_jam_pixels(pxCount: int):
	if curTopping == GM.Toppings.None:
		jamOverlay.visible = false
		return
	amountJamOnKnife -= pxCount * JAM_DECREASE_PER_PX
	if amountJamOnKnife < 0:
		amountJamOnKnife = 0
		jamOverlay.modulate = Color.TRANSPARENT
		amountJamOnKnife = 0
		curTopping = GM.Toppings.None
	else:
		var alpha: float = JAM_MIN_ALPHA + (amountJamOnKnife/MAX_JAM_AMOUNT)
		jamOverlay.modulate = Color(curColor, alpha)
		if not audio.stream == soundsJamSpread:
			audio.stream = soundsJamSpread
		if not audio.playing:
			audio.play()
		audio.volume_db = -20 + (1 * (pxCount/56))
		audio.pitch_scale = 1.2 + amountJamOnKnife/MAX_JAM_AMOUNT
	pass

func has_jam_left_on_it():
	if amountJamOnKnife > 0:
		return true
	return false

func topping_selected(topping: GM.Toppings):
	if GM.is_knife_topping(topping):
		GM.play_rand_audio(audioJam, soundsJam)
		set_cursor(GM.CursorMode.KNIFE)
		jamOverlay.visible = true
		curColor = GM.dictToppings[topping].color
		curTopping = topping
		jamOverlay.modulate = curColor
		
		amountJamOnKnife = MAX_JAM_AMOUNT
	else:
		match(topping):
			GM.Toppings.Ham:
				set_cursor(GM.CursorMode.HAM)
				pass
	pass

func bread_selected(bread: GM.BreadType):
	#set_cursor(GM.CursorMode.NONE)
	GM.play_rand_audio(audio, soundsTsss)
	pass


func set_cursor(mode:GM.CursorMode):
	self.mode = mode
	match(mode):
		GM.CursorMode.NONE:
			jamOverlay.visible = false
			sprite.play(strNONE)
			pass
		GM.CursorMode.KNIFE:
			if curTopping == GM.Toppings.None:
				jamOverlay.visible = false
			else:
				jamOverlay.visible = true
			sprite.play(strKNIFE)
			pass
		GM.CursorMode.BREAD:
			jamOverlay.visible = false
			sprite.play(strBREAD)
			pass
		GM.CursorMode.BAGEL:
			jamOverlay.visible = false
			sprite.play(strNONE)
			pass
		GM.CursorMode.HAM:
			jamOverlay.visible = false
			sprite.play(strNONE)
			pass
		GM.CursorMode.TALK:
			jamOverlay.visible = false
			sprite.play(strTALK)
			pass
		GM.CursorMode.PLATE:
			jamOverlay.visible = false
			sprite.play(strPLATE)
			pass
		GM.CursorMode.RENT:
			jamOverlay.visible = false
			sprite.play(strRENT)
			pass
	pass

func remove_cursor():
	if curTopping == GM.Toppings.None:
		set_cursor(GM.CursorMode.NONE)
		pass
	else:
		set_cursor(GM.CursorMode.KNIFE)
	pass
