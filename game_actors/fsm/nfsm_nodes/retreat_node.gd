extends NFSMNode
class_name Retreat

@export var comeback_threshold:float = 0.7
func enter_update() -> void:
	ctx.pawn.hp.modified.connect(on_hp_modified)
	ctx.nv.target_reached.connect(on_home_reached)
	
	bb.current_target_position = ctx.pawn.mng.get_home_point(ctx.fraction)
	logg("Set target point to home")

func on_hp_modified(val:float) -> void:
	if val > comeback_threshold:
		logg("Enough hp")
		request_transition.emit(ID.OFFENSIVE)

func on_home_reached() -> void:
	request_transition.emit(ID.REST)

func exit_update() -> void:
	ctx.pawn.hp.modified.disconnect(on_hp_modified)
	ctx.nv.target_reached.disconnect(on_home_reached)
