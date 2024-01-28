extends Node2D

class_name SpecialAtack

## exports
@export var player : PlayerController
@export var thug : AIController
@export var timer : float = 5.0

## onready
@onready var particles: CPUParticles2D = $CPUParticles2D

#vars
var camera : Camera2D
var camZoom
var slashCount : int = 0
var slashDirection : Vector2 = Vector2.ZERO

# signals
signal specialEnded (slashCount)

func _ready():
	camera = player.get_node("Camera2D")
	camZoom = camera.get_zoom()
	player.modulate = Color.BLACK
	thug.modulate = Color.BLACK
	camera.set_zoom(Vector2(2.5,2.5))
	get_tree().paused = true
	
func _process(delta):
	particles.global_position = get_global_mouse_position()
	particles.direction = slashDirection.direction_to(particles.global_position)
	slashDirection = particles.global_position
	timer -= delta
	if timer <= 0:
		specialEnded.emit(slashCount)


## counting slashes
func _on_area_2d_mouse_entered():
	pass


func _on_area_2d_mouse_exited():
	slashCount += 1


func _on_special_ended(slashCount):
	player.modulate = Color.WHITE
	thug.modulate = Color.WHITE
	camera.set_zoom(camZoom)
	get_tree().paused = false
	thug.queue_free()
	queue_free()
