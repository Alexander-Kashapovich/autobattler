@tool
extends Effect
class_name DamageEffect

@export var val:float

func _base_evaluate() -> float:
	return val

func execute(c:SkillExecutionContext) -> void:
	var dmg:float = val
	
	dmg += c.caster_stats.attack_bonus
	dmg *= c.caster_stats.power
	
	dmg *= (1 - c.target.stats.def)
	dmg -= c.target.stats.shield
	
	if dmg < 0:
		return
	
	c.add_exp(dmg)

	c.target.apply_damage(dmg)
