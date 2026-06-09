@tool
extends LeafState
class_name Move

@export var speed:float = 130

func get_id() -> ID:
	return ID.MOVE

func enter_update() -> void:
	ctx.nv.target_reached.connect(on_target_reached)
	
	ctx.nv.set_target_manual(bb.current_target_position)
	logg("Set nv to current target pos")
	ctx.mover.start()
	logg("Mover Start")

func exec(delta:float) -> void:
	ctx.move(speed * ctx.nv.get_next_point_dir())
	
func on_target_reached() -> void:
	logg("Target reached")
	request_transition.emit(ID.IDLE)

func exit_update() -> void:
	ctx.nv.target_reached.disconnect(on_target_reached)
	ctx.mover.stop()
	logg("Mover stop")
