extends Node3D
class_name PointsAddedDisplay

const SPEED: float = 0.25
const LIFETIME: float = 1
var timer:float = 0

func init(amt: int, pos: Vector3) -> void:
	global_position = pos
	timer = LIFETIME
	$Label3D.text = "+"+str(amt) if amt > 0 else str(amt)
	pass

func _process(delta: float) -> void:
	if timer > 0:
		global_position.y += SPEED * delta
		timer -= delta
	else:
		queue_free()
	pass
