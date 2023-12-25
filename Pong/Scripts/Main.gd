extends Node2D

const ballScene = preload("res://Scenes/Ball.tscn")
@onready var spawnNode = $BallSpawnLocation
var ballCooldown = 5.0
var newSpawn = false

var scores = [0,0]
var firstLoad = true

func _process(delta):
	if (Input.is_action_pressed("Up") or Input.is_action_pressed("Down")) and firstLoad:
		firstLoad = false
		SpawnNewBall()
	
	if Input.is_action_pressed("Restart"):
		get_tree().change_scene_to_file("res://Levels/MainLevel.tscn")
	
	while newSpawn:
		if ballCooldown >= 0:
			ballCooldown -= delta
		else:
			SpawnNewBall()
			ballCooldown = 5.0
			newSpawn = false



func _on_player_zone_body_entered(body):
	if body.name == "Ball":
		body.queue_free()
		scores[1] += 1
		UpdateScoringLabels()

func _on_enemy_zone_body_entered(body):
	if body.name == "Ball":
		body.queue_free()
		scores[0] += 1
		UpdateScoringLabels()
		


func SpawnNewBall():
	var instance = ballScene.instantiate()
	instance.name = "Ball"
	spawnNode.add_child(instance)
	$AI.ballNode = instance

func UpdateScoringLabels():
	$UI/Labels/PlayerScore.text = str(scores[0])
	$UI/Labels/EnemyScore.text = str(scores[1])
	newSpawn = true;




func _on_ai_size_drag_ended(value_changed):
	$AI.scale.y = 3  * $"UI/TabContainer/AI Settings/AISize".value


func _on_player_size_drag_ended(value_changed):
	$Player.scale.y = 3 * $"UI/TabContainer/Player Settings/PlayerSize".value


func _on_player_speed_drag_ended(value_changed):
	$Player.speed = 5 * $"UI/TabContainer/Player Settings/PlayerSpeed".value


func _on_ai_difficulty_drag_ended(value_changed):
	$AI.speed = 3 * $"UI/TabContainer/AI Settings/AIDifficulty".value


func _on_button_pressed():
	scores = [0,0]
	$UI/Labels/PlayerScore.text = str(scores[0])
	$UI/Labels/EnemyScore.text = str(scores[1])
	
