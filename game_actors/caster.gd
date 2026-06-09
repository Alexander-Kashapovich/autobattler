extends Alive
class_name Caster
## May cast spell
@export var cast_point:Node2D

var caster_stats:CasterStat

func get_cast_point() -> Vector2:
	return cast_point.global_position
