@tool
extends NFSMNode
class_name Travel

func get_id() -> ID:
	return ID.TRAVEL

func enter_update() -> void:
	ctx.targeter.target_setted.connect(on_target_setted)
	#logg("Target setter connect")
	
	## For default drop (from Cast, Precast) and dont affect Targeter
	if ctx.target():
		request_transition.emit(ID.CHASE)
		logg("Target already have")

func on_target_setted() -> void:
	#logg("Target setted")
	request_transition.emit(ID.CHASE)

func exit_update() -> void:
	ctx.targeter.target_setted.disconnect(on_target_setted)
	#logg("Target setter disconnect")
	
