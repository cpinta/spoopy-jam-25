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
var thoughtBubble: ThoughtBubble

var linePos: LinePosition

var selectable: SelectableMonster

var currentlySpeaking: bool = false
const TALK_ABOUT_ORDER: float = 3
var speakingTimer: float = 0;

var hasOrder: bool = false
var orderTime: float = 5
var orderTimer: float = 0

var pathNode: PathNode

signal orderWasTaken(monster:Monster, order: Order)
signal clickedWhileWaitingForOrder(monster:Monster)
signal wasGivenOrder(monster:Monster)

func _ready():
	spriteParent = $spriteParent
	sprite = $spriteParent/sprite
	speechBubble = $face/bubbleParent
	speechBubble.visible = false
	speechBubble.order_was_revealed.connect(order_was_taken)
	thoughtBubble = $face/thoughtParent
	thoughtBubble.visible = false
	
	selectable = $hitbox
	selectable.set_if_is_selectable(false)
	selectable.WasSelected.connect(was_selected)
	pass

func set_order(order: Order):
	self.order = order
	speechBubble.make_from_order(order)
	thoughtBubble.make_from_order(order)
	orderTime = orderTimer
	hasOrder = true
	pass

func set_line_position(linePos:LinePosition):
	if self.linePos:
		#self.linePos.remove_monster_from_front()
		self.linePos.leave_queue()
		self.linePos.positionChanged.disconnect(line_pos_changed)
	self.linePos = linePos
	linePos.positionChanged.connect(line_pos_changed)
	line_pos_changed(linePos.currentPosition)
	pass

func intialize(order: Order, linePos: LinePosition):
	set_order(order)
	set_line_position(linePos)
	pass



func order_was_taken():
	set_pos_state(Monster.MonsterPositionState.WaitingForFood)
	orderWasTaken.emit(self, order)
	speechBubble.visible = false
	selectable.set_if_is_selectable(false)
	set_order_timer(orderTime)
	#show_speech_bubble_order()
	pass
	
func set_order_timer(time: float):
	orderTimer = time
	pass
	
func was_selected(obj):
	if linePos:
		match(linePos.lineType):
			LineQueue.Type.Counter:
				start_take_order()
			LineQueue.Type.WaitingForFood:
				clicked_while_waiting()
	pass

func was_given_order():
	wasGivenOrder.emit(self)
	pass

func clicked_while_waiting():
	clickedWhileWaitingForOrder.emit(self)
	pass

func think_of_food():
	thoughtBubble.show_bubble_for_a_time()

func start_take_order():
	speechBubble.reveal_order()
	set_currently_speaking(true)
	pass

func set_currently_speaking(value: bool):
	currentlySpeaking = value
	if currentlySpeaking:
		speakingTimer = TALK_ABOUT_ORDER
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
			if GM.debug:
				WALK_SPEED = 20
				pass
			global_position = global_position.move_toward(walkDest, WALK_SPEED*delta)
			pass
	
	_walk_anim(delta)
	
	if hasOrder:
		if orderTimer > 0:
			orderTimer -= delta
		else:
			order_timed_out()
	pass

func order_timed_out():
	hasOrder = false
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
	if pathNode:
		pathNode.path_arrived(self)
		pathNode = null
		return
	if linePos:
		match(linePos.lineType):
			LineQueue.Type.Counter:
				if linePos.index == 0:
					selectable.at_counter()
					selectable.set_if_is_selectable(true)
				else:
					selectable.set_if_is_selectable(false)
			_:
				selectable.in_line()
				selectable.set_if_is_selectable(true)
				pass
	pass

func remove():
	queue_free()
	pass

func set_targetability(value: bool):
	if selectable:
		selectable.set_if_is_targetable(value)

func show_speech_bubble_order():
	speechBubble.visible = true
	pass
