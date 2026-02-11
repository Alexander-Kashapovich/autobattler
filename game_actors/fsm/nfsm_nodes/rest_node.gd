extends NFSMNode
class_name Rest

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = 8.0
	
	_timer.timeout.connect(timeout)
	_timer.name = nom() + " timer"
	ctx.pawn.add_child(_timer)

func enter_update() -> void:
	ctx.pawn.hp.full.connect(on_hp_full)
	ctx.nv.target_reached.connect(on_target_reached)
	
	_timer.start()
	logg("Rest timer start")

func on_hp_full() -> void:
	logg("Full hp")
	request_transition.emit(ID.OFFENSIVE)

func on_target_reached() -> void:
	bb.current_target_position = ctx.mng.get_home_point(ctx.fraction)
	_transition_to(ID.IDLE)

func exit_update() -> void:
	ctx.pawn.hp.full.disconnect(on_hp_full)
	ctx.nv.target_reached.disconnect(on_target_reached)
	_timer.stop()
	
func timeout() -> void:
	logg("Rest timer timeout")
	request_transition.emit(ID.OFFENSIVE)
	
