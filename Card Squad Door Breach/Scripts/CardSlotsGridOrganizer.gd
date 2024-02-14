@tool
extends Node2D

@export var rowLen : int = 8
var slots : Array[Node2D] = []

func _enter_tree():
	if Engine.is_editor_hint():
		for child : CardBoardSlot in get_children():
			#assuming slot count <= 99
			var arrCoord : int = int(child.name.right(2))
			var x : int = arrCoord % rowLen
			var y : int = arrCoord / rowLen
			child.gridCoords = [x,y]
