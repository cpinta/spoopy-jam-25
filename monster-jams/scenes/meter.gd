extends Node3D
class_name Meter

var sprite: Sprite3D
var primary: Color = Color.YELLOW
var secondary: Color = Color.RED

func _ready():
	sprite = $Sprite3D
	pass

func set_meter(current:float, total:float):
	var percent: float = current/total
	if percent > 0.5:
		sprite.modulate = primary
		pass
	else:
		sprite.modulate = secondary
		pass
	if percent < 0:
		scale.x = 0
		return
	scale.x = 10 * percent
	pass
