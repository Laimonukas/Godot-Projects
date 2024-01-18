extends Path2D

class_name BaseAI

@export var endLoopCd : float = 3.0
@export var healthPoints : int = 5
@export var shotCooldown : float = 3.0
@export var destroyedCooldown : float = 3.0
@export var bulletScene : PackedScene
@export var movementMultiplier : float = 0.15
@export var loopRatio : float = 0.5

@onready var follower: PathFollow2D = $PathFollow2D

var goingForward : bool = true

var cd
var endLoopTimer
var destroyedTimer = 0.0
var jetNode : jetClass

signal destroyed

func _ready():
	cd = shotCooldown
	endLoopTimer = endLoopCd
	jetNode = $"../Jet"

func _process(delta):
	HandleShooting(delta)
	HandleMovement(delta)

func HandleShooting(delta):
	if follower.progress_ratio >= loopRatio and destroyedTimer <= 0:
		if cd >= 0:
			cd -= delta
		else:
			cd = shotCooldown
			if jetNode != null:
				var bullet : ProjectileClass = bulletScene.instantiate()
				bullet.collision_layer = 0
				bullet.get_node("Area2D").collision_mask = 8
				bullet.global_position = follower.global_position
				bullet.direction = (jetNode.global_position - follower.global_position ).normalized()
				
				add_sibling(bullet)
		

func HandleMovement(delta):
	if destroyedTimer <= 0:
		if goingForward:
			follower.progress_ratio += delta * movementMultiplier
			$PathFollow2D/MainBody.rotation_degrees = 90
			if follower.progress_ratio >= 1.0:
				endLoopTimer -= delta
				if endLoopTimer <= 0:
					goingForward = false
					endLoopTimer = endLoopCd
		else:
			follower.progress_ratio -= delta * movementMultiplier
			$PathFollow2D/MainBody.rotation_degrees = -90
			if follower.progress_ratio <= loopRatio:
				goingForward = true
	else:
		destroyedTimer -= delta
	

func _on_area_2d_body_entered(body):
	var hitParticle : CPUParticles2D = $PathFollow2D/Hit
	match body.collision_layer:
		2:
			hitParticle.emitting = true
			hitParticle.global_position = body.global_position
			hitParticle.direction = global_position - body.global_position
			body.queue_free()
			
			healthPoints -= 1
			if healthPoints <= 0:
				CallDestroy()
		14:
			print("jet")
		_:
			#Catch all
			print("JetBridgeCollision")
			print(body.collision_layer)

func CallDestroy():
	$PathFollow2D/MainBody.visible = false
	$PathFollow2D/Explosion.global_position = follower.global_position
	$PathFollow2D/Explosion.emitting = true
	$PathFollow2D/Area2D.set_deferred("monitoring",false)
	destroyed.emit()
	destroyedTimer = destroyedCooldown


func _on_explosion_finished():
	$PathFollow2D/MainBody.visible = true
	$PathFollow2D/Area2D.set_deferred("monitoring",true)
	follower.progress_ratio = 0.0
	healthPoints = 5
	
