extends Node2D
class_name Team
##World component. Manages team.

##id
@export var color:Color
@export var faction_data:FactionData

## where will set invasion position
@export var current_enemy:Team

var _counter:int = -1

var _units:Array[Alive]
var _buildings:Array[Alive]

var _home:Vector2
var _home_radius:float

signal team_members_changed

func register_unit(x:Alive) -> void:
	_units.append(x)
	x.died.connect(_on_unit_die)
	_counter += 1
	team_members_changed.emit()
	
func register_building(x:Alive) -> void:
	_buildings.append(x)
	x.died.connect(_on_building_died)
	_recalc_home_point()
	_counter += 1
	team_members_changed.emit()
	print("REG " + name + " " + str(_home))


func get_invasion_point() -> Vector2:
	return (current_enemy._home + 
	current_enemy._home_radius * Vector2.UP.rotated(TAU * randf()) * randf())

func get_home_point() -> Vector2:
	return _home + _home_radius * Vector2.UP.rotated(TAU * randf()) * randf()

func get_units_count() -> int:
	return _units.size()

func get_buildings_count() -> int:
	return _buildings.size()

func get_counter() -> int:
	return _counter

func _on_unit_die(x:Alive) -> void:
	_units.erase(x)
	team_members_changed.emit()

func _on_building_died(x:Alive) -> void:
	_buildings.erase(x)
	team_members_changed.emit()
	if not  _buildings.is_empty():
		_recalc_home_point()

func _recalc_home_point() -> void:
	var acc:Vector2 = Vector2.ZERO
	for build in _buildings:
		acc += build.global_position
	
	_home =  acc / _buildings.size()
	
	var _acc:float = 0
	for build in _buildings:
		_acc += build.global_position.distance_to(_home)
	
	_home_radius = _acc / _buildings.size() * 0.75
	queue_redraw()
	print(name + " " + str(_home))

func _draw() -> void:
	##home zone
	draw_circle(
		to_local(_home),
		_home_radius,
		Color(color,0.2)
		)
