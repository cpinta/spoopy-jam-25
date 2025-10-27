class_name LinePosition

var currentPosition: Vector3
var lineType: LineQueue.Type

var monster: Monster
var index: int = 0

signal positionChanged(index:int,pos: Vector3)
signal left_queue(linePos: LinePosition)

func _init(monster: Monster, lineType: LineQueue.Type, index: int, pos: Vector3):
	self.lineType = lineType
	self.index = index
	self.currentPosition = pos
	self.monster = monster
	pass

func leave_queue():
	left_queue.emit(index)
	pass

func set_line_position(newIndex: int, pos: Vector3):
	currentPosition = pos
	index = newIndex
	positionChanged.emit(pos)
