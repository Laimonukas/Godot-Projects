extends Node



func _on_button_pressed():
	$UI/Button.visible = false
	var moveTween = get_tree().create_tween().set_parallel(true)
	moveTween.tween_property($Player,"global_position",$UI/Button.global_position,1)
	moveTween.tween_property($Player,"scale",Vector2(0,0),1)
	var fadeTween = get_tree().create_tween()
	fadeTween.tween_property($UI/Fade,"self_modulate:a",1,0.8)
	fadeTween.tween_callback(tCallBack)
	

func tCallBack():
	get_tree().change_scene_to_file("res://Levels/Level.tscn")
