extends Node2D

class_name CardBase

enum faceStates {FaceUp, FaceDown}
enum playStates {InDeck, InHand, OnBoard, IsPickedUp}

@export var currentFaceState : faceStates
@export var currentPlayState : playStates
@export var slotsManager : SlotsManager
@export var frontFace : Sprite2D
@export var backFace : Sprite2D


var mouseHover : bool = false
var destinationTransform : Transform2D
var destinationWeight : float = 1.0
var parentNode : Node2D
var playerHandNode : PlayerHand
var placementSlots = []
var closestSlot : CardBoardSlot
var flippingWeight : float = 1.0
var flipToFront = false
#resources
@export var statsSheet : CardBaseStats
@export var placementResource : PlacementTags
@export var cardTags : CardTags


func _ready():
	if currentFaceState == faceStates.FaceDown:
		backFace.visible = true
		frontFace.visible = false

func _process(delta):
	HandleMoving(delta)
	HandleFlipping(delta)
	HandlePickUp()
	HandleCamDrag()



func PlacementAction():
	print("PlacementAction")
	
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
	
func MovementAction():
	print("MovementAction")
	
func RevealAction():
	print("RevealAction")

func _on_collision_area_mouse_entered():
	if playerHandNode != null and playerHandNode.pickedUpCard != self:
		mouseHover = true
		match currentPlayState:
			playStates.InHand:
				if !playerHandNode.dragging :
					var originalTransform = parentNode.global_transform
					var newTransform : Transform2D = Transform2D(0.0,\
						originalTransform.get_scale(),\
						originalTransform.get_skew(),Vector2(originalTransform.get_origin().x,\
							originalTransform.get_origin().y - 100.0))
					MoveCard(newTransform)

func _on_collision_area_mouse_exited():
	if playerHandNode != null and playerHandNode.pickedUpCard != self:
		mouseHover = false
		match currentPlayState:
			playStates.InHand:
				MoveCard(parentNode.global_transform)
			playStates.OnBoard:
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
						closestSlot = null
					playStates.OnBoard:
						playerHandNode.pickedUpCard = self
						closestSlot = null
			if playerHandNode.pickedUpCard == self:
				match currentPlayState:
					playStates.InHand:
						QueryForPlacement()
						closestSlot = GetClosestSlotToMouse()
						if closestSlot != null:
							closestSlot.HighlightSlot(3)
							MoveCard(closestSlot.global_transform)
						else:
							var newT : Transform2D = parentNode.global_transform
							newT.origin = get_global_mouse_position()
							MoveCard(newT)
					playStates.OnBoard:
						if cardTags != null and "moveable" in cardTags.tags:
							GetActionableSlots()
							closestSlot = GetClosestSlotToMouse()
							if closestSlot != null:
								closestSlot.HighlightSlot(3)
								MoveCard(closestSlot.global_transform)
							else:
								var newT : Transform2D = parentNode.global_transform
								newT.origin = get_global_mouse_position()
								MoveCard(newT)
			else:
				closestSlot = null
				MoveCard(parentNode.global_transform)
		elif Input.is_action_just_released("LMouse"):
			match currentPlayState:
				playStates.InHand:
					if closestSlot != null:
						ChangeParentToSlot(closestSlot)
						currentPlayState = playStates.OnBoard
						PlacementAction()
					#MoveCard(parentNode.global_transform)
				playStates.OnBoard:
					if closestSlot != null:
						if "empty" in closestSlot.slotTags:
							ChangeParentToSlot(closestSlot)
							currentPlayState = playStates.OnBoard
							MovementAction()
						if "unrevealed" in closestSlot.slotTags:
							RevealAction()
			mouseHover = false
			playerHandNode.pickedUpCard = null
			closestSlot = null
			DeHighlightSlots()
			MoveCard(parentNode.global_transform)		

func HandleCamDrag():
	if playerHandNode !=null:
		if playerHandNode.dragging:
			mouseHover = false
			playerHandNode.pickedUpCard = null
			match currentPlayState:
				playStates.InHand:
					MoveCard(parentNode.global_transform)
		

func QueryForPlacement():
	if slotsManager != null:
		placementSlots = slotsManager.QuerySlots(placementResource.tagsArray)
		for slot : CardBoardSlot in placementSlots:
			slot.HighlightSlot(1)

func DeHighlightSlots():
	if placementSlots.size() > 0:
		for slot : CardBoardSlot in placementSlots:
			slot.HighlightSlot(0)
			
func GetClosestSlotToMouse(slotArray=placementSlots, distance : float = 50.0):
	if slotArray.size() > 0:
		for slot :CardBoardSlot in slotArray:
			if slot.global_position.distance_to(get_global_mouse_position()) < distance:
				return slot
	return null

func ChangeParentToSlot(slot : CardBoardSlot):
	if slot != null:
		var gPos = global_position
		var parent = get_parent()
		if parent is CardBoardSlot:
			parent.placedCard = null
			parent.slotTags.append("empty")
		parent.remove_child(self)
		slot.add_child(self)
		global_position = gPos
		parentNode = slot
		if cardTags != null:
			slot.slotTags.append_array(cardTags.tags)
		slot.slotTags.erase("empty")
		slot.placedCard = self
		return parent
	return null
		
func HandleFlipping(delta):
	if flippingWeight < 1.0:
		flippingWeight = clampf(flippingWeight + delta * 5, 0.0 , 1.0)
		var weight : float = flippingWeight * 2.0 - 1.0
		if weight > -0.1 and weight < 0.1:
			if flipToFront:
				frontFace.visible = true
				backFace.visible = false
			else:
				backFace.visible = true
				frontFace.visible = false
		scale.x = weight

func FlipCard():
	flippingWeight = 0.0
	if currentFaceState == faceStates.FaceUp:
		flipToFront = false
		currentFaceState = faceStates.FaceDown
	else:
		flipToFront = true
		currentFaceState = faceStates.FaceUp

func GetActionableSlots():
	#var actionableSlots = []
	var movementTags = ["empty","unrevealed"]
	if slotsManager != null:
		placementSlots = slotsManager.QueryMovementSlots(movementTags,parentNode.gridCoords)
		for slot in placementSlots:
			slot.HighlightSlot(1)

