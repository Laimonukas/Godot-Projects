extends Node

var highScore = 0
const savePath = "res://savegame.bin"

func SaveGame():
	var saveFile = FileAccess.open(savePath,FileAccess.WRITE)
	var data = {
		"highScore":highScore
	}
	var jstr = JSON.stringify(data)
	saveFile.store_line(jstr)
	
	
func LoadGame():
	var saveFile = FileAccess.open(savePath,FileAccess.READ)
	if FileAccess.file_exists(savePath):
		if not saveFile.eof_reached():
			var currentLine = JSON.parse_string(saveFile.get_line())
			if currentLine:
				highScore = currentLine["highScore"]
