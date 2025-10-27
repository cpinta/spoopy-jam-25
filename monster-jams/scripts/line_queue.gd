extends Node3D
class_name LineQueue

@export var direction: Vector3
@export var DIST_BT_POSITIONS: float = 0.6

# index 0 is the front of the line
var linePositions: Array[LinePosition] = []

# a monster gets a line position when:
#		- they spawn
#		- they place their order and wait next to the others

func add_monster_to_queue_back(monster: Monster):
	var newPosition: Vector3 = global_position
	if linePositions.size() > 0:
		newPosition = linePositions[linePositions.size()-1].currentPosition + (direction * DIST_BT_POSITIONS)
	var linePos: LinePosition = LinePosition.new(monster, LinePosition.LineType.Counter, linePositions.size(), newPosition)
	linePos.left_queue.connect(remove_monster_from_queue)
	linePositions.append(linePos)
	
	return linePositions[linePositions.size()-1]

func add_monster_to_queue_front(monster: Monster):
	var newPosition: Vector3 = global_position
	var linePos: LinePosition = LinePosition.new(monster, LinePosition.LineType.Counter, linePositions.size(), newPosition)
	linePos.left_queue.connect(remove_monster_from_queue)
	linePositions.insert(0, linePos)
	
	if linePositions.size() > 1:
		for i in range(0, linePositions.size()):
			linePositions[i] = linePositions[i+1]
			if i > 0:
				linePositions[i].set_line_position(i-1, linePositions[i-1].currentPosition)
			else:
				linePositions[0].set_line_position(0, global_position)
			pass
	
	return linePos

func remove_monster_from_front():
	remove_monster_from_queue(0)
	pass

func remove_monster_from_queue(index: int):
	for i in range(index, linePositions.size()-1):
		linePositions[i] = linePositions[i+1]
		if i > 0:
			linePositions[i].set_line_position(i-1, linePositions[i-1].currentPosition)
		else:
			linePositions[0].set_line_position(0, global_position)
		pass
	linePositions.remove_at(linePositions.size()-1)
	pass
