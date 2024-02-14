extends Node2D

@export var playerDeck : CardDeck
@export var playerHand : PlayerHand
@export var slotsManager : SlotsManager

var playerHandSlots : Array[Node2D]

func _ready():
	playerHandSlots = playerHand.handSlots

func _process(delta):
	if Input.is_action_just_pressed("TestAction"):
		DrawCardForPlayer()

func DrawCardForPlayer():
	var emptySlot = playerHand.ReturnEmptySlot()
	if emptySlot != null and playerHand.currentCardCount != 6:
		var drawnCard : CardBase = playerDeck.DrawCard()
		var gTransform = drawnCard.global_transform
		drawnCard.get_parent().remove_child(drawnCard)
		emptySlot.add_child(drawnCard)
		drawnCard.global_transform = gTransform
		drawnCard.MoveCard(emptySlot.global_transform)
		drawnCard.currentPlayState = drawnCard.playStates.InHand
		drawnCard.parentNode = emptySlot
		drawnCard.playerHandNode = playerHand
		drawnCard.slotsManager = slotsManager
		playerHand.currentCardCount += 1
		
	
