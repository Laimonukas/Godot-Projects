extends Node2D
class_name PlayerHand

@export var handSlots : Array[Node2D]
var currentCardCount : int = 0
var pickedUpCard : CardBase

func ReturnEmptySlot():
	for slot in handSlots:
		if slot.get_child_count() == 0:
			return slot
	return null
