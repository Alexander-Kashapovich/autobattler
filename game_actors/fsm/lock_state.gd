@abstract
extends LeafState
class_name CommonLock

@export
var lock_time:float = 0.4

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = lock_time
	
	_timer.timeout.connect(_timeout)
	_timer.name = nom() + " timer"
	ctx.unit.add_child(_timer)

func control_flow_enter() -> void:
	_timer.start()
	bb.logg(nom() + " timer started for " + str(_timer.wait_time))
	super.control_flow_enter()

func control_flow_exit() -> void:
	super.control_flow_exit()
	_timer.stop()
	bb.logg(nom() + " timer stoped on " + str(_timer.time_left))
	exit_update()

func _timeout() -> void:
	bb.logg(nom() + " timer stoped on full time")
	timeout()

@abstract
func timeout() -> void
