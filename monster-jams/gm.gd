class_name GameManager
extends Node

enum GameState {Title, InGame, End}

var debug: bool = false
var state: GameState

var ui: UI
var cam: GameCamera

var input: InputHandler
var audio: AudioStreamPlayer

var asError: AudioStream = load("res://sounds/error sound.mp3")
var asMusic: AudioStream = load("res://sounds/WTF! Ghost!.mp3")

var jamTable: JellyTable

var camState: GM.CamView = GM.CamView.Counter

enum Monster { Franken, Skeleton, Slime, Witch }
enum CamView {Counter, JellyTable}
enum Toppings {StrawberryJam=0, AppleJam=1, BlueberryJam=2, GrapeJam=3, Ham=4,None=-1}
var dictToppings = {
	Toppings.StrawberryJam: StrawberryJam.new(),
	Toppings.BlueberryJam: BlueberryJam.new(), 
	Toppings.GrapeJam: GrapeJam.new(), 
	Toppings.AppleJam: AppleJam.new(), 
	Toppings.Ham: Ham.new()}
enum BreadType {Wheat=0, Bagel=1}
var dictBread = {
	BreadType.Wheat: Wheat.new(),
	BreadType.Bagel: Bagel.new()}
enum CursorMode {NONE, KNIFE, BREAD, BAGEL, HAM, TALK, PLATE, RENT}

var cursor: Cursor
var monsterManager: MonsterManager
var entrance: PathNode
var gameInstance: GameInstance
var root: Node3D
var plate: Plate
var levelManager: LevelManager
var inLevel: bool = false

const HOUR_LENGTH: float = 25
const NIGHT_LENGTHS_HOURS: int = 4

var scenePointsAddedDisplay: PackedScene = load("res://scenes/points_added_display.tscn")

# shop located in conneticut
var end: End
var endScene: PackedScene = load("res://scenes/end.tscn")

func _ready():
	root = get_global_node("root")
	levelManager = root as LevelManager
	ui = get_global_node("ui")
	cam = get_global_node("camera")
	input = get_global_node("input")
	cursor = get_global_node("knife")
	jamTable = get_global_node("jamTable")
	monsterManager = get_global_node("monsterManager")
	monsterManager.initialize(get_global_node("counterfront"), get_global_node("waiting"))
	entrance = get_global_node("entrance")
	plate = get_global_node("plate")
	audio = root.get_node("audio")
	
	levelManager.noLevelsLeft.connect(game_end)
	
	monsterManager.entrance = entrance
	await get_tree().physics_frame
	
	
	ui.sTablePressed.connect(_table_clicked)
	ui.sCounterPressed.connect(_counter_clicked)
	
	pass

func set_state(state: GameState):
	self.state = state
	match state:
		GameState.Title:
			pass
		GameState.InGame:
			pass
	pass

func game_end():
	levelManager.fade.fade(Fade.Type.FromBlack)
	state = GameState.End
	monsterManager.deactivate()
	monsterManager.reset(null)
	end = await GM.spawn(endScene)
	
	end.shoe.WasSelected.connect(shoe_selected)
	end.shoe.visible = false
	end.shoe.set_if_is_selectable(false)
	end.rent.WasSelected.connect(rent_selected)
	end.rent.set_if_is_selectable(false)
	end.rent.visible = true
	
	
	GM.ui.set_center_text("Pam made enough to pay off rent", 3)
	await get_tree().create_timer(3, true, false,true).timeout
	
	end.shoe.visible = true
	GM.ui.set_center_text("Pam also made enough to buy some kicks instead", 3)
	await get_tree().create_timer(3, true, false,true).timeout
	
	
	GM.ui.set_center_text("What will Pam pick?", 3)
	await get_tree().create_timer(3, true, false,true).timeout
	
	end.shoe.set_if_is_selectable(true)
	end.rent.set_if_is_selectable(true)
	pass

var endMonst: Monster
func shoe_selected(obj):
	var monster: Monster = await monsterManager.spawn_monster_rand_loc(GM.Monster.Franken)
	monster.posStateChanged.connect(shoe_selected_monst)
	monster.WALK_SPEED = 20
	monster.selectable.queue_free()
	endMonst = monster
	pass
func shoe_selected_monst(posState: int):
	if posState != 1:
		return
	endMonst.at_counter_angry_reaction()
	await get_tree().create_timer(1, true, false,true).timeout
	GM.ui.set_center_text("Pam didn't pay rent\nshe was mauled to death", 5)
	await get_tree().create_timer(2, true, false,true).timeout
	GM.levelManager.fade.fade(Fade.Type.ToBlack)
	GM.levelManager.fade.faded.connect(dfasjkl_fade)
	await get_tree().create_timer(3, true, false,true).timeout
	pass

