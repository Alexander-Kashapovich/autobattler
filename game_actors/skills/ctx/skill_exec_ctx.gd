extends RefCounted
class_name SkillExecutionContext
## Context. Caster may be dead when executing call
## Can long lives in BuffHandler.

## Can be null
var caster:Caster
var caster_stats:CasterStat
var _cast_point:Vector2

## Cant be null
var target:Alive
var target_stat:AliveStat
var _apply_point:Vector2
var __offset:Vector2

signal exp_gained(val:float)

##Apply point in global coord
func setup_manual(c_stat:CasterStat,cast_p:Vector2,t:Alive) -> void:
	caster_stats = c_stat
	_cast_point = cast_p
	
	target = t
	target_stat = t.stats
	_apply_point = target.global_position

## From spell.execute and AOE rebuild
func setup_from_unit(c:Caster,t:Alive) -> void:
	caster = c
	caster_stats = c.caster_stats
	_cast_point = c.get_cast_point()
	
	target = t
	target_stat = t.stats
	_apply_point = target.global_position
	__offset = t.get_apply_point(c) - t.global_position

##from effect
func add_exp(val:float) -> void:
	exp_gained.emit(val)

## Where skill was casted
func get_application_point() -> Vector2:
	return _apply_point

func get_apply_point() -> Vector2:
	return __offset + target.global_position

func get_cast_point() -> Vector2:
	return _cast_point
