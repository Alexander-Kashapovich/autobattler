@tool
extends Skill
class_name BuffSkill

@export var tick:float
@export var time:float

@export var end_skill:Skill

func base_evaluate() -> float:
	_base_value = 0
	for e in target_effects:
		_base_value += e.base_evaluate()
	_base_value += bonus_value
	return _base_value * (1 + tick/time)

func execute_on_end(c:SkillExecutionContext) -> void:
	if end_skill:
		end_skill.execute(c)
