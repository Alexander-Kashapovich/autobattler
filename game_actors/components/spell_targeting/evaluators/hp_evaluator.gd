extends TestCastEvaluator
class_name HPEvaluator
## value if full/0

@export var to_greater:bool = 1
@export var quad:bool = 0

func exec(ctx:TestCast) -> float:
	var sign:int = (2 * int(to_greater) - 1)
	var val:float = (
		# 1 / -1
		ctx.target.hp.percentage() * sign + 
		# 0 / 1
		1.0 * (1 - int(to_greater))
		)
	return (val ** (1 + int(quad))) * value
