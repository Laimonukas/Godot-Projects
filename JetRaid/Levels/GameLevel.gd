extends Node2D

var baseMapSpawnerSpeed : float
var baseRiverSpeed : float
@export var wallHandler : Node2D
@export var waterNode : Sprite2D
@export var sandNodes : Array[Sprite2D]
var waterMaterial : Material
var sandMaterials : Array[Material]
enum speedState {normal, faster, slower}
var score : float = 0.0

func _ready():
	baseMapSpawnerSpeed = wallHandler.speed
	waterMaterial = waterNode.material
	baseRiverSpeed = waterMaterial.get_shader_parameter("speed")
	for sand in sandNodes:
		sandMaterials.append(sand.material)
	
func _process(delta):
	var state = speedState.normal
	if Input.is_action_pressed("SpeedUp"):
		state = speedState.faster
	elif Input.is_action_pressed("SlowDown"):
		state = speedState.slower
	
	match state:
		speedState.normal:
			ChangeSpeed(1.0)
			score += delta * baseMapSpawnerSpeed
		speedState.faster:
			ChangeSpeed(3.0)
			score += delta * baseMapSpawnerSpeed * 2.0
		speedState.slower:
			ChangeSpeed(0.4)
			score += delta * baseMapSpawnerSpeed * 0.5
			
			
			

func ChangeSpeed(multiplier : float = 1.0):
	wallHandler.speed = baseMapSpawnerSpeed * multiplier
	waterMaterial.set_shader_parameter("speed",baseRiverSpeed * multiplier)
	for mat in sandMaterials:
		mat.set_shader_parameter("speed",baseRiverSpeed * multiplier)
