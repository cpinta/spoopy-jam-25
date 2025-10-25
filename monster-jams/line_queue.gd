extends Node3D
class_name LineQueue

@export var direction: Vector3
@export var DIST_BT_POSITIONS: float = 0.25

# index 0 is the front of the line
var linePositions: Array[LinePosition] = []

# a monster gets a line position when:
#		- they spawn
#		- they place their order and wait next to the others

func add_monster_to_queue(monster: Monster):
	var newPosition: Vector3 = global_position
	if linePositions.size() > 0:
		newPosition = linePositions[linePositions.size()-1].currentPosition + (direction * DIST_BT_POSITIONS)
	linePositions.append(LinePosition.new(monster, LinePosition.LineType.Counter, linePositions.size(), newPosition))
	
	return linePositions[linePositions.size()-1]

func remove_monster_from_front():
	for i in range(0, linePositions.size()-1):
		linePositions[i] = linePositions[i+1]
		if i > 0:
			linePositions[i].set_line_position(i-1, linePositions[i-1].currentPosition)
		else:
			linePositions[0].set_line_position(0, global_position)
		linePositions.remove_at(linePositions.size()-1)
		pass
	pass
