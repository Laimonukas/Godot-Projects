extends Node2D

class_name RandomChatter

@export var showTimer : float = 5.0
@export var labelNode : Label 
@export var quotes : Array[String]
@export var maxWaitTime : float = 60.0

var rng = RandomNumberGenerator.new()
var timer = showTimer
var waitTime : float = 0.0

func _ready():
	waitTime = rng.randf_range(10.0,maxWaitTime)
	labelNode.visible = false

func _process(delta):
	if !labelNode.visible:
		waitTime -= delta
		if waitTime <= 0:
			waitTime = rng.randf_range(10.0,maxWaitTime)
			labelNode.text = quotes[rng.randi_range(0,quotes.size()-1)]
			labelNode.visible = true
	else:
		timer -= delta
		if timer <= 0:
			labelNode.visible = false
			timer = showTimer



