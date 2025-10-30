extends Node3D
class_name SpeechBubble

var sprite3Ds: Array[Sprite3D] = []

var center: Node3D
var sandwichParent: Node3D
var order: Order

const SPACE_UNDER_TOPPING: float = 0.02
const SPACE_UNDER_SLICE: float = 0.06
const ICON_PIXEL_SIZE: float = 0.0005

var TIME_BT_PIECE: float = 0.5

var totalAddedHeight: float = 0

var KEEP_SPRITES_VISIBLE_ON_CREATION: bool = false

signal order_was_revealed
signal order_piece_revealed

func _ready() -> void:
	center = $bubble/center
	sandwichParent = $bubble/center/sandwichParent
	
	if GM.debug:
		TIME_BT_PIECE = 0.1
	pass

func reveal_order():
	self.visible = true
	for i in range(0, sprite3Ds.size()):
		if TIME_BT_PIECE > 0:
			order_piece_revealed.emit()
		await get_tree().create_timer(TIME_BT_PIECE, true, false, true).timeout
		sprite3Ds[i].visible = true
		pass
	if TIME_BT_PIECE > 0:
		order_piece_revealed.emit()
	await get_tree().create_timer(TIME_BT_PIECE, true, false, true).timeout
	order_was_revealed.emit()
	pass

func make_from_order(order: Order):
	self.order = order
	for sliceInd in range(0, order.breadStatsArray.size()):
		add_sprite3d_to_sandwich(order.breadStatsArray[sliceInd].breadType, true)
		for toppingInd in range(0, order.breadStatsArray[sliceInd].toppings.size()):
			add_sprite3d_to_sandwich(order.breadStatsArray[sliceInd].toppings[toppingInd], false)
			pass
		pass
	sandwichParent.position.y = -totalAddedHeight/2
	pass

func add_sprite3d_to_sandwich(type, isBread: bool):
	var sprite3D: Sprite3D
	var add: float
	sprite3D = make_sprite3d(type, isBread)
	if isBread:
		add = SPACE_UNDER_SLICE
	else:
		add = SPACE_UNDER_TOPPING
	
	if sprite3Ds.size() == 0:
		sprite3D.position.y = 0
	else:
		sprite3D.position.y = sprite3Ds[sprite3Ds.size()-1].position.y + add
		totalAddedHeight += add
	sprite3D.visible = KEEP_SPRITES_VISIBLE_ON_CREATION
	sprite3Ds.append(sprite3D)
	pass

func make_sprite3d(type, isBread: bool):
	var sprite3D: Sprite3D = Sprite3D.new()
	if isBread:
		sprite3D.texture = get_bread_sprite(type)
	else:
		sprite3D.texture = get_topping_sprite(type)
		sprite3D.modulate = GM.dictToppings[type].color
	sprite3D.pixel_size = ICON_PIXEL_SIZE
	sprite3D.render_priority = sprite3Ds.size() + 2
	sandwichParent.add_child.call_deferred(sprite3D)

	return sprite3D

func get_bread_sprite(type: GM.BreadType) -> CompressedTexture2D:
	return GM.dictBread[type].icon
	
func get_topping_sprite(type: GM.Toppings) -> CompressedTexture2D:
	return GM.dictToppings[type].icon
