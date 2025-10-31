class_name Monster
extends Node3D

enum MonsterMoveState{
	Standing = 0,
	Walking = 1
}

enum MonsterPositionState{
	Outside = 0,
	AtCounter = 1,
	DescribingOrder = 5,
	WaitingForFood = 2,
	LeavingRestaurant = 3,
	Angry = 4
}

enum MonsterWalkAnim{
	Tilt = 0,
	Squash = 1
}

var sprite: AnimatedSprite3D
var spriteParent: Node3D
var meter: Meter
var voiceAudio: AudioStreamPlayer3D
var stepAudio: AudioStreamPlayer3D

var walkAnim: MonsterWalkAnim = MonsterWalkAnim.Tilt

var moveState: MonsterMoveState = MonsterMoveState.Standing

var soundsTalking: Array[AudioStream] = []
var soundsAngry: Array[AudioStream] = []
var soundsPleased: Array[AudioStream] = [] 
var soundsStep: Array[AudioStream] = []
var soundsSpecial: Array[AudioStream] = []

var WALK_SPEED: int = 0.75
var STEP_EVERY: float = 0.4
var STEP_TILT: float = 7
var STEP_SCALE_ADD: Vector2 = Vector2(0.5, 0.5)
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
var orderTime: float = 20
var orderTimer: float = 0

var pathNode: PathNode

signal orderWasTaken(monster:Monster, order: Order)
signal clickedWhileWaitingForOrder(monster:Monster)
signal wasGivenOrder(monster:Monster)

signal dead(monster:Monster)

func _ready():
	spriteParent = $spriteParent
	sprite = $spriteParent/sprite
	speechBubble = $face/bubbleParent
	speechBubble.visible = false
	speechBubble.order_was_revealed.connect(order_was_taken)
	speechBubble.order_piece_revealed.connect(play_rand_talk)
	thoughtBubble = $face/thoughtParent
	thoughtBubble.visible = false
	meter = $face/meter
	
	voiceAudio = $voice
	stepAudio = $step
	
	selectable = $hitbox
	selectable.set_if_is_selectable(false)
	selectable.WasSelected.connect(was_selected)
	
	orderTime = Order.ORDER_TIME
	
	sprite.play("default")
	meter.visible = true
	
	set_pos_state(Monster.MonsterPositionState.Outside)
	pass

func set_order(order: Order):
	self.order = order
	speechBubble.make_from_order(order)
	thoughtBubble.make_from_order(order)
	orderTimer = orderTime
	hasOrder = true
	pass

func leave_current_line_queue():
	if linePos:
		linePos.leave_queue()
		if linePos.positionChanged.is_connected(line_pos_changed):
			linePos.positionChanged.disconnect(line_pos_changed)
		linePos = null
	pass

func play_rand_step():
	GM.play_rand_audio(stepAudio, soundsStep)
func play_rand_talk():
	GM.play_rand_audio(voiceAudio, soundsTalking)
func play_rand_pleased():
	GM.play_rand_audio(voiceAudio, soundsPleased)
func play_rand_angry():
	GM.play_rand_audio(voiceAudio, soundsAngry)
func play_rand_special():
	GM.play_rand_audio(voiceAudio, soundsSpecial)

func set_line_position(linePos:LinePosition):
	if self.linePos:
		leave_current_line_queue()
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
	orderTimer = orderTime
	meter.visible = true
	currentlySpeaking = false
	#show_speech_bubble_order()
	pass
	
func was_selected(obj):
	if linePos:
		match(linePos.lineType):
			LineQueue.Type.Counter:
				if posState != MonsterPositionState.Angry:
					start_take_order()
			LineQueue.Type.WaitingForFood:
				clicked_while_waiting()
	pass

func was_given_order():
	play_rand_pleased()
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
	set_pos_state(Monster.MonsterPositionState.DescribingOrder)
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
		MonsterPositionState.Angry:
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
	
	if order:
		if posState == Monster.MonsterPositionState.AtCounter or posState == Monster.MonsterPositionState.WaitingForFood:
			if orderTimer > 0:
				orderTimer -= delta
				meter.set_meter(orderTimer, orderTime)
			else:
				order_timed_out()
	pass

signal orderTimedOut(monster: Monster, loseScore: bool)
signal orderTimedOutToCounter(monster: Monster)
signal waitedTooLongNoOrder(monster: Monster)

func order_timed_out():
	play_rand_angry()
	meter.visible = false
	orderTimedOut.emit(self, true)
	order = null
	set_pos_state(MonsterPositionState.Angry)
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
				_step_anim()
			pass
	pass

func _step_anim():
	match walkAnim:
		MonsterWalkAnim.Tilt:
			if stepCount % 2 == 0:
				play_rand_step()
				spriteParent.rotation_degrees.z = +STEP_TILT
				pass
			else:
				play_rand_step()
				spriteParent.rotation_degrees.z = -STEP_TILT
				pass
			pass
		MonsterWalkAnim.Squash:
			if stepCount % 4 == 0:
				spriteParent.scale.x = 1-STEP_SCALE_ADD.x
				spriteParent.scale.y = 1+STEP_SCALE_ADD.y
				pass
			elif stepCount % 4 == 1:
				play_rand_step()
				spriteParent.scale = Vector3.ONE
				pass
			elif stepCount % 4 == 2:
				spriteParent.scale.x = 1+STEP_SCALE_ADD.x
				spriteParent.scale.y = 1-STEP_SCALE_ADD.y
				pass
			else:
				spriteParent.scale = Vector3.ONE
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
	spriteParent.scale = Vector3.ONE
	moveState = MonsterMoveState.Standing
	if pathNode:
		pathNode.path_arrived(self)
		pathNode = null
		return
	if linePos:
		match(linePos.lineType):
			LineQueue.Type.Counter:
				if linePos.index == 0:
					if posState == MonsterPositionState.Angry:
						at_counter_angry_reaction()
					else:
						set_pos_state(Monster.MonsterPositionState.AtCounter)
						selectable.at_counter()
						selectable.set_if_is_selectable(true)
				else:
					selectable.set_if_is_selectable(false)
			_:
				selectable.in_line()
				selectable.set_if_is_selectable(true)
				pass
	pass

func at_counter_angry_reaction():
	pass

func remove():
	dead.emit()
	if linePos:
		leave_current_line_queue()
	queue_free()
	pass

func set_targetability(value: bool):
	if selectable:
		selectable.set_if_is_targetable(value)

func show_speech_bubble_order():
	speechBubble.visible = true
	pass
