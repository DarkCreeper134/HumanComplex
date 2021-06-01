extends KinematicBody2D

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var setVelocity = Vector2.ZERO


var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

var canMove = false

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			check_state()
		
		WANDER:
			seek_player()
			check_state()
			if self.global_position == wanderController.target_position :
				wanderController.timer = 0
			
			var direction = global_position.direction_to(wanderController.target_position)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		var softVelocity = softCollision.get_push_vector() * delta * 400
		move_and_slide(softVelocity)
	move()

func move():
	if canMove != false:
		move_and_slide(setVelocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func check_state():
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	queue_free()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurtbox.start_invincibility(0.5)

func MoveUpdate():
	if canMove:
		canMove = false
	else:
		canMove = true

func SetVelocity():
	setVelocity = velocity
