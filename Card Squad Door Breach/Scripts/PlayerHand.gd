extends Node2D
class_name PlayerHand

@export var handSlots : Array[Node2D]

@export var maxCameraZoom : float = 0.5
@export var minCameraZoom : float = 2.0
@export var zoomSpeed : float = 0.2
@export var dragSensitivity : float = 1.0
@export var zoomFloat : float = 1.0
@export var moveableNodes : Node2D
@export var moveableBoundsNode : Node2D

var currentCardCount : int = 0
var pickedUpCard : CardBase
var dragging : bool = false

func ReturnEmptySlot():
	for slot in handSlots:
		if slot.get_child_count() == 0:
			return slot
	return null
	
func _input(event):
	var offset = moveableBoundsNode.scale
	offset.x = -(offset.x * zoomFloat) + (offset.x * 0.5)
	offset.y = -(offset.y * zoomFloat) + (offset.y * 0.465)
	
	
	if event is InputEventMouseMotion \
	and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) \
	and moveableNodes != null:
		moveableNodes.position += event.relative * dragSensitivity * zoomFloat
		dragging = true
	else:
		dragging = false

	if Input.is_action_pressed("CamZoomIn"):
		zoomFloat = clampf(zoomFloat + zoomSpeed,maxCameraZoom,minCameraZoom)
		moveableNodes.scale = Vector2(zoomFloat,zoomFloat)
	elif Input.is_action_pressed("CamZoomOut"):
		zoomFloat = clampf(zoomFloat - zoomSpeed,maxCameraZoom,minCameraZoom)
		moveableNodes.scale = Vector2(zoomFloat,zoomFloat)
		
	moveableNodes.position.x = clampf(moveableNodes.position.x,offset.x, 0.0)
	moveableNodes.position.y = clampf(moveableNodes.position.y,offset.y, 0.0)

