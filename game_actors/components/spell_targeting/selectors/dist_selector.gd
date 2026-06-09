extends TestCastSelector
class_name DistSelector

@export var threshold:float = 100.0
@export var is_greater:bool

func exec(ctx:TestCast) -> bool:
	var dist:float = ctx.target.global_position.distance_squared_to(ctx.caster.global_position)
	
	var k:float = -1.0 + 2 * int(is_greater)
	return dist * k > threshold * threshold * k
