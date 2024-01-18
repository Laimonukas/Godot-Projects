extends CharacterBody2D

class_name ProjectileClass

@export var moveSpeed : float = 400
@export var direction : Vector2 = Vector2(0.0,-1.0)
@export var maxDistance = 2000
var distanceTraveled = 0.0

func _ready():
	velocity = direction * moveSpeed


func _process(delta):
	distanceTraveled += velocity.length() * delta
	if distanceTraveled >= maxDistance:
		queue_free()
	move_and_slide()


func _on_area_2d_body_entered(body):
	if body.name == "Jet":
		body.JetCollided()
		queue_free()
