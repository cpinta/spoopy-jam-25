class_name MonsterSpawner
extends Node3D

@onready var MONSTER_LIST = {\
	GM.Monster.Franken: load("res://scenes/franken.tscn")
}

var spawnLocations: Array[Vector3]

func _ready():
	spawnLocations.append($"right side".global_position)
	spawnLocations.append($"left side".global_position)
	pass

func _process(delta):
	pass

func spawn_monster_rand_loc(selection:GM.Monster):
	var monster: Monster = spawn_monster(selection, spawnLocations[randi_range(0, spawnLocations.size()-1)])
	return monster

func spawn_monster(selection: GM.Monster, location: Vector3):
	var monster = MONSTER_LIST[selection].instantiate()
	self.add_child(monster)
	return monster
