extends CharacterBody2D
class_name  jetClass

@export var moveSpeed = 10
@export var animSprite : AnimatedSprite2D
@export var shadowSprite :AnimatedSprite2D
@export var animPlayer : AnimationPlayer
@export var bullet : PackedScene
@export var fireRate = 0.2
@export var immune : bool = false
@export var healthPoints = 6
@export var fuelPoints = 100
var cooldown = fireRate
var defaultY

signal jetDestroyed

func _ready():
	defaultY = position.y
	animPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	HandleSideAnimationAndMovement()
	
	if Input.is_action_pressed("Shoot"):
		if cooldown >= 0:
			cooldown -= delta
		else:
			cooldown = fireRate
			ShootProjectiles()
	
	fuelPoints -= delta
	
	SetShadow()
	move_and_slide()
	
	
	


func SetShadow():
	shadowSprite.flip_h = animSprite.flip_h
	shadowSprite.animation = animSprite.animation
	shadowSprite.frame = animSprite.frame

func ShootProjectiles():
	var projectile : CharacterBody2D = bullet.instantiate() 
	projectile.position = position
	add_sibling(projectile)
	
func JetCollided():
	if !immune:
		if animPlayer.current_animation!="destroyed":
			animPlayer.clear_queue()
			animPlayer.stop()
			animPlayer.play("collided")
			animPlayer.queue("idle")
			$Hit.emitting = true
			healthPoints -= 1
	if healthPoints <= 0:
		jetDestroyed.emit()
		
	
func _on_jet_destroyed():
	if animPlayer.current_animation != "destroyed":
		animPlayer.clear_queue()
		animPlayer.stop()
		animPlayer.play("destroyed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "destroyed":
		queue_free()

func HandleSideAnimationAndMovement():
	position.y = defaultY
	if(Input.is_action_pressed("Left")):
		velocity.x -= moveSpeed
	if(Input.is_action_pressed("Right")):
		velocity.x += moveSpeed
		
	var v = velocity.x
	
	if v > -50 and v < 50:
		animSprite.frame = 0
	
	if v > 50 and v < 150:
		animSprite.flip_h = false
		animSprite.frame = 1
	elif v > 150:
		animSprite.flip_h = false
		animSprite.frame = 2
	
	if v < -50 and v > -150:
		animSprite.flip_h = true
		animSprite.frame = 1
	elif v < -150:
		animSprite.flip_h = true
		animSprite.frame = 2
		
