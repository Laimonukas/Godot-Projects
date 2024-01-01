extends Node2D

@export var rotationSpeed = 1
var sinFloat = 0

func _process(delta):
	$BG/Vortex.rotation_degrees = $BG/Vortex.rotation_degrees + rotationSpeed * delta
	$BG/Vortex/Vortex2.rotation_degrees = $BG/Vortex/Vortex2.rotation_degrees + rotationSpeed * 2 * delta
	$BG/Vortex/Vortex2/Vortex3.rotation_degrees = $BG/Vortex/Vortex2/Vortex3.rotation_degrees + rotationSpeed * 2 * delta
	$BG/Vortex/Vortex2/Vortex3/Vortex4.rotation_degrees = $BG/Vortex/Vortex2/Vortex3/Vortex4.rotation_degrees + rotationSpeed * 2 * delta
	$BG/Vortex/Vortex2/Vortex3/Vortex4/Vortex5.rotation_degrees = $BG/Vortex/Vortex2/Vortex3/Vortex4/Vortex5.rotation_degrees + rotationSpeed * 2 * delta
	
	sinFloat += delta
	$BG/Vortex.scale.x = $BG/Vortex.scale.x + (sin(sinFloat)/2000)
	$BG/Vortex.scale.y = $BG/Vortex.scale.y + (sin(sinFloat)/2000)
