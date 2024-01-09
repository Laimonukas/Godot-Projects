extends Node2D

@export var sandArray : Array[Polygon2D]
@export var speed = 1.0

func _process(delta):
	for sandNode in sandArray:
		sandNode.offset.y += speed *delta
