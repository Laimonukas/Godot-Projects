extends Node2D

class_name GameManager

@export var playerController : PlayerController
@export var aiManager : AIManager
@export var comboCooldown : float = 5.0
@export var waveUi : Control

var comboTimer = comboCooldown
var unrealizedScore : int = 0
var scoreMultiplier : int = 1
var score : int = 0
var wave : int = 1
var highScore : int = GlobalUtils.highScore
var endTimer : float = 3.0

func _ready():
	aiManager.connect("scoreIncreased",IncreaseScore)
	aiManager.connect("allEnemiesKilled",WaveDone)
	playerController.connect("playerDied",PlayerDied)
	GlobalUtils.LoadGame()
	waveUi.connect("animEnded",WaveIntroEnded)
	waveUi.StartAnimation()
	
func _process(delta):
	comboTimer -= delta
	if comboTimer <= 0:
		score += unrealizedScore * scoreMultiplier
		unrealizedScore = 0
		scoreMultiplier = 1
		if score > GlobalUtils.highScore:
			GlobalUtils.highScore = score
			GlobalUtils.SaveGame()
	HandlePlayerEnd(delta)

func IncreaseScore(increaseAmount : int):
	$AudioStreamPlayer.play()
	comboTimer = comboCooldown
	unrealizedScore += increaseAmount
	scoreMultiplier += 1


func WaveDone():
	wave += 1
	$AudioStreamPlayer.play()
	if score > GlobalUtils.highScore:
		GlobalUtils.highScore = score
		GlobalUtils.SaveGame()
	waveUi.StartAnimation()
	

func PlayerDied():
	score += unrealizedScore * scoreMultiplier
	unrealizedScore = 0
	scoreMultiplier = 1
	if score > GlobalUtils.highScore:
		GlobalUtils.highScore = score
		GlobalUtils.SaveGame()
		
func WaveIntroEnded():
	aiManager.SpawnEnemies(wave * 5)
	

func HandlePlayerEnd(delta):
	if playerController == null:
		endTimer -=delta
		if endTimer <= 0:
			$CanvasLayer/EndUi.visible = true
			if Input.is_action_pressed("Attack"):
				get_tree().change_scene_to_file("res://Levels/MainLevel.tscn")

