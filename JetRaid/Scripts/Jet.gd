extends CharacterBody2D
class_name  jetClass

@export var moveSpeed = 10
@export var animSprite : AnimatedSprite2D
@export var shadowSprite :AnimatedSprite2D
@export var animPlayer : AnimationPlayer
@export var bullet : PackedScene
@export var fireRate = 0.2
@export var immune : bool = false
@export var healthPoints = 3
var cooldown = fireRate


func _ready():
	animPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("Left")):
		velocity.x -= moveSpeed
		animSprite.flip_h = true
	if(Input.is_action_pressed("Right")):
		velocity.x += moveSpeed
		animSprite.flip_h = false
	
	if Input.is_action_pressed("Shoot"):
		if cooldown >= 0:
			cooldown -= delta
		else:
			cooldown = fireRate
			ShootProjectiles()
	
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
		animPlayer.play("collided")
		$Hit.emitting = true
		healthPoints -= 1
	
