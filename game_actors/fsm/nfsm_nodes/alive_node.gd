@tool
extends NFSMNode
class_name AliveState

func get_id() -> ID:
	return ID.ALIVE

func enter_update() -> void:
	ctx.unit.died.connect(on_died)
	#logg("Died connected")
	
func on_died(_self:Unit) -> void:
	request_transition.emit(ID.DYING)

func exit_update() -> void:
	ctx.unit.died.disconnect(on_died)
	#logg("Died disconnected")
