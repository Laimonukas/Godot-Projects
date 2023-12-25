extends CharacterBody2D

@export var initialSpeed = 5
@export var speedMultiplier = 1.2
var rng = RandomNumberGenerator.new()
@onready var particles = get_node("CPUParticles2D")

func _ready():
	InitialRelease()


func _process(delta):
	var collision = move_and_collide(velocity)
	if collision != null:
		velocity.x = velocity.bounce(collision.get_normal()).x + rng.randf_range(-0.8,0.8)
		velocity.y = velocity.bounce(collision.get_normal()).y + rng.randf_range(-0.8,0.8)
		if collision.get_collider().is_class("CharacterBody2D"):
			velocity.y = velocity.y + (collision.get_collider_velocity().y / 100)
			velocity *= speedMultiplier
		#particles.gravity = velocity * 10
		particles.direction = velocity.normalized() * 1
		#particles.restart()
		#particles.emitting = true
		collision = null



func InitialRelease():
	var side = rng.randi_range(0,1)
	if side==0:
		side = -1
	velocity.x = side * initialSpeed
	
	velocity.y = rng.randf_range(-0.7,0.7) * initialSpeed
