extends Node2D

class_name AIManager

## export variables
@export var packedThug : PackedScene
@export var packedSpecial : PackedScene
@export var playerController: PlayerController
@export var spawnExtent : Vector2
@export var spawnOrigin : Vector2 
@export var destinationExtent : Vector2
@export var destinationOrigin : Vector2

## variables
var rng = RandomNumberGenerator.new()

## signals
signal scoreIncreased (increasedAmount : int)
signal allEnemiesKilled



func _ready():
	#SpawnEnemies(6)
	pass
	
	
## default spawn function
func SpawnEnemies(count : int = 1):
	if count > 0:
		for i in count:
			var instance : AIController = packedThug.instantiate()
			instance.global_position = RandomPoint(spawnOrigin, spawnExtent)
			instance.set_name("Thug"+str(i))
			instance.destination = RandomPoint(destinationOrigin, destinationExtent)
			instance.connect("aiDied",OnInstanceDeath.bind(instance))
			add_child(instance)


## return a random point in box shape
func RandomPoint(origin : Vector2 , extent : Vector2):
	var x = rng.randf_range(origin.x,extent.x)
	var y = rng.randf_range(origin.y,extent.y)
	
	return Vector2(x, y)
	


func OnInstanceDeath(instance : AIController):
	if get_child_count() <= 1:
		SpecialAttack(instance)
	else:
		scoreIncreased.emit(100)
		instance.DieFunction()
	



func SpecialAttack(thugInstance : AIController):
	var instance : SpecialAtack = packedSpecial.instantiate()
	instance.player = playerController
	instance.thug = thugInstance
	instance.global_position = thugInstance.global_position
	instance.connect("specialEnded",OnSpecialEnd)
	call_deferred("add_child",instance)



func OnSpecialEnd(slashCount:int ):
	scoreIncreased.emit(slashCount * 100)
	allEnemiesKilled.emit()
