extends SelectableItem
class_name Plate

var sandwiches: Array[Bread3D]

var breadParent: Node3D

signal gaveSandwichToMonster(monster:Monster)
signal didntGiveSandwich(monster:Monster)

func _ready():
	target = $StaticBody3D
	await get_tree().physics_frame
	
	breadParent = $breadParent
	WasSelectedSentItem = self
	
	WasSelected.connect(GM.jamTable.transfer_to_plate)
	didntGiveSandwich.connect(GM.monsterManager.monster_was_clicked_order_was_wrong)
	gaveSandwichToMonster.connect(GM.monsterManager.monster_given_order)
	
	
	BeingHoveredCursorMode = GM.CursorMode.PLATE
	
	super._ready()
	pass

func get_pos_on_top() -> Vector3:
	if sandwiches.size() > 0:
		return sandwiches[sandwiches.size()-1].get_top_bread().get_bread_global_pos_above() - breadParent.global_position
	return Vector3.ZERO

func add_sandwich(bread:Bread3D):
	bread.set_state(Bread3D.BreadState.MovingToPlate)
	bread.reparent(breadParent, true)
	bread.scale = Vector3.ONE
	bread.set_destination(get_pos_on_top())
	sandwiches.append(bread)
	pass

func check_if_has_monster_order(monster: Monster):
	var result: int = check_if_has_order(monster.order)
	if result != -1:
		remove_sandwich(result)
		gaveSandwichToMonster.emit(monster)
	else:
		didntGiveSandwich.emit(monster)
	pass

func remove_sandwich(index:int):
	sandwiches[index].queue_free()
	sandwiches.remove_at(index)

func check_if_has_order(order: Order) -> int:
	if not order:
		return -1
	for i in range(0, sandwiches.size()):
		if order.does_sandwich_match_stats(sandwiches[i]):
			return i
		pass
	pass
	return -1
