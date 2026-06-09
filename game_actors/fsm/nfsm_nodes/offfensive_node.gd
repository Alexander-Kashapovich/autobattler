@tool
extends NFSMNode
class_name Offensive

## hp part when go to home
@export var retreat_threshold:float = 0.4

func get_id() -> ID:
	return ID.OFFENSIVE

func enter_update() -> void:
	ctx.unit.hp.modified.connect(on_hp_modified)
	
	bb.current_target_position = ctx.get_invasion()
	logg("Set target_point to invasion")

func on_hp_modified(val:float) -> void:
	logg("hp: %s" % val)
	if val < retreat_threshold:
		logg("Low HP")
		request_transition.emit(ID.STUNNED)

func exit_update() -> void:
	ctx.unit.hp.modified.disconnect(on_hp_modified)
	
