class_name GameManager
extends Node

var ui: UI
var cam: GameCamera

var input: InputHandler

var jamTable: JellyTable

var camState: GM.CamView = GM.CamView.Counter

enum Monster { Franken }
enum CamView {Counter, JellyTable}
enum Toppings {StrawberryJam=0, AppleJam=1, BlueberryJam=2, GrapeJam=3, Ham=4,None=-1}
var dictToppings = {
	Toppings.StrawberryJam: StrawberryJam.new(),
	Toppings.AppleJam: AppleJam.new(), 
	Toppings.BlueberryJam: BlueberryJam.new(), 
	Toppings.GrapeJam: GrapeJam.new(), 
	Toppings.Ham: Ham.new()}
enum BreadType {Wheat=0, Bagel=1}
var dictBread = {
	BreadType.Wheat: Wheat.new(),
	BreadType.Bagel: Bagel.new()}
enum CursorMode {NONE, KNIFE, BREAD, BAGEL, HAM}

var COUNTER_FRONT_LOCATION: Vector3 = Vector3(0,10, 0.8)

var cursor: Cursor

var root: Node3D

func _ready():
	root = get_global_node("root")
	COUNTER_FRONT_LOCATION = get_global_node("counterfront").global_position
	ui = get_global_node("ui")
	cam = get_global_node("camera")
	input = get_global_node("input")
	cursor = get_global_node("knife")
	jamTable = get_global_node("jamTable")
	
	jamTable.ToppingSelected.connect(cursor.topping_selected)
	jamTable.BreadSelected.connect(cursor.bread_selected)
	
	#var s: StrawberryJam = StrawberryJam()
	
	ui.sTablePressed.connect(_table_clicked)
	ui.sCounterPressed.connect(_counter_clicked)
	
	pass

func get_global_node(str:String):
	if get_tree().get_node_count_in_group(str) > 0:
		return get_tree().get_nodes_in_group(str)[0]
	pass



func _table_clicked():
	set_cam_state(CamView.JellyTable)
	pass
func _counter_clicked():
	set_cam_state(CamView.Counter)
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
	root.add_child.call_deferred(node)
	return node

func is_knife_topping(topping:Toppings):
	var str = Toppings.keys()[topping]
	if Toppings.keys()[topping].contains("Jam"):
		return true
	return false
