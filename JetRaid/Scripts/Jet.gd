extends CharacterBody2D

@export var moveSpeed = 10
@export var animSprite : AnimatedSprite2D
@export var shadowSprite :AnimatedSprite2D
@export var animPlayer : AnimationPlayer

func _ready():
	animPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("Left")):
		position.x -= moveSpeed
		animSprite.flip_h = true
	if(Input.is_action_pressed("Right")):
		position.x += moveSpeed
		animSprite.flip_h = false
		
	SetShadow()
	move_and_slide()


func SetShadow():
	shadowSprite.flip_h = animSprite.flip_h
	shadowSprite.animation = animSprite.animation
	shadowSprite.frame = animSprite.frame
