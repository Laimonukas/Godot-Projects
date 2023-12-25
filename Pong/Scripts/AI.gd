extends CharacterBody2D

var speed = 3
var ballNode
var direction = Vector2(0,0)
var initPos 
var size = 3

func _ready():
	initPos = global_position.x
	scale.y = size


func _process(delta):
	if ballNode != null:
		direction = ballNode.global_position - global_position
		direction = direction.normalized()
		position.y += direction.y * speed

	move_and_collide(velocity)
	if global_position.x != initPos:
		global_position.x = initPos
