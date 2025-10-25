class_name Monster
extends Node3D

enum MonsterMoveState{
	Standing = 0,
	Walking = 1
}

enum MonsterPositionState{
	Outside = 0,
	AtCounter = 1,
	WaitingForFood = 2,
	LeavingRestaurant = 3
}

var sprite: AnimatedSprite3D
var spriteParent: Node3D

var moveState: MonsterMoveState = MonsterMoveState.Standing

var WALK_SPEED: int = 1
var STEP_EVERY: float = 0.4
var stepTimer: float = 0
var STEP_TILT: float = 7
var stepCount: int = 0

var has_walk_dest: bool = false
var walkDest: Vector3
const MIN_WALK_DEST_DIST: float = 0.01

var order: Order

func _ready():
	spriteParent = $spriteParent
	sprite = $spriteParent/sprite
	#position = Vector3.ZERO
	set_walk_dest(GM.COUNTER_FRONT_LOCATION - Vector3(0,0,0.1))
	
	pass

func set_order(order: Order):
	self.order = order
	pass
	
func _process(delta):
	
	if has_walk_dest:
		if global_position.distance_to(walkDest) < MIN_WALK_DEST_DIST:
			walk_dest_arrived()
			pass
		else:
			global_position = global_position.move_toward(walkDest, WALK_SPEED*delta)
			pass
	
	_walk_anim(delta)
	pass

func _walk_anim(delta):
	match (moveState):
		MonsterMoveState.Standing:
			pass
		MonsterMoveState.Walking:
			if stepTimer > 0:
				stepTimer -= delta
				pass
			else:
				stepTimer = STEP_EVERY
				stepCount += 1
				if stepCount % 2 == 0:
					spriteParent.rotation_degrees.z = +STEP_TILT
					pass
				else:
					spriteParent.rotation_degrees.z = -STEP_TILT
					pass
				pass
			pass
	pass
	
func set_walk_dest(pos:Vector3):
	walkDest = pos
	has_walk_dest = true
	moveState = MonsterMoveState.Walking
	pass

func walk_dest_arrived():
	global_position = walkDest
	has_walk_dest = false
	spriteParent.rotation.z = 0
	moveState = MonsterMoveState.Standing
	pass
