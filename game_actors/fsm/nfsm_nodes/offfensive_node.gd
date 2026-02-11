extends NFSMNode
class_name Offensive

@export var retreat_threshold:float = 0.4

func enter_update() -> void:
	ctx.pawn.hp.modified.connect(on_hp_modified)
	
	bb.current_target_position = ctx.mng.get_invasion_point(ctx.fraction)
	logg("Set target_point to invasion")

func on_hp_modified(val:float) -> void:
	if val < retreat_threshold:
		logg("Low HP")
		request_transition.emit(ID.STUNNED)

func exit_update() -> void:
	ctx.pawn.hp.modified.disconnect(on_hp_modified)
	
