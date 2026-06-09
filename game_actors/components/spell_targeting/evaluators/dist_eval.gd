extends TestCastEvaluator
class_name DistanceEvaluator
## Per every 100px +- value

@export var plus_is_greater:bool = 1

func exec(ctx:TestCast) -> float:
	var dist:float = (ctx.caster.global_position - ctx.target.global_position).length()
	var sign:int = (2 * int(plus_is_greater) - 1)
	return sign  *  dist/100 * value
