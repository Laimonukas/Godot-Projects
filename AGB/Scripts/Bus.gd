extends Node2D

class_name BusEnemy

@export var busArea : Area2D
@export var pathFollower : PathFollow2D
@export var timer : float = 5.0
var time = 0.0

func _ready():
	$AudioStreamPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time +=delta
	$groundIndication.modulate = Color(1.0,sin(time),sin(time),0.25)
	timer -= delta
	if timer <= 0 :
		pathFollower.progress_ratio += delta / 3.0
		if pathFollower.progress_ratio >= 1.0:
			queue_free()
	


func _on_area_2d_body_entered(body):
	if body.name == "PlayerCharacter":
		body.Hurt()
	elif body.name.contains("Thug"):
		body.Hurt()
