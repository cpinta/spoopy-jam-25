class_name LinePosition

enum LineType {Counter=0, WaitingForFood=1}

var currentPosition: Vector3
var type: LineType

var monster: Monster
var index: int = 0

func _init(monster: Monster, type: LineType, index: int, pos: Vector3):
	self.type = type
	self.index = index
	self.currentPosition = pos
	self.monster = monster
	pass

signal positionChanged(index:int,pos: Vector3)

func set_line_position(newIndex: int, pos: Vector3):
	currentPosition = pos
	positionChanged.emit(pos)
