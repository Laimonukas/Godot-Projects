extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -200.0
@export var JUMP_VELOCITY_X = 200.0
@export var ALWAYS_CHACE = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum baseStates {inAir, grounded,death}
enum airMoveStates {jump, fall}
enum groundMoveStates {run, idle, crouch}

@onready var sprite = $AnimatedSprite2D
var player
var directionToPlayer
var chase = false
var baseState = baseStates.grounded


func _ready():
	player = get_node("../Player")

func _physics_process(delta):
	if baseState == baseStates.death:
		return
	
	var airState
	var runState
	# Add the gravity.
	if not is_on_floor():
		baseState = baseStates.inAir
		velocity.y += gravity * delta
	else:
		baseState = baseStates.grounded
	
	if baseState == baseStates.inAir:
		if velocity.y < 0:
			airState = airMoveStates.jump
		else:
			airState = airMoveStates.fall
	else:
		if velocity.x == 0:
			runState = groundMoveStates.idle
	
	match baseState:
		baseStates.inAir:
			match airState:
				airMoveStates.jump:
					sprite.play("jump")
				airMoveStates.fall:
					sprite.play("fall")
		baseStates.grounded:
			match runState:
				groundMoveStates.idle:
					sprite.play("idle")
			
					
	if not ALWAYS_CHACE:
		velocity.x = FixVelocity(velocity.x,delta)
	else:
		if is_on_floor() and chase:
			SetDirectionToPlayer()
			Jump()
			
	move_and_slide()
	


func _on_area_2d_body_entered(body):
	if body == player:
		SetDirectionToPlayer()
		if ALWAYS_CHACE:
			chase = true
		else:
			Jump()
		
func Jump():
	velocity.y += JUMP_VELOCITY
	
	velocity.x = directionToPlayer.x * JUMP_VELOCITY_X

func SetDirectionToPlayer():
	directionToPlayer = player.global_position - global_position
	directionToPlayer = directionToPlayer.normalized()
	if directionToPlayer.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true


func FixVelocity(vel,delta) -> float:
	if vel < 10 and vel > -10:
		vel = 0
	elif vel > 10:
		vel -= JUMP_VELOCITY_X * delta
	else:
		vel += JUMP_VELOCITY_X * delta	
	return vel
	


func _on_area_2d_body_exited(body):
	if body == player:
		chase = false
	velocity.x = 0


func _on_death_area_body_entered(body):
	if body == player:
		baseState = baseStates.death
		Die()

func Die():
	$CollisionShape2D.set_process(false)
	$DeathArea.set_process(false)
	$DamageArea.set_process(false)
	sprite.play("death")
	await sprite.animation_finished
	self.queue_free()
		


func _on_damage_area_body_entered(body):
	if body == player:
		player.TakeDamage()
