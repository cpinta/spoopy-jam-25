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
var STEP_TILT: float = 7
var stepTimer: float = 0
var stepCount: int = 0

var has_walk_dest: bool = false
var walkDest: Vector3
const MIN_WALK_DEST_DIST: float = 0.01

var order: Order

var posState: MonsterPositionState

var faceNode: Node3D
var speechBubble: SpeechBubble

var linePos: LinePosition

var selectable: SelectableMonster

signal orderWasTaken(monster:Monster, order: Order)

func _ready():
	spriteParent = $spriteParent
	sprite = $spriteParent/sprite
	speechBubble = $face/bubbleParent
	speechBubble.visible = false
	selectable = $hitbox
	selectable.set_if_is_selectable(false)
	selectable.WasSelected.connect(take_order)
	#position = Vector3.ZERO
	pass

func set_order(order: Order):
	self.order = order
	speechBubble.make_from_order(order)
	pass

func set_line_position(linePos:LinePosition):
	if self.linePos:
		self.linePos.positionChanged.disconnect(line_pos_changed)
	self.linePos = linePos
	linePos.positionChanged.connect(line_pos_changed)
	line_pos_changed(linePos.currentPosition)
	pass

func intialize(order: Order, linePos: LinePosition):
	set_order(order)
	set_line_position(linePos)
	pass

func take_order(obj):
	orderWasTaken.emit(self, order)
	speechBubble.visible = false
	selectable.set_if_is_selectable(false)
	pass

func line_pos_changed(pos:Vector3):
	set_walk_dest(pos)
	pass
	
func set_pos_state(newState: MonsterPositionState):
	posState = newState
	match(posState):
		MonsterPositionState.Outside:
			pass
		MonsterPositionState.AtCounter:
			pass
		MonsterPositionState.WaitingForFood:
			pass
		MonsterPositionState.LeavingRestaurant:
			pass
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
	if linePos:
		if linePos.type == LinePosition.LineType.Counter:
			if linePos.index == 0:
				selectable.set_if_is_selectable(true)
				show_speech_bubble_order()
			else:
				selectable.set_if_is_selectable(false)
	pass

func show_speech_bubble_order():
	speechBubble.visible = true
	pass
