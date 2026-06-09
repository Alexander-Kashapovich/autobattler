@tool
extends Skill
class_name ProjectileSkill
## Launch projectile and executing after target reached

@export var skill_scene:PackedScene

func execute(c:SkillExecutionContext) -> void:
	var inst:SkillScene = skill_scene.instantiate()
	c.target.add_sibling(inst)
	inst.target_reached.connect(_apply_to_target)
	inst.start(c)
