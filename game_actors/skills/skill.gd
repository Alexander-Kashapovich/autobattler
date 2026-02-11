@icon("res://editor_assets/skill_icon.svg")
@tool
extends Resource
class_name Skill

@export var target_effects:Array[Effect]

@export var bonus_value:float = 0
@export var _base_value:float = -INF
func base_evaluate() -> float:
	_base_value = 0
	for e in target_effects:
		_base_value += e.base_evaluate()
	_base_value += bonus_value
	return _base_value

func get_value() -> float:
	assert(_base_value != -INF)
	return _base_value

func _apply_to_target(c:SkillExecutionContext) -> void:
	for e in target_effects:
		e.execute(c)

func execute(c:SkillExecutionContext) -> void:
	_apply_to_target(c)
