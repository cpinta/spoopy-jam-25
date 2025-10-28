extends Node3D
class_name LineQueue

enum Type {Counter=0, WaitingForFood=1}

@export var direction: Vector3
@export var DIST_BT_POSITIONS: float = 0.6

var lineType: Type

# index 0 is the front of the line
var linePositions: Array[LinePosition] = []

# a monster gets a line position when:
#		- they spawn
#		- they place their order and wait next to the others

func add_monster_to_queue_back(monster: Monster):
	return add_monster_to_queue_at_index(monster, linePositions.size())

func get_global_position_from_line_index(index: int):
	if index > 0:
		return global_position + (index * direction * DIST_BT_POSITIONS)
	return global_position

func add_monster_to_queue_front(monster: Monster):
	return add_monster_to_queue_at_index(monster, 0)

func add_monster_to_queue_at_index(monster:Monster, index: int) -> LinePosition:
	var linePos: LinePosition = LinePosition.new(monster, lineType, index, get_global_position_from_line_index(index))
	linePos.left_queue.connect(remove_monster_from_queue)
	if index == linePositions.size():
		linePositions.append(linePos)
	else:
		linePositions.insert(index, linePos)
	update_line_positions_on_and_after_index(index+1)
	return linePos

func remove_monster_from_front():
	remove_monster_from_queue(0)
	pass

func remove_monster_from_queue(index: int):
	linePositions.remove_at(index)
	update_line_positions_on_and_after_index(index)

func update_line_positions_on_and_after_index(index: int):
	if index >= linePositions.size():
		return
	for i in range(index, linePositions.size()):
		if i > 0:
			linePositions[i].set_line_position(i, get_global_position_from_line_index(i))
		else:
			linePositions[0].set_line_position(0, global_position)
		pass
	pass
	pass