func dfasjkl_fade(type: Fade.Type):
	root.queue_free()
	pass

func rent_selected(obj):
	GM.ui.set_center_text("Pam paid rent!", 2)
	await get_tree().create_timer(2, true, false,true).timeout
	GM.ui.set_center_text("she continued serving sandwiches for years!", 4)
	await get_tree().create_timer(2, true, false,true).timeout
	GM.levelManager.fade.fade(Fade.Type.ToBlack)
	GM.levelManager.fade.faded.connect(dfassdaf_fade2)
	await get_tree().create_timer(3, true, false,true).timeout
	pass

func dfassdaf_fade2(type: Fade.Type):
	root.queue_free()
	pass
	
func _process(delta):
	if gameInstance:
		gameInstance._process(delta)
		if not audio.playing:
			audio.stream = asMusic
			audio.play()
			pass
	else:
		audio.stream = null
		audio.stop()
	pass

func level_starting(level: Level):
	monsterManager.AVAILABLE_MONSTERS = level.AVAILABLE_MONSTERS
	monsterManager.MIN_TIME_BT_MONSTERS = level.MIN_TIME_BT_MONSTERS
	monsterManager.MAX_TIME_BT_MONSTERS = level.MAX_TIME_BT_MONSTERS
	monsterManager.MAX_MONSTERS_AT_A_TIME = level.MAX_MONSTERS_AT_A_TIME
	Order.MAX_SANDWICH_SIZE = level.MAX_SANDWICH_SIZE
	Order.MAX_TOPPINGS_PER_SLICE = level.MAX_TOPPINGS_PER_SLICE
	Order.TOPPING_CHOICES = level.AVAILABLE_TOPPINGS
	Order.ORDER_TIME = level.ORDER_TIME
	jamTable.available_jams_match_orders()
	monsterManager.activate()
	
	cam.set_world_color(level.WORLD_COLOR)
	
	if not gameInstance:
		start_game_instance()
	else:
		gameInstance.start()
	
	
	#game_end()
	pass

func order_given_correctly(monster: Monster):
	add_score(monster.order.scoreAmount, monster.global_position)
	pass
func order_timed_out(monster: Monster):
	add_score(-monster.order.scoreAmount, monster.global_position)
	pass

func add_score(amt: int, pos: Vector3):
	gameInstance.add_score(amt)
	var pointDisplay: PointsAddedDisplay = await spawn(scenePointsAddedDisplay)
	pointDisplay.init(amt, pos)
	pass

func start_game_instance():
	state = GameState.InGame
	gameInstance = GameInstance.new()
	gameInstance.hourPassed.connect(ui.topUI.time_changed)
	gameInstance.intervalPassed.connect(ui.topUI.time_changed_interval)
	gameInstance.scoreChanged.connect(ui.topUI.score_changed)
	gameInstance.nightDone.connect(levelManager.show_end_current_level_menu)
	gameInstance.start()
	
	await get_tree().physics_frame
	
	pass

func get_global_node(str:String):
	if get_tree().get_node_count_in_group(str) > 0:
		return get_tree().get_nodes_in_group(str)[0]
	pass

func get_current_jams_available() -> Array[Toppings]:
	var arr: Array[Toppings] = []
	for i in range(0, gameInstance.jamsAvailibleTilIndex+1):
		arr.append(i)
		pass
	return arr

func get_current_max_toppings() -> int:
	return gameInstance.maxToppingsPerSlice
	
func get_current_max_sandwich_size() -> int:
	return gameInstance.maxSandwichSize

func _table_clicked():
	set_cam_state(CamView.JellyTable)
	jamTable.cam_looking_at_jam_table()
	monsterManager.set_monsters_targetability(false)
	pass
func _counter_clicked():
	set_cam_state(CamView.Counter)
	jamTable.cam_looking_at_counter()
	monsterManager.set_monsters_targetability(true)
	pass


func set_cam_state(state:GM.CamView):
	self.camState = state
	match(camState):
		GM.CamView.Counter:
			pass
		GM.CamView.JellyTable:
			pass
	pass

func spawn(scene: PackedScene):
	var node = scene.instantiate()
	root.add_child(node)
	if not node.is_inside_tree():
		await node.ready
	return node

func is_knife_topping(topping:Toppings):
	var str = Toppings.keys()[topping]
	if Toppings.keys()[topping].contains("Jam"):
		return true
	return false

func play_audio(audio, stream: AudioStream):
	audio.stream = stream
	audio.play()

func play_rand_audio(audio, streams: Array[AudioStream]):
	if streams.size() == 0:
		return
	play_audio(audio, streams[randi_range(0, streams.size()-1)])
