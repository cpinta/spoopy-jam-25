extends Node3D
class_name PathNode

signal monster_arrived(monster:Monster)

func path_arrived(monster: Monster):
	monster_arrived.emit(monster)
