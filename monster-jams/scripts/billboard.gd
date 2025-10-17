extends Node3D
class_name Billboard

func _process(delta):
	var camera_pos: Vector3 = get_viewport().get_camera_3d().global_position
	look_at(camera_pos, Vector3.UP)
	pass
