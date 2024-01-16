extends Node2D

@export var wallScenes :Array[PackedScene]
@export var initialWallInstances : Array[Node2D]
@export var speed : float = 100.0
@export var rockFormation : Area2D
@export var bridge : Node2D
@export var bridgeCollider : Area2D
@export var bridgeSpriteParent : Node2D
@export var animationPlayer: AnimationPlayer
@export var bridgeHitPoints = 4
@export var bridgeExplosionParticles : CPUParticles2D
var currentBridgeHitpoint = bridgeHitPoints
var rockFormationCollider : CollisionShape2D
var rng = RandomNumberGenerator.new()

func _ready():
	for inst in initialWallInstances:
		inst.scale.x = rng.randf_range(0.7,1.3)
		inst.scale.y = rng.randf_range(0.7,1.3)
		var col = rng.randf_range(0.3,1)
		inst.modulate = Color(col,col,col)
		
	rockFormationCollider = rockFormation.get_child(0)
	for rocks : Node2D in rockFormationCollider.get_children():
		rocks.scale.x = rng.randf_range(0.6,1.6)
		rocks.scale.y = rng.randf_range(0.6,1.6)
		var col = rng.randf_range(0.3,1)
		rocks.modulate = Color(col,col,col)

func _process(delta):
	for inst in initialWallInstances:
		inst.position.y += delta * speed
		if inst.position.y > 800:
			inst.position.y = 0
			inst.scale.x = rng.randf_range(0.7,1.3)
			inst.scale.y = rng.randf_range(0.7,1.3)
			var col = rng.randf_range(0.3,1)
			inst.modulate = Color(col,col,col)
			
			if inst.position.x > 500:
				inst.position.x = rng.randf_range(1000,1100)
			else:
				inst.position.x = rng.randf_range(50,150)
				
	HandleBridgeLogic(delta)
	handleRockFormation(delta)






func handleRockFormation(delta):
	rockFormation.position.y += delta * speed
	
	if rockFormation.position.y > 1200:
		if bridge.position.y < 0:
			rockFormation.position.y = bridge.position.y - 400
		else:
			rockFormation.position.y = -400
		
		rockFormation.position.x = rng.randf_range(100,1000)
		rockFormation.scale.x = rng.randf_range(0.5,1.5)
		
		var extent = rockFormationCollider.shape.size
		var originPoint = rockFormationCollider.position - extent
		
		for rocks : Node2D in rockFormationCollider.get_children():
			rocks.scale.x = rng.randf_range(0.6,1.6)
			rocks.scale.y = rng.randf_range(0.6,1.6)
			rocks.position = RandomPoint(originPoint,extent)
			var col = rng.randf_range(0.3,1)
			rocks.modulate = Color(col,col,col)
		

func HandleBridgeLogic(delta):
	bridge.position.y += delta * speed
	if bridge.position.y > 1000:
		bridge.position.y = -1500
		bridgeCollider.monitoring = false
		currentBridgeHitpoint = bridgeHitPoints
		bridgeSpriteParent.visible = true
	
	if currentBridgeHitpoint > 0 and bridgeSpriteParent.visible:
		if bridge.position.y > 50:
			bridgeCollider.monitoring = true

		


		
func RandomPoint(origin,extent):
	var x = rng.randf_range(origin.x,extent.x)
	var y = rng.randf_range(origin.y,extent.y)
	
	return Vector2(x, y)


func _on_area_2d_body_entered(body):
	var hitParticles : CPUParticles2D = $Bridge/Hit
	match body.collision_layer:
		2:
			animationPlayer.play("BridgeHit")
			hitParticles.global_position = body.global_position
			hitParticles.emitting = true
			currentBridgeHitpoint -= 1
			if currentBridgeHitpoint <= 0:
				bridgeCollider.set_deferred("monitoring",false)
				bridgeSpriteParent.visible = false
				bridgeExplosionParticles.emitting = true
			body.queue_free()
		14:
			print("ssss")
		_:
			#Catch all
			print("JetBridgeCollision")
			print(body.collision_layer)




