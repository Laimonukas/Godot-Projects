extends Control

class_name BasicUI

@export var gManager : GameManager
@export var player : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		$PanelContainer/VBoxContainer/HBoxContainer2/HPProgressBar.value = player.healthPoint
		$PanelContainer/VBoxContainer/HBoxContainer/MultiplierProgressBar.value = gManager.comboTimer
		$PanelContainer/VBoxContainer/HBoxContainer/ScoreMultiplierLabel.text = "Multiplier: X" + str(gManager.scoreMultiplier)
		$PanelContainer/VBoxContainer/ScoreLabel.text = "Score: "+ str(gManager.score)
		$PanelContainer/VBoxContainer/HighScoreLabel.text = "HighScore: " + str(GlobalUtils.highScore)
	else:
		queue_free()
