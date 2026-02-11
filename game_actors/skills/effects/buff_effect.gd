@tool
extends Effect
class_name BuffEffect

@export var buff:BuffSkill

func _base_evaluate() -> float:
	return buff.evaluate()
	
func execute(c:SkillExecutionContext) -> void:
	c.target.append_buff(buff,c)
