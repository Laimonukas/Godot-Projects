extends ExtraAction

@export var amount : int = 1

func Action(initiator : CardBase = null,target : CardBase = null):
	if target.statsSheet != null:
		target.statsSheet.IncreaseHealth(target,amount)
