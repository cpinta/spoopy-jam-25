class_name GameCamera
extends Camera3D

var BASE_ANGLE: Vector3

var PAN_DOWN_X: float = -75
const MIN_PAN_ANGLE_DIST: float = 0.1
const PAN_LERP:float = 20

func _ready():
	BASE_ANGLE = rotation_degrees
	pass
	
func _process(delta):
	match(GM.camState):
		GM.CamView.Counter:
			if abs(rotation_degrees.x) > MIN_PAN_ANGLE_DIST:
				rotation_degrees.x = lerp(rotation_degrees.x, 0.0, PAN_LERP*delta)
			else:
				rotation_degrees.x = 0
			pass
		GM.CamView.JellyTable:
			if abs(rotation_degrees.x - PAN_DOWN_X) > MIN_PAN_ANGLE_DIST:
				rotation_degrees.x = lerp(rotation_degrees.x, PAN_DOWN_X, PAN_LERP*delta)
			else:
				rotation_degrees.x = PAN_DOWN_X
			pass
	pass
