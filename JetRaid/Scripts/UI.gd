extends Control
class_name baseUi

@export var score : int = 0
@export var healthPoints : float = 6.0
@export var fuelPoints : float = 100.0
@export var isOnRightSide : bool = true

@onready var fuelBar : ProgressBar = $Control/FuelBar
@onready var hpBar : ProgressBar = $Control/HPBar
@onready var scoreLabel : Label = $Control/ScoreLabel
@onready var baseControl : Control = $Control
var tween : Tween





func setMax():
	fuelBar.max_value = fuelPoints
	fuelBar.value = fuelPoints
	hpBar.max_value = healthPoints
	hpBar.value = healthPoints
	
	
func updateValues():
	fuelBar.value = fuelPoints
	hpBar.value = healthPoints
	scoreLabel.text = "Score: " + str(score)
	
	
func switchSide():
	tween = get_tree().create_tween()
	if isOnRightSide:
		isOnRightSide = false
		tween.tween_property(baseControl,"position:x",-350.0,0.2)
		#baseControl.position.x = -350.0
	else:
		isOnRightSide = true
		#baseControl.position.x = 0
		tween.tween_property(baseControl,"position:x",0.0,0.2)
