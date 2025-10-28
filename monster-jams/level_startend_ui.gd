extends Panel
class_name LevelStartEndUI

var lbl: Label
var btnRetry: Button
var btnNext: Button

func _ready() -> void:
	btnNext = $"Control/Next Button"
	btnRetry = $"Control/Retry Button"
	lbl = $text
	pass

func show_lost_screen():
	lbl.text = "You didn't make it through the night"
	btnNext.visible = false
	btnRetry.visible = true
	

func show_win_screen():
	lbl.text = "You survived the night!"
	btnNext.visible = true
	btnRetry.visible = false
