extends Node2D
var jet: jetClass

func _on_area_2d_body_entered(body):
	if body.name == "Jet":
		jet = body
		jet.JetCollided()
