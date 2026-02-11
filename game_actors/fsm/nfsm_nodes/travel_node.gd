extends NFSMNode
class_name Travel

func enter_update() -> void:
	ctx.targeter.target_setted.connect(on_target_setted)
	logg("Target setter connect")

	if ctx.target():
		request_transition.emit(ID.CHASE)
		logg("Target already have")

func on_target_setted() -> void:
	logg("Target setted")
	request_transition.emit(ID.CHASE)

func exit_update() -> void:
	ctx.targeter.target_setted.disconnect(on_target_setted)
	logg("Target setter disconnect")
	
