extends CharacterBody3D



func _process(delta):
	pass
	
	
func HandleInputAndVelocity():
	if Input.is_action_pressed("Forward"):
		velocity += Vector3.FORWARD
	if Input.is_action_pressed("Backward"):
		velocity += Vector3.BACK
