class_name UI
extends CanvasLayer

var btnTable: Button
var btnCounter: Button

signal sTablePressed
signal sCounterPressed

var fade: Fade
var topUI: TopUI

func _ready():
	fade = $Fade
	btnTable = $Control/lowerhalf/TableButton
	btnCounter = $Control/upperhalf/CounterButton
	topUI = $"Control/upperhalf/top ui"
	btnTable.button_up.connect(_table_pressed)
	btnCounter.button_up.connect(_counter_pressed)
	pass

func _process(delta):
	match GM.camState:
		GM.CamView.Counter:
			btnTable.visible = true
			btnCounter.visible = false
			pass
		GM.CamView.JellyTable:
			btnTable.visible = false
			btnCounter.visible = true
			pass
	pass



func _table_pressed():
	sTablePressed.emit()
	pass

func _counter_pressed():
	sCounterPressed.emit()
	pass
