extends Node2D

var baseMapSpawnerSpeed : float
var baseRiverSpeed : float
@export var wallHandler : wallsHandler
@export var waterNode : Sprite2D
@export var sandNodes : Array[Sprite2D]
var waterMaterial : Material
var sandMaterials : Array[Material]
enum speedState {normal, faster, slower}
var score : int = 0
var isGameOver : bool = false

@onready var jetNode : jetClass = $"Jet"
@onready var uiNode :baseUi = $"Jet/Ui"
@onready var fuelNode : FuelNodeClass = $FuelNode

func _ready():
	wallHandler.bridgeDestroyed.connect(bridgeCallBack)
	baseMapSpawnerSpeed = wallHandler.speed
	waterMaterial = waterNode.material
	baseRiverSpeed = waterMaterial.get_shader_parameter("speed")
	for sand in sandNodes:
		sandMaterials.append(sand.material)
	jetNode.jetDestroyed.connect(GameOver)
	wallHandler.jetDestroyed.connect(GameOver)
	
	for enemy : BaseAI in get_tree().get_nodes_in_group("Enemy"):
		enemy.connect("destroyed",bridgeCallBack)
	
	
func _process(delta):
	if !isGameOver:
		HandleSpeedAndStates(delta)
		UIUpdates()
	elif Input.is_action_pressed("Shoot"):
		get_tree().change_scene_to_file("res://Levels/GameLevel.tscn")


func HandleSpeedAndStates(delta):
	baseMapSpawnerSpeed += delta
	
	var state = speedState.normal
	if Input.is_action_pressed("SpeedUp"):
		state = speedState.faster
	elif Input.is_action_pressed("SlowDown"):
		state = speedState.slower
	
	match state:
		speedState.normal:
			ChangeSpeed(1.0)
			score += delta * 100
		speedState.faster:
			ChangeSpeed(3.0)
			score += delta * 100 * 3.0
		speedState.slower:
			ChangeSpeed(0.4)
			score += delta * 0.5  * 100
	
func UIUpdates():
	if jetNode.position.x > 760 and uiNode.isOnRightSide:
		uiNode.switchSide()
	elif jetNode.position.x < 360 and !uiNode.isOnRightSide:
		uiNode.switchSide()
	uiNode.score=score
	uiNode.healthPoints = jetNode.healthPoints
	uiNode.fuelPoints = jetNode.fuelPoints
	uiNode.updateValues()
	
	
			
func bridgeCallBack():
	score += 100


func ChangeSpeed(multiplier : float = 1.0):
	fuelNode.speed = baseMapSpawnerSpeed * multiplier
	wallHandler.speed = baseMapSpawnerSpeed * multiplier
	waterMaterial.set_shader_parameter("speed",baseRiverSpeed * multiplier)
	for mat in sandMaterials:
		mat.set_shader_parameter("speed",baseRiverSpeed * multiplier)
		
func GameOver():
	isGameOver = true
	$GameOverScene.visible = true
	$GameOverScene/Control/ScoreLabel.text = "Final Score: " + str(score)
	$Jet/Ui.visible = false
	jetNode._on_jet_destroyed()
	ChangeSpeed(1.0)
	
	
	
