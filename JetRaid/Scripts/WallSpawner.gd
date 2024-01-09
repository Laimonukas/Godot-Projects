extends Node2D

@export var wallScenes :Array[PackedScene]
@export var rigidWallAreas : Array[Area2D]
@export var wallInstances : Array[Node2D]
@export var speed : float = 100.0
var rng = RandomNumberGenerator.new()

func _ready():
	for area in rigidWallAreas:
		var collisionShape : CollisionShape2D = area.get_child(0)
		var extents = collisionShape.shape.extents
		var originPoint = collisionShape.global_position - extents


func _process(delta):
	for inst in wallInstances:
		inst.position.y += delta * speed
		if inst.position.y > 800:
			inst.position.y
			
			if inst.position.x > 500:
				inst.position.x = rng.randf()
