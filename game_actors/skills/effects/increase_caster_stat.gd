@tool
extends Effect
class_name AffectStatEffect

@export var shield_val:float
@export var defence_val:float

@export var power_val:float
@export var attack_bonus_val:float

func _base_evaluate() -> float:
	return (
		(shield_val + attack_bonus_val) * 0.3 +
		(defence_val + power_val) * 2.0
		)

func execute(c:SkillExecutionContext) -> void:
	c.target.stats.def += defence_val
	c.target.stats.shield += shield_val
	
	if c.target is Caster:
		c.target.caster_stats.power += power_val
		c.target.caster_stats.attack_bonus += attack_bonus_val
	
	var s:String = ""
	s += str(c.target.stats.def) + "\n"
	s += str(c.target.stats.shield) + "\n"
	s += str(c.target.caster_stats.power) + "\n"
	s += str(c.target.caster_stats.attack_bonus) + "\n"
	c.caster.mng.fx.add_text(c.caster.global_position,s)
