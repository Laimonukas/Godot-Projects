extends CharacterBody2D

class_name CharacterController

## Nodes
@export var animPlayer : AnimationPlayer
@export var playerBody : Node2D

## set variables
@export var moveSpeed : float = 50.0
@export var maxVelocity : float = 400.0
@export var attackCooldown : float = 0.4
@export var attackResetCooldown : float = 1.0

## other
enum state {idle,walking, attacking}
var currentState = state.idle
var currentAttackCount : int = 0
var attackTimer : float = attackCooldown
var attackResetTimer : float = attackResetCooldown
var playerRotX : float = 1.0
var isMoving = false



func _ready():
	animPlayer.clear_queue()
	animPlayer.play("Idle")
	animPlayer.queue("Idle")
	
	

func _process(delta):
	HandleWalking()
	HandlePlayerRotation(delta)
	HandleAttackCycle(delta)
	CheckIdle()
	HandleAnimStates()
	
	

## Handle animation states and play animations
func HandleAnimStates():
	match currentState:
		state.idle:
			if animPlayer.current_animation != "Idle":
				animPlayer.clear_queue()
				animPlayer.stop()
				animPlayer.play("Idle",1,1)
				animPlayer.queue("Idle")
		state.walking:
			if animPlayer.current_animation != "Walking":
				animPlayer.clear_queue()
				animPlayer.stop()
				animPlayer.play("Walking")
				animPlayer.queue("Walking")
		state.attacking:
			if !animPlayer.current_animation.contains("Attack"):
				var animName = "Attack"+ str(currentAttackCount)
				animPlayer.clear_queue()
				animPlayer.stop()
				animPlayer.play(animName)



## Handle player movement input, set movement velocity, deaccelerate, rotate body and set anim state
func HandleWalking():
	isMoving = false
	if Input.is_action_pressed("Up"):
		isMoving = true
		velocity.y -= moveSpeed
	if Input.is_action_pressed("Down"):
		isMoving = true
		velocity.y += moveSpeed
	if Input.is_action_pressed("Right"):
		isMoving = true
		velocity.x += moveSpeed
	if Input.is_action_pressed("Left"):
		isMoving = true
		velocity.x -= moveSpeed
	
	velocity.x = clampf(velocity.x,maxVelocity * -1.0,maxVelocity)
	velocity.y = clampf(velocity.y,maxVelocity * -1.0,maxVelocity)
	
	velocity -= velocity * 0.1
	
	if isMoving == true and currentState != state.attacking:
		currentState = state.walking

	move_and_slide()




## Handle rotation with delta time by scaling .x 
func HandlePlayerRotation(delta):
	if velocity.x >0:
		playerRotX = clampf(playerRotX - delta * 10,-1.0,1.0)
	else:
		playerRotX = clampf(playerRotX + delta * 10,-1.0,1.0)
	
	playerBody.scale.x = clampf(playerRotX,-1.0,1.0)




func CheckIdle():
	if !isMoving and currentState != state.attacking:
		currentState = state.idle




## Handle player attack cycle and state
func HandleAttackCycle(delta):
	attackTimer -= delta
	if currentAttackCount != 0 :
		attackResetTimer -= delta
	
	if attackResetTimer <= 0 and currentAttackCount != 0:
		currentAttackCount = 0
		attackResetTimer = attackResetCooldown
	
	if Input.is_action_pressed("Attack"):
		if attackTimer <= 0:
			attackTimer = attackCooldown
			currentState = state.attacking




func _on_animation_player_animation_finished(anim_name : String):
	if anim_name.contains("Attack"):
		currentAttackCount += 1
		if currentAttackCount > 3:
			currentAttackCount = 0
		currentState = state.idle