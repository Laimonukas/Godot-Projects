extends Node2D

class_name CardBase

enum cardTypes {Personnel, Equipment, Tactics, Mission, Obstacle}
enum cardTeam {Player, Enemy, Neutral}
enum faceStates {FaceUp, FaceDown}
enum playStates {InDeck, InHand, OnBoard, IsPickedUp}

@export var type : cardTypes
@export var team : cardTeam
@export var currentFaceState : faceStates
@export var currentPlayState : playStates
@export var statsSheet : CardBaseStats
@export var showStats : bool = false

var mouseHover : bool = false
var destinationTransform : Transform2D
var destinationWeight : float = 1.0
var parentNode : Node2D
var playerHandNode : PlayerHand

func _ready():
	pass

func _process(delta):
	HandleMoving(delta)
	HandlePickUp()
	HandleCamDrag()



func PlacementAction():
	pass
	
func BasicAction():
	pass

func ExtraAction():
	pass

func AttackAction():
	pass

func DieAction():
	pass

func PlayAction():
	pass

func _on_collision_area_mouse_entered():
	mouseHover = true
	match currentPlayState:
		playStates.InHand:
			if !playerHandNode.dragging:
				var originalTransform = parentNode.global_transform
				var newTransform : Transform2D = Transform2D(0.0,\
					originalTransform.get_scale(),\
					originalTransform.get_skew(),Vector2(originalTransform.get_origin().x,\
						originalTransform.get_origin().y - 100.0))
				MoveCard(newTransform)

func _on_collision_area_mouse_exited():
	mouseHover = false
	match currentPlayState:
		playStates.InHand:
			MoveCard(parentNode.global_transform)
	
func MoveCard(destinationT : Transform2D):
	destinationTransform = destinationT
	destinationWeight = 0.0
	
func HandleMoving(delta):
	if destinationWeight < 1.0:
		destinationWeight = clampf(destinationWeight + delta * 5, 0.0, 1.0)
		global_transform = global_transform.interpolate_with(destinationTransform,destinationWeight)
		
func HandlePickUp():
	if playerHandNode != null:
		if Input.is_action_pressed("LMouse"):
			if mouseHover and playerHandNode.pickedUpCard == null:
				match currentPlayState:
					playStates.InHand:
						playerHandNode.pickedUpCard = self
			
			if playerHandNode.pickedUpCard == self:
				match currentPlayState:
					playStates.InHand:
						global_position = get_global_mouse_position()
			else:
				MoveCard(parentNode.global_transform)
		elif Input.is_action_just_released("LMouse"):
			playerHandNode.pickedUpCard = null
			match currentPlayState:
				playStates.InHand:
					MoveCard(parentNode.global_transform)

func HandleCamDrag():
	if playerHandNode !=null:
		if playerHandNode.dragging:
			mouseHover = false
			playerHandNode.pickedUpCard = null
			match currentPlayState:
				playStates.InHand:
					MoveCard(parentNode.global_transform)
		

