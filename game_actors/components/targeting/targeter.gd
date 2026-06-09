extends Node
class_name Targeter
## collect targets from UnitVision. Setup un Spawner
## setup cuurent target
## evaluate targets to select target

@export var ctx:TargetEvaluationContext
##evaluators for base attack
@export var evaluators:Array[TargeterEvaluator]

var _target:Alive
var targets:Array[Alive]

signal target_setted
signal target_lost

signal logged(s:String)

func setup(enter:Signal,exit:Signal) -> void:
	enter.connect(on_target_enter)
	exit.connect(on_target_exit)

func set_target(t:Alive) -> void:
	if _target:
		_target.died.disconnect(on_target_died)
		
	_target = t
	_target.died.connect(on_target_died)

	assert(is_instance_valid(t))
	assert(not t.is_queued_for_deletion())

	target_setted.emit()
	logg("tareget set")

func get_target() -> Alive:
	assert(_target.alive if _target else 1)
	return _target

## can be call from MOVE -> RETREAT when target already is null
func set_null_target() -> void:
	if _target:
		_target.died.disconnect(on_target_died)
	_target = null
	target_lost.emit()

func on_target_died(_S) -> void:
	logg("tareget die")
	match targets.size():
		1:set_null_target()
		_:find_best_target()
	
func on_target_exit(u:Alive) -> void:
	targets.erase(u)

	if u == _target:
		find_best_target()

func on_target_enter(u:Alive) -> void:
	targets.append(u)
	if _target == null:
		set_target(u)

func find_best_target() -> void:
	var datas:Array[TargetWeight]
	
	for e in targets:
		if not e.alive:continue
		datas.append(TargetWeight.new(e,0))
	
	if datas.is_empty():
		set_null_target()
	else:
		for s in evaluators:
			s.evaluate(datas,ctx)
		
		set_target(_max(datas))

func _min(ds:Array[TargetWeight]) -> Alive:
	var min_val:float = INF
	var obj:Alive
	for d in ds:
		if d.w < min_val:
			min_val = d.w
			obj = d.e
	assert(obj)
	return obj

func _max(ds:Array[TargetWeight]) -> Alive:
	var max_val:float = -INF
	var obj:Alive
	for d:TargetWeight in ds:
		if d.w > max_val:
			max_val = d.w
			obj = d.pawn
	assert(obj)
	return obj

func logg(s:String) -> void:
	logged.emit(name + ": " + s)
	
