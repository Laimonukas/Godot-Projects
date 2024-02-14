extends Node2D
class_name CardBoardSlot

@export var spriteNode : Sprite2D
@export var greenHighlightColor : Color 
@export var redHighlightColor : Color
@export var gridCoords = [0,0]
@export var isVisible : bool = false
@export var slotTags : Array


var defaultColor

func _ready():
	defaultColor = spriteNode.self_modulate
	
func HighlightSlot(colorId : int = 0):
	match colorId:
		0:
			spriteNode.self_modulate = defaultColor
		1:
			spriteNode.self_modulate = greenHighlightColor
		2:
			spriteNode.self_modulate = redHighlightColor
