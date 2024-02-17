@tool
extends Node2D
class_name SlotsManager

@export var rowLen : int = 8
@export var slots :Array[Node2D] = []
@export var playerHand : PlayerHand

var visibilitySet = false

func _enter_tree():
	if Engine.is_editor_hint():
		slots.clear()
		for slot : CardBoardSlot in get_children():
			visibilitySet = false
			UpdateTags(slot)
			slots.append(slot)
		visibilitySet = true

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

func QuerySlotsInRange(range : int = 1):
	pass
	
func QueryMovementSlots(tagsArr = [],coordinates = [0,0]):
	var returnArr = []
	var x = coordinates[0]
	var y = coordinates[1]
	var coordArr= [[x+1,y],[x-1,y],[x,y+1],[x,y-1]]
	
	for slot in slots:
		if slot.gridCoords in coordArr:
			for tag in tagsArr:
				if tag in slot.slotTags:
					returnArr.append(slot)
	return returnArr

func UpdateTags(slot : CardBoardSlot = null):
	if slot != null:
		#assuming slot count <= 99
		var arrCoord : int = int(slot.name.right(2))
		var tagsArray = []
		var x : int = arrCoord % rowLen
		var y : int = arrCoord / rowLen
		slot.gridCoords = [x,y]
		
		slot.slotTags.clear()
		if slot.get_child_count() <= 1 and "empty" not in slot.slotTags:
			slot.slotTags.append("empty")
		
		if slot.get_child_count() > 1:
			var child = slot.get_child(1)
			child.parentNode = slot
			if child.playerHandNode == null:
				child.playerHandNode = playerHand
			slot.placedCard = child
		
		if x <= 1 and "deployZone" not in slot.slotTags:
			slot.slotTags.append("deployZone")
		
		if !visibilitySet:
			visibilitySet = true
			if x > 2 and "invisible" not in slot.slotTags:
				slot.slotTags.append("invisible")
			elif "visible" not in slot.slotTags:
				slot.slotTags.append("visible")
			
		#slot.slotTags = tagsArray
		if slot.placedCard != null and slot.placedCard.cardTags != null:
			slot.slotTags.append_array(slot.placedCard.cardTags.tags)


