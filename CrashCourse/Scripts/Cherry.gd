extends Area2D



func _on_body_entered(body):
	if body.name == "Player":
		GlobalVars.playerGold += 1
		var tween = get_tree().create_tween()
		var tween1 = get_tree().create_tween()
		tween.tween_property(self,"position",body.global_position,0.25)
		tween1.tween_property(self,"modulate:a",0,0.25)
		tween.tween_callback(queue_free)
