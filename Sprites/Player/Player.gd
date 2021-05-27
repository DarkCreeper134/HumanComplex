extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
#export var ROLL_SPEED = 120
export var FRICTION = 500
var input_vector = Vector2.ZERO

enum {
	MOVE,
	#SLEEP,
	ACTION
}

#signal BedLeave

var state = MOVE

var velocity = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var attackShape = $YSort/HitboxPivot/Attack/CollisionShape2D

func _physics_process(delta):
	match state:
		MOVE:
			Move_State(delta)
		#SLEEP:
			#Sleep_State()
		ACTION:
			Action_State()

func Move_State(delta):
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("ui_accept"):
		state = ACTION


func move():
	velocity = move_and_slide(velocity)

#func BedActivated():
	#state = SLEEP

#func Sleep_State():
	#animationTree.set("parameters/Idle/blend_position", Vector2.DOWN)
	#animationState.travel("Idle")
	#if Input.is_action_just_pressed("ui_accept"):
		#state = MOVE
		#emit_signal("BedLeave")

func Action_State():
	animationState.travel("Attack")
	attackShape.disabled = false
	velocity = Vector2.ZERO


func Attack_Finished():
	animationState.travel("Idle")
	attackShape.disabled = true
	state = MOVE

#func DoorEntered():
	#animationTree.set("parameters/Idle/blend_position", input_vector)
	#animationTree.set("parameters/Run/blend_position", input_vector)
