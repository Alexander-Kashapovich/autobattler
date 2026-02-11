extends NFSMNode
class_name AliveState

func enter_update() -> void:
	ctx.pawn.died.connect(on_died)
	logg("Died connected")
	
func on_died(_self:Unit) -> void:
	request_transition.emit(ID.DYING)

func exit_update() -> void:
	ctx.pawn.died.disconnect(on_died)
	logg("Died disconnected")
