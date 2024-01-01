extends Node2D

@export var obstaclesToSpawn =  PackedStringArray()
@export var moveSpeed = 300
@export var maxMoveSpeed = 2000
@export var spawnCooldown = 3
@export var playerHealthCount = 3 
var isPlaying = true
var cooldown = spawnCooldown
var preloadedNodes = []
var score = 0
var rng = RandomNumberGenerator.new()

@onready var path2D = get_node("Path2D/PathFollow2D")

func _ready():
	for i in obstaclesToSpawn.size():
		preloadedNodes.append(load(str(obstaclesToSpawn[i])))
	$UI/ProgressBar.max_value = playerHealthCount
	$UI/ProgressBar.value = playerHealthCount
	GlobalUtils.LoadGame()
	$UI/HighScore.text = "High score: "+ str(int(GlobalUtils.highScore))

func _process(delta):
	if isPlaying:
		score += delta * moveSpeed * 0.1
		$UI/CurrentScore.text = "Current score: "+ str(int(score))
		moveSpeed = clampf(moveSpeed+delta*5, 100,maxMoveSpeed)
		spawnCooldown = clampf(spawnCooldown-delta*0.1,1,3)
		$Paralax.scrollSpeed = moveSpeed
		
		if cooldown > 0:
			cooldown -= delta
		else:
			SpawnObject()
			cooldown = spawnCooldown
	
	
func _on_player_player_collided():
	playerHealthCount -= 1
	$UI/ProgressBar.value = playerHealthCount
	if playerHealthCount <= 0:
		$Player.PlayDeath()
		isPlaying = false
		if score > GlobalUtils.highScore:
			GlobalUtils.highScore = score
			GlobalUtils.SaveGame()
		$UI/EndGame.visible = true
	

func SpawnObject():
	var randomInt = rng.randi_range(0,preloadedNodes.size()-1)
	var obstacle = preloadedNodes[randomInt].instantiate()
	path2D.progress_ratio = rng.randf_range(0,1)
	obstacle.position = path2D.global_position
	if path2D.progress_ratio > 0.5:
		obstacle.rotation = Vector2.LEFT.angle()
	obstacle.speed = moveSpeed
	add_child(obstacle)


func _on_area_2d_area_entered(area):
	area.get_parent().queue_free()


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Levels/Level.tscn")
