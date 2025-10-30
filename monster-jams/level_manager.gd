class_name LevelManager
extends Node3D

var levels: Array[Level] = []
var currentIndex: int = 0

var levelUI: LevelStartEndUI
var titleScreen: TitleScreen

var nightTimer: float = 0
var inLevel: bool = false

var fadingToNextLevel: bool = false

var fade: Fade

signal startLevel(level: Level)
signal endLevel(level: Level)
signal noLevelsLeft()

func _ready() -> void:
	levelUI = $UI/LevelMenu
	levelUI.btnNext.pressed.connect(end_current_level)
	levelUI.btnRetry.pressed.connect(retry_level)
	fade = $FadeCanvas/Fade
	fade.fade(Fade.Type.FromBlack)
	fade.faded.connect(faded)
	
	titleScreen = $TitleScreen
	titleScreen.start_clicked.connect(start_game_clicked)
	
	startLevel.connect(GM.level_starting)
	
	add_level(Level1.new())
	add_level(Level2.new())
	add_level(Level3.new())
	add_level(Level4.new())
	add_level(Level5.new())
	pass

func start_game_clicked():
	fade.fade(Fade.Type.ToBlack)
	pass

func faded(type: Fade.Type):
	if GM.state == GM.GameState.Title:
		if type == Fade.Type.ToBlack:
			titleScreen.hide_title()
			start_game()
		return
		
	match type:
		Fade.Type.ToBlack:
			if fadingToNextLevel:
				start_next_level()
			pass
		Fade.Type.FromBlack:
			pass
	pass

func start_game():
	start_current_level()
	
	pass

func _process(delta: float) -> void:
	if inLevel:
		if nightTimer > 0:
			nightTimer -= delta
		else:
			end_current_level(true)
	pass

func add_level(level: Level):
	levels.append(level)

func start_next_level() -> bool:
	currentIndex += 1
	if currentIndex >= levels.size():
		noLevelsLeft.emit()
		return false
	start_current_level()
	return true

func retry_level():
	fadingToNextLevel = false
	fade.fade(Fade.Type.ToBlack)
	await get_tree().create_timer(1, true, false, true).timeout
	end_current_level(false)
	pass

func get_current_level():
	return levels[currentIndex]

func start_current_level():
	startLevel.emit(get_current_level())
	inLevel = true
	fade.fade(Fade.Type.FromBlack)
	pass
	
func show_end_current_level_menu():
	levelUI.visible = true
	pass

func end_current_level(gotoNext: bool):
	endLevel.emit(get_current_level())
	fadingToNextLevel = gotoNext
	fade.fade(Fade.Type.ToBlack)
	pass

func set_level_index(index: int):
	currentIndex = index
