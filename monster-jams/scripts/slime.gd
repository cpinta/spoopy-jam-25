class_name Slime
extends Monster

func _ready():
	super._ready()
	WALK_SPEED = 1
	STEP_EVERY = 0.25
	STEP_SCALE_ADD = Vector2(0.5, 0.25)
	walkAnim = MonsterWalkAnim.Squash
	pass
