@abstract
@tool
extends Resource
class_name Effect

@export var bonus_value:float = 0
@export var _base_value:float = -INF

func base_evaluate() -> float:
	_base_value = _base_evaluate()
	_base_value += bonus_value
	return _base_value

@abstract 
func _base_evaluate() -> float

func get_value() -> float:
	assert(_base_value != -INF)
	return _base_value
	
@abstract
func execute(c:SkillExecutionContext) -> void
