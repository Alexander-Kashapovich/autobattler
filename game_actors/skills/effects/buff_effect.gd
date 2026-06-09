@tool
extends Effect
class_name BuffEffect
##Apply [BuffSkill] to target.

@export var buff:BuffSkill
@export var is_unique:bool = 0

func _base_evaluate() -> float:
	return buff.base_evaluate()
	
func execute(c:SkillExecutionContext) -> void:
	c.target.append_buff(buff,c)
