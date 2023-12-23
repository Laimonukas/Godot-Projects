extends AspectRatioContainer

func _ready():
	GlobalUtils.SaveGame()
	GlobalUtils.LoadGame()

func _on_quit_button_pressed():
	get_tree().quit();


func _on_new_level_pressed():
	get_tree().change_scene_to_file("res://Maps/Level_1.tscn");
