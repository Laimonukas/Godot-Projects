extends Node2D

class_name FuelNodeClass

@export var moveCooldown : float = 5.0

@onready var follower : PathFollow2D = $Path2D/PathFollow2D

var rng = RandomNumberGenerator.new()
var speed = 100
var moveTimer = moveCooldown


func _ready():
	Reset()

func _process(delta):
	HandleMovement(delta)


func HandleMovement(delta):
	if moveTimer <= 0:
		$Sprite2D.position.y += delta * speed
		if $Sprite2D.position.y >= 1500:
			Reset()
	else:
		moveTimer -= delta
	

func Reset():
	follower.progress_ratio = rng.randf_range(0.0,1.0)
	$Sprite2D.position.x = follower.position.x
	$Sprite2D.position.y = follower.position.y
	$Explosion.emitting = false
	$Sprite2D.visible = true
	$Sprite2D.set_deferred("monitoring",true)
	moveTimer = moveCooldown

func Explode():
	$Explosion.position = $Sprite2D.position
	$Explosion.emitting = true
	$Sprite2D.visible = false
	$Sprite2D.set_deferred("monitoring",false)
	for enemy : BaseAI in get_tree().get_nodes_in_group("Enemy"):
		enemy.CallDestroy()
	

func _on_area_2d_body_entered(body):
	match body.collision_layer:
			2:
				body.queue_free()
				Explode()
			14:
				var player : jetClass = body
				player.fuelPoints = 100
				Reset()
			_:
				pass


func _on_explosion_finished():
	Reset()
