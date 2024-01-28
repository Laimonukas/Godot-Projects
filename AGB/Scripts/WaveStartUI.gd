extends Control

@export var gManager : GameManager 

signal animEnded

func UpdateWaveCount():
	if gManager != null:
		$Label.text = "Wave " + str(gManager.wave)
	else:
		$Label.text = "Wave X"

func StartAnimation():
	$AnimationPlayer.play("WaveStart")


func _on_animation_player_animation_finished(anim_name):
	animEnded.emit()
