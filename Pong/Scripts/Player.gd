extends CharacterBody2D

@export var speed = 5
var initPos 

func _ready():
	initPos = global_position.x



func _process(delta):
	if Input.is_action_pressed("Up"):
		position.y -= speed 
	if Input.is_action_pressed("Down"):
		position.y += speed 
	move_and_collide(velocity)
	if global_position.x != initPos:
		global_position.x = initPos
