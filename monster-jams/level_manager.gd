class_name LevelManager
extends Node

var levels: Array[Level] = []
var currentIndex: int = 0

var levelUI: LevelStartEndUI

signal noLevelsLeft()

func _ready() -> void:
	levelUI = $UI/LevelMenu
	levelUI.btnNext.pressed.connect(next_level)
	levelUI.btnRetry.pressed.connect(retry_level)
	
	add_level(Level1.new())
	pass

func _process(delta: float) -> void:
	pass

func add_level(level: Level):
	levels.append(level)

func next_level() -> bool:
	currentIndex += 1
	if currentIndex >= levels.size():
		noLevelsLeft.emit()
		return false
	return true

func retry_level():
	pass

func get_current_instance():
	pass

func start_current_level():
	pass
	
func end_current_level():
	pass

func set_level_index(index: int):
	currentIndex = index
