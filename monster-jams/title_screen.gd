extends CanvasLayer
class_name TitleScreen

var button: Button

signal start_clicked

func _ready() -> void:
	button = $Control/background/Button
	button.pressed.connect(func_start_clicked)
	pass

func func_start_clicked():
	start_clicked.emit()
	pass

func hide_title():
	queue_free()
	pass
