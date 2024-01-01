extends Node2D

@export var speed = 200

func _process(delta):
	position.x -= speed * delta


func _on_area_2d_body_entered(body):
	match body.name:
		"Player":
			body.PlayerHit()
