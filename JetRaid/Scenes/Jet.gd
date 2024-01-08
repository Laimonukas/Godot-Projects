extends CharacterBody2D

@export var moveSpeed = 10
@onready var animSprite = get_node("AnimatedSprite2D")
@onready var animPlayer = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
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
		
		
	
	move_and_slide()
