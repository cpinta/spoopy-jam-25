class_name LevelManager
extends Node3D

var levels: Array[Level] = []
var currentIndex: int = 0

var levelUI: LevelStartEndUI
var titleScreen: TitleScreen

var nightTimer: float = 0
var inLevel: bool = false

var fade: Fade

signal startLevel(level: Level)
signal noLevelsLeft()

func _ready() -> void:
	levelUI = $UI/LevelMenu
	levelUI.btnNext.pressed.connect(next_level)
	levelUI.btnRetry.pressed.connect(retry_level)
	fade = $FadeCanvas/Fade
	fade.fade(Fade.Type.FromBlack)
	fade.faded.connect(faded)
	
	titleScreen = $TitleScreen
	titleScreen.start_clicked.connect(start_game_clicked)
	
	startLevel.connect(GM.level_starting)
	
	add_level(Level5.new())
	pass

func start_game_clicked():
	fade.fade(Fade.Type.ToBlack)
	pass

func faded(type: Fade.Type):
	match type:
		Fade.Type.ToBlack:
			if GM.state == GM.GameState.Title:
				titleScreen.hide_title()
				start_game()
	pass

func start_game():
	start_current_level()
	
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
	startLevel.emit(get_current_level())
	inLevel = true
	fade.fade(Fade.Type.FromBlack)
	pass
	
func show_end_current_level_menu():
	
	pass

func end_current_level():
	fade.fade(Fade.Type.ToBlack)
	pass

func set_level_index(index: int):
	currentIndex = index
