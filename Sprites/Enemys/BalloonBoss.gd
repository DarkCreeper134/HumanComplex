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

var state = CHASE

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $HurtBox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var sprite = $Sprite
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
var spriteSkin : int = 1
var spriteAnimaimationBlendPos : String = "parameters/" + String(spriteSkin) + "/blend_position"

func _ready():
	animationState.travel(String(spriteSkin))

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
			animationTree.set(spriteAnimaimationBlendPos, direction)
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = global_position.direction_to(player.global_position)
				animationTree.set(spriteAnimaimationBlendPos, direction)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		var softVelocity = softCollision.get_push_vector() * delta * 400
		move_and_slide(softVelocity)
	move()

func move():
	move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func check_state():
	if wanderController.get_time_left() == 0:
		state = pick_random_state([IDLE, WANDER])
		wanderController.start_wander_timer(rand_range(1,3))

func SetBlendPosition():
	spriteAnimaimationBlendPos = "parameters/" + String(spriteSkin) + "/blend_position"

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Stats_no_health():
	hurtbox.create_hit_effect()
	queue_free()

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback * 120
	hurtbox.start_invincibility(1)
	hurtbox.create_hit_effect()
	spriteSkin += 1
	SetBlendPosition()
	animationState.travel(String(spriteSkin))
	match spriteSkin:
		1:
			ACCELERATION = 300
			MAX_SPEED = 50
			FRICTION = 200
		2:
			ACCELERATION = 290
			MAX_SPEED = 40
			FRICTION = 250
		3:
			ACCELERATION = 280
			MAX_SPEED = 30
			FRICTION = 300
		4:
			ACCELERATION = 260
			MAX_SPEED = 20
			FRICTION = 400
		5:
			ACCELERATION = 250
			MAX_SPEED = 70
			FRICTION = 100
		6:
			ACCELERATION = 240
			MAX_SPEED = 75
			FRICTION = 50

func _on_HurtBox_invicniblity_ended():
	blinkAnimationPlayer.play("End")

func _on_HurtBox_invicniblity_started():
	blinkAnimationPlayer.play("Start")
