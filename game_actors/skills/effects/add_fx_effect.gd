@tool
extends Effect
class_name AddFXEffect

@export var val:float = 0
@export var fx_scene:PackedScene

func _base_evaluate() -> float:
	return 0

func execute(c:SkillExecutionContext) -> void:
	var fx := fx_scene.instantiate()
	c.target.add_child(fx)
	fx.start()
	
