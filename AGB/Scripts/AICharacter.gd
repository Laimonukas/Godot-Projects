extends CharacterBody2D

## copied from player controller. could've done some inheritence /zzzz
class_name AIController

## Nodes
@export var animPlayer : AnimationPlayer
@export var specialAnimPlayer : AnimationPlayer
@export var playerBody : Node2D
@export var playerController : PlayerController

## set variables
@export var moveSpeed : float = 50.0
@export var maxVelocity : float = 400.0
var attackCooldown : float = 2.0
@export var attackResetCooldown : float = 1.0
@export var attackCount :int = 2

## signals:
signal aiDied


## other
enum state {idle,walking, attacking}
var currentState = state.idle
var currentAttackCount : int = 0
var attackTimer : float = attackCooldown
var attackResetTimer : float = attackResetCooldown
var playerRotX : float = 1.0
var isMoving = false
var destination : Vector2
var isAggroed = false
var rng = RandomNumberGenerator.new()


func _ready():
	animPlayer.clear_queue()
	animPlayer.play("Idle")
	animPlayer.queue("Idle")
	attackCooldown = rng.randf_range(1.0,2.0)
	ChangeThugVariation()
	
	

func _process(delta):
	HandleWalking()
	if isAggroed:
		if playerController != null :
			HandlePlayerRotation(delta,true,(playerController.global_position - global_position).normalized())
	else:
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



## Handle ai movement, set movement velocity, deaccelerate, rotate body and set anim state
func HandleWalking():
	isMoving = false
	var direction = (destination - global_position).normalized()
	var distance = destination.distance_to(global_position)
	
	if distance >= 50:
		velocity = direction * moveSpeed
	else:
		velocity = Vector2.ZERO
	
	if velocity.length() > 0:
		isMoving = true
	
	velocity.x = clampf(velocity.x,maxVelocity * -1.0,maxVelocity)
	velocity.y = clampf(velocity.y,maxVelocity * -1.0,maxVelocity)
	
	velocity -= velocity * 0.1
	
	if isMoving == true and currentState != state.attacking:
		currentState = state.walking

	move_and_slide()




## Handle rotation with delta time by scaling .x 
func HandlePlayerRotation(delta, byDirection : bool = false,direction : Vector2 = Vector2.ZERO):
	if !byDirection:
		if velocity.x >0:
			playerRotX = clampf(playerRotX - delta * 10,-1.0,1.0)
		else:
			playerRotX = clampf(playerRotX + delta * 10,-1.0,1.0)
	else:
		if direction.x > 0:
			playerRotX = clampf(playerRotX - delta * 10,-1.0,1.0)
		else:
			playerRotX = clampf(playerRotX + delta * 10,-1.0,1.0)
		
	
	playerBody.scale.x = clampf(playerRotX,-1.0,1.0)




func CheckIdle():
	if !isMoving and currentState != state.attacking:
		currentState = state.idle




## Handle player attack cycle and state
func HandleAttackCycle(delta):
	if isAggroed:		
		attackTimer -= delta
		if currentAttackCount != 0 :
			attackResetTimer -= delta
		
		if attackResetTimer <= 0 and currentAttackCount != 0:
			currentAttackCount = 0
			attackResetTimer = attackResetCooldown
		
		if attackTimer <= 0:
			attackTimer = attackCooldown
			currentState = state.attacking
			attackResetTimer = attackResetCooldown + attackCooldown




func _on_animation_player_animation_finished(anim_name : String):
	if anim_name.contains("Attack"):
		currentAttackCount += 1
		if currentAttackCount > attackCount:
			currentAttackCount = 0
		currentState = state.idle
		
		

func Hurt(attackIntensity : int = 0):
	specialAnimPlayer.play("global/HurtAnim")
	if playerController != null:
		velocity += -(playerController.global_position - global_position).normalized() * moveSpeed * 100 * float(attackIntensity)
	move_and_slide()
	
	

## aggro range 
func _on_agro_area_body_entered(body):
	if body.name == "PlayerCharacter":
		isAggroed = true
		playerController = body
		destination = body.global_position

func _on_agro_area_body_exited(body):
	if body.name == "PlayerCharacter":
		isAggroed = false
		destination.x = body.global_position.x + rng.randf_range(-5.0,5.0)
		destination.y = body.global_position.y + rng.randf_range(-5.0,5.0)
		attackTimer = attackCooldown
		attackResetTimer = attackResetCooldown + attackCooldown



func ChangeThugVariation():
	playerBody.scale = playerBody.scale * rng.randf_range(0.8,1.4)
	var color : Color = Color(rng.randf_range(0.1,1.0),rng.randf_range(0.1,1.0),rng.randf_range(0.1,1.0),1.0)
	playerBody.modulate = playerBody.modulate.blend(color)
