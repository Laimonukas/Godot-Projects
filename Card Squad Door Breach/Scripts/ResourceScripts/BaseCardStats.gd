extends Resource
class_name CardBaseStats

@export var healthPoints : int 
@export var armorPoints : int 
@export var attackPoints : int 

@export var currentHp : int 

func _init():
	currentHp = healthPoints

func TakeDamage(target: CardBase = null, dmgAmount : int = 0):
	currentHp -= clampi(dmgAmount - armorPoints,0,healthPoints)
	if target != null:
		target.UpdateCardStats()
	if currentHp <= 0:
		pass

func IncreaseHealth(target: CardBase = null, healAmount : int = 0):
	currentHp = clampi(currentHp + healAmount,1,healthPoints)
	if target != null:
		target.UpdateCardStats()
