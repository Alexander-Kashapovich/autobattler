@tool
extends SkillScene
class_name LineProjectile
##Use shader

@export var speed:float = 500

var target_point:Vector2
var _timer:Timer

@onready var rect:ColorRect = $R
func _ready() -> void:
	set_process(0)
	_timer = Timer.new()
	_timer.timeout.connect(timeout)
	add_child(_timer)

func start(c:SkillExecutionContext) -> void:
	if not c.target.alive:
		queue_free()
		return
		
	c.target.died.connect(on_target_died,CONNECT_ONE_SHOT)
	context = c
	
	global_position = c.get_cast_point()
	target_point = c.get_apply_point()
	
	var vec:Vector2 = target_point - global_position
	var l:float = vec.length()
	var angle:float = vec.angle()
	var time:float = l/speed
	rect.rotation = angle
	rect.material.set_shader_parameter("speed",1/time)
	rect.size.x = l
	
	_timer.wait_time = time
	_timer.start()

func timeout() -> void:
	finish()

func on_target_died(_f:Alive) -> void:
	visible = 0
	queue_free()

func finish() -> void:
	target_reached.emit(context)
	queue_free()
