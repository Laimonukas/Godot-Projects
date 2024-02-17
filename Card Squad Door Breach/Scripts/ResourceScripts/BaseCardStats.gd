extends Resource
class_name CardBaseStats

@export var healthPoints : int = 1
@export var armorPoints : int = 1
@export var attackPoints : int = 1

var currentHp = healthPoints

func TakeDamage(dmgAmount : int = 0):
	currentHp -= clampi(dmgAmount - armorPoints,0,healthPoints)
	if currentHp <= 0:
		pass
