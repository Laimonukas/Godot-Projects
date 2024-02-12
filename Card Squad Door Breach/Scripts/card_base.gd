extends Node2D

class_name CardBase

enum cardTypes {Personnel, Equipment, Tactics, Mission, Obstacle}
enum cardTeam {Player, Enemy, Neutral}
enum faceStates {FaceUp, FaceDown}

@export var type : cardTypes
@export var team : cardTeam
@export var currentFaceState : faceStates
@export var statsSheet : CardBaseStats
@export var showStats : bool = false

var cardInHand : bool = true
var mouseHover : bool = false


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


func _on_collision_area_mouse_exited():
	mouseHover = false
	
func Move(Destination):
	pass
