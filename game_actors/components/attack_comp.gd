extends Node
class_name AttackComp
## Like a [Spell] with zero cooldown. Nedded by handle distance in chasing

@export var caster:Caster

var base_skill:Skill
var cast_range:float

func attack(target:Alive) -> void:
	if not (target and target.alive): return
	var ctx := SkillExecutionContext.new()
	ctx.setup_from_unit(caster,target)
	base_skill.execute(ctx)

func range_sq() -> float: 
	return cast_range * cast_range
