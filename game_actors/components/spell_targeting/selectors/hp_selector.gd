extends TestCastSelector
class_name HpSelector

@export var hp_threshold:float = 0.9
@export var is_greater:bool

func exec(ctx:TestCast) -> bool:
	var k:float = -1.0 + 2 * int(is_greater)
	return ctx.target.hp.percentage() * k > hp_threshold * k
