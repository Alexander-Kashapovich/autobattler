@tool
extends Effect
class_name SelfTeleportationEffect

#[0,1.2] of distance
# > 1.0 - behind back
@export var val:float = 0.7

func _base_evaluate() -> float:
	return val

func execute(c:SkillExecutionContext) -> void:
	var vec:Vector2 = -c.cast_point + c.get_apply_point()
	var dist:float = vec.length() * val
	var dir:Vector2 = vec.normalized()
	
	c.caster.global_position += dir * dist
