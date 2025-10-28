class_name LevelManager
extends Node3D

var levels: Array[Level] = []
var currentIndex: int = 0

var levelUI: LevelStartEndUI

var nightTimer: float = 0
var inLevel: bool = false

var fade: Fade

signal startLevel(level: Level)
signal noLevelsLeft()

func _ready() -> void:
	levelUI = $UI/LevelMenu
	fade = $UI/Fade
	levelUI.btnNext.pressed.connect(next_level)
	levelUI.btnRetry.pressed.connect(retry_level)
	
	add_level(Level1.new())
	pass

func _process(delta: float) -> void:
	if inLevel:
		if nightTimer > 0:
			nightTimer -= delta
		else:
			end_current_level()
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
	fade.fade(Fade.Type.ToBlack)
	await get_tree().create_timer(1, true, false, true).timeout
	start_current_level()
	pass

func get_current_level():
	return levels[currentIndex]

func start_current_level():
	startLevel.emit()
	inLevel = true
	nightTimer = get_current_level().NIGHT_LENGTH
	fade.fade(Fade.Type.FromBlack)
	pass
	
func show_end_current_level_menu():
	
	pass

func end_current_level():
	fade.fade(Fade.Type.ToBlack)
	pass

func set_level_index(index: int):
	currentIndex = index
