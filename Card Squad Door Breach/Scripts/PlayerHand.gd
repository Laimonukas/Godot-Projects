extends Node2D
class_name PlayerHand

@export var handSlots : Array[Node2D]

@export var maxCameraZoom : float = 5
@export var minCameraZoom : float = 0.5
@export var zoomSpeed : float = 0.2
@export var dragSensitivity : float = 1.0
@export var camNode : Camera2D


var currentCardCount : int = 0
var pickedUpCard : CardBase

func ReturnEmptySlot():
	for slot in handSlots:
		if slot.get_child_count() == 0:
			return slot
	return null
	
func _input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		position -= event.relative * dragSensitivity / camNode.zoom 




