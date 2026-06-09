@tool
extends LeafState
class_name Chase
## Requires a guarantee ctx.target()

##chasing_speed low of move speed(sprint)
@export var speed:float = 120

var _timer:Timer

func get_id() -> ID:
	return ID.CHASE

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = 0.3
	
	_timer.timeout.connect(chasing_handle)
	_timer.name = nom() + " timer"
	ctx.unit.add_child(_timer)
	

func enter_update() -> void:
	_timer.start()
	ctx.mover.start()
	logg("Mover Start")
	ctx.targeter.target_lost.connect(on_target_lost)

func exec(delta:float) -> void:
	ctx.nv.update_moving_target(ctx.target())
	
	ctx.mover.move(speed * ctx.nv.get_next_point_dir())

	var dist_sq:float = (
		ctx.unit.get_cast_point() - ctx.target().global_position
		).length_squared()
	
	if bb.is_have_a_good_spell():
		request_transition.emit(ID.PRECAST)
		return

	if (dist_sq < ctx.attack_comp.range_sq()):
			request_transition.emit(ID.SWING)

func exit_update() -> void:
	_timer.stop()
	ctx.mover.stop()
	logg("Mover Stop")
	ctx.targeter.target_lost.disconnect(on_target_lost)

func chasing_handle() -> void:
	ctx.targeter.find_best_target()

func on_target_lost() -> void:
	request_transition.emit(ID.TRAVEL)
