@tool
extends Node2D
class_name SlotsManager

@export var rowLen : int = 8
@export var slots :Array[Node2D] = []

func _enter_tree():
	if Engine.is_editor_hint():
		slots.clear()
		for slot : CardBoardSlot in get_children():
			#assuming slot count <= 99
			var arrCoord : int = int(slot.name.right(2))
			var tagsArray = []
			var x : int = arrCoord % rowLen
			var y : int = arrCoord / rowLen
			slot.gridCoords = [x,y]
			
			slot.slotTags.clear()
			if slot.get_child_count() <= 1 and "empty" not in slot.slotTags:
				tagsArray.append("empty")
			if x <= 1 and "deployZone" not in slot.slotTags:
				tagsArray.append("deployZone")
				
			slot.slotTags = tagsArray
			slots.append(slot)

func QuerySlots(tagsArr = []):
	var returnArr = []
	for slot in slots:
		var foundAll = true
		for tag in tagsArr:
			if tag not in slot.slotTags:
				foundAll = false
				break
		if foundAll:
			returnArr.append(slot)
	return returnArr
