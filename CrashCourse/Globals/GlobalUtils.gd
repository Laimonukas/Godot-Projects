extends Node

const savePath = "res://savegame.bin"

func SaveGame():
	var saveFile = FileAccess.open(savePath,FileAccess.WRITE)
	var data = {
		"HP":GlobalVars.playerHealth,
		"Gold":GlobalVars.playerGold
	}
	var jstr = JSON.stringify(data)
	saveFile.store_line(jstr)
	
	
func LoadGame():
	var saveFile = FileAccess.open(savePath,FileAccess.READ)
	if FileAccess.file_exists(savePath):
		if not saveFile.eof_reached():
			var currentLine = JSON.parse_string(saveFile.get_line())
			if currentLine:
				GlobalVars.playerHealth = currentLine["HP"]
				GlobalVars.playerGold = currentLine["Gold"]
				
