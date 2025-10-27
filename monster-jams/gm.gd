class_name GameManager
extends Node

var debug: bool = true

var ui: UI
var cam: GameCamera

var input: InputHandler
var audio: AudioStreamPlayer

var asError: AudioStream = load("res://sounds/error sound.mp3")

var jamTable: JellyTable

var camState: GM.CamView = GM.CamView.Counter

enum Monster { Franken, Skeleton }
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
enum CursorMode {NONE, KNIFE, BREAD, BAGEL, HAM, TALK}

var cursor: Cursor
var monsterManager: MonsterManager
var entrance: PathNode
var gameInstance: GameInstance
var root: Node3D
var plate: Plate

var scenePointsAddedDisplay: PackedScene = load("res://scenes/points_added_display.tscn")

# shop located in conneticut

func _ready():
	root = get_global_node("root")
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
	
	plate.WasSelected.connect(jamTable.transfer_to_sandwich)
	plate.didntGiveSandwich.connect(monsterManager.monster_was_clicked_order_was_wrong)
	plate.gaveSandwichToMonster.connect(monsterManager.monster_given_order)
	
	monsterManager.entrance = entrance
	monsterManager.monsterWasClickedWhileWaitingForOrder.connect(plate.check_if_has_monster_order)
	monsterManager.monsterGivenCorrectOrder.connect(order_given_correctly)
	
	entrance.monster_arrived.connect(monsterManager.monster_at_front)
	
	jamTable.ToppingSelected.connect(cursor.topping_selected)
	jamTable.BreadSelected.connect(cursor.bread_selected)
	
	ui.sTablePressed.connect(_table_clicked)
	ui.sCounterPressed.connect(_counter_clicked)
	
	start_game_instance()
	pass

func _process(delta):
	if gameInstance:
		gameInstance._process(delta)
	pass

func order_given_correctly(monster: Monster):
	add_score(monster.order.scoreAmount, monster.global_position)
	pass

func add_score(amt: int, pos: Vector3):
	gameInstance.add_score(amt)
	var pointDisplay: PointsAddedDisplay = spawn(scenePointsAddedDisplay)
	pointDisplay.init(amt, pos)
	pass

func play_audio(stream: AudioStream):
	audio.stream = stream
	audio.play()

func start_game_instance():
	gameInstance = GameInstance.new()
	gameInstance.start()
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
	return node

func is_knife_topping(topping:Toppings):
	var str = Toppings.keys()[topping]
	if Toppings.keys()[topping].contains("Jam"):
		return true
	return false
