extends SkillScene
class_name CurveProjectile

@export var speed:float = 500

var curve:BezieCurve

var _acc:float = 0
var _factor:float = -1

func _init() -> void:
	set_physics_process(0)

func start(c:SkillExecutionContext) -> void:
	if not c.target.alive:
		finish()
		return
	
	context = c
	c.target.died.connect(on_target_died,CONNECT_ONE_SHOT)
	
	var v0 = c.get_cast_point()
	var v2 = c.get_apply_point()
	
	curve = BezieCurve.new()
	curve.setup(v0,v2)
	_factor = speed / v0.distance_to(v2)
	set_physics_process(1)

func _physics_process(delta: float) -> void:
	_acc += delta * _factor

	if _acc > 1:
		finish()
		return
	
	curve.upd(context.get_apply_point())
	
	var next := curve.sample(_acc)
	rotation = (next - global_position).angle()
	global_position = next
	queue_redraw()

func on_target_died(_f:Alive) -> void:
	finish()

func finish() -> void:
	set_physics_process(0)
	target_reached.emit(context)
	queue_free()
