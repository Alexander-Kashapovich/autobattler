extends Node
class_name MoveComp

@export var visual: UnitVisual
@export var unit: Alive

var is_stopped:bool = 1
var velocity:Vector2

func move(_mov: Vector2) -> void:
	velocity = _mov
	visual.calc_dir(_mov)

func start() -> void:
	set_physics_process(1)
	is_stopped = 0

func stop() -> void:
	velocity *= 0
	set_physics_process(0)
	is_stopped = 1

func _physics_process(delta: float) -> void:
	unit.global_position += velocity * delta
