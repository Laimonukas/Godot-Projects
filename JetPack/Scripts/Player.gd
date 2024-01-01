extends CharacterBody2D


@onready var arms = get_node("CollisionShape2D/Node2D/Arms")
@onready var legs = get_node("CollisionShape2D/Node2D/Legs")
@onready var fire = get_node("CollisionShape2D/Node2D/JetPack/Fire")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
enum states {inAir, grounded}
var currentState
@export var speed = 1500.0
var hurtCooldown = 1
signal PlayerCollided
var canBeHurt = true


func _process(delta):
	if not is_on_floor():
		currentState = states.inAir
		velocity.y += gravity * delta
	else:
		currentState = states.grounded
		
	if Input.is_action_pressed("jump"):
		velocity.y -= speed * delta
		fire.scale += Vector2(delta,delta)
		fire.scale.x = clampf(fire.scale.x,0.1,1.2)
		fire.scale.y = clampf(fire.scale.y,0.1,1.2)
	else:
		var size = clampf(velocity.normalized().y,-1,-0.2)
		fire.scale = Vector2(size,size) 
		
	if velocity.y != 0:
		arms.rotation += velocity.normalized().y *delta * 5
		arms.rotation = clamp(arms.rotation,-0.2,3)
		legs.rotation -= velocity.normalized().y *delta * 5
		legs.rotation = clamp(legs.rotation,-0.2,0.2)
	else:
		arms.rotation -= delta * 5
		arms.rotation = clamp(arms.rotation,-0.2,3)
		legs.rotation += delta * 5
		legs.rotation = clamp(legs.rotation,-0.2,0.2)
	
	if !canBeHurt:
		if hurtCooldown > 0:
			hurtCooldown -= delta
		else:
			hurtCooldown = 1
			canBeHurt = true
	move_and_slide()
	
func PlayerHit():
	if canBeHurt:
		emit_signal("PlayerCollided")
		$AnimationPlayer.play("hurt")
		canBeHurt = false
	
