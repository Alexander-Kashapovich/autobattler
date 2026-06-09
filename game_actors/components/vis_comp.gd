extends Area2D
class_name VisionComp

signal ally_enter(who:Alive)
signal ally_exit(who:Alive)
signal enemy_enter(who:Alive)
signal enemy_exit(who:Alive)

@export var team:Team

func _ready() -> void:
	area_entered.connect(enter)
	area_exited.connect(exit)

func set_range(val:float) -> void:
	var shape = CircleShape2D.new()
	shape.radius = val
	get_child(0).shape = shape
	
func get_range() -> float:
	return get_child(0).shape.radius

func enter(u:Alive) -> void:
	if u.team != team:
		enemy_enter.emit(u)
	else:
		ally_enter.emit(u)

func exit(u:Alive) -> void:
	if u.team != team:
		enemy_exit.emit(u)
	else:
		ally_exit.emit(u)
