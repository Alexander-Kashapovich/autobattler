extends TestCastEvaluator
class_name HPEvaluator

@export var to_greater:bool = 1
@export var quad:bool = 0

func exec(t:Alived) -> float:
	var val:float = (
		# 1 / -1
		t.hp.percentage() * (2 * int(to_greater) - 1) + 
		# 0 / 1
		1.0 * (1 - int(to_greater))
		)
	return (val ** (1 + int(quad))) * value
