extends Node3D
class_name LinePosition

enum LineType {Counter=0, WaitingForFood=1}

var currentPosition: Vector3
var type: LineType

var index: int = 0

func initialize(type: LineType):
	self.type = type
	pass

signal positionChanged(index:int,pos: Vector3)

func set_line_position(newIndex: int, pos: Vector3):
	currentPosition = pos
	positionChanged.emit(pos)
