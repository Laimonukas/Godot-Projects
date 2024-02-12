extends Node2D
class_name CardDeck

@export var cardScenes : Array[PackedScene]
@export var maxCardAmount : int = 20

var currentCardCount : int = 0
var rng = RandomNumberGenerator.new()
var deck = []

signal deckEmpty

func _ready():
	if cardScenes.size() > 0:
		cardScenes.shuffle()
		for i in range(maxCardAmount):
			var card : CardBase = cardScenes.pick_random().instantiate()
			add_child(card)
			card.currentFaceState = card.faceStates.FaceDown
			card.global_position = global_position
			deck.append(card)

func DrawCard():
	if deck.size() > 0:
		var card = deck.pop_front()
		return card
	deckEmpty.emit()

