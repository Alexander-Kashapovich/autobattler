extends LeafState
class_name Chase

##chasing_speed low of move speed(sprint)
@export var speed:float = 120

var _timer:Timer

func init() -> void:
	_timer = Timer.new()
	_timer.wait_time = 0.3
	
	_timer.timeout.connect(chasing_handle)
	_timer.name = nom() + " timer"
	ctx.pawn.add_child(_timer)
	

func enter_update() -> void:
	_timer.start()
	ctx.mover.start()
	logg("Mover Start")
	ctx.targeter.target_lost.connect(on_target_lost)
	logg("Target lost connect")

func exec(delta:float) -> void:
	ctx.nv.update_moving_target(ctx.target())
	
	ctx.mover.move(speed * ctx.nv.get_next_point_dir())

	var dist_sq:float = (
		ctx.pawn.get_cast_point() - ctx.target().global_position
		).length_squared()
	
	if is_have_a_good_spell():
		request_transition.emit(ID.PRECAST)
		return

	if (dist_sq < ctx.attack_comp.range_sq()):
			request_transition.emit(ID.SWING)

func exit_update() -> void:
	_timer.stop()
	ctx.mover.stop()
	logg("Mover Stop")
	ctx.targeter.target_lost.disconnect(on_target_lost)
	logg("Target lost disconnect")

func chasing_handle() -> void:
	ctx.targeter.find_best_target()

func on_target_lost() -> void:
	request_transition.emit(ID.TRAVEL)

func is_have_a_good_spell() -> bool:
	var spells:Array[Spell] = ctx.spells.get_spells()
	if spells.is_empty():return false
	
	#---setup and selecting---
	var ally_spells:Array[Spell]
	var enemy_spells:Array[Spell]
	
	split_meta(spells,"on_ally",ally_spells,enemy_spells)
	
	var candidates:Array[TestCast]

	for spell in enemy_spells:
		for t in ctx.targeter.targets:
			if not t.alive: continue
			if not spell.select(t):continue
			
			assert(t.fraction != ctx.pawn.fraction)
			var tp = t.get_apply_point(ctx.pawn)
			var cp = ctx.pawn.get_cast_point()
			var is_rng = tp.distance_squared_to(cp) < spell.range_sq()
			
			if not is_rng: continue
			
			candidates.append(TestCast.new(spell,t,ctx.pawn))
	
	for spell in ally_spells:
		for t in ctx.ally_targeter.targets + [ctx.pawn]:
			if not t.alive: continue
			if not spell.select(t):continue
			
			assert(t.fraction == ctx.pawn.fraction)
			var tp = t.get_apply_point(ctx.pawn)
			var cp = ctx.pawn.get_cast_point()
			var is_rng = tp.distance_squared_to(cp) < spell.range_sq()
			
			if not is_rng: continue
			
			candidates.append(TestCast.new(spell,t,ctx.pawn))
	
	if candidates.is_empty():return false
	
	#--evaluating
	for tc in candidates:
		tc.value += tc.spell.evaluate(tc.target)

	#--final---
	var choosen:TestCast = get_best(candidates)
	
	bb.choosen_spell = choosen.spell
	bb.choosen_spell_target = choosen.target
	return true



func split_meta(candidates:Array[Spell],meta:String,
	has:Array[Spell],
	no_has:Array[Spell]
	) -> void:

	for c in candidates:
		if c.meta.has(meta):
			has.append(c)
		else:
			no_has.append(c)

func get_best(candidates:Array[TestCast]) -> TestCast:
	var best:float = -INF
	var best_o:TestCast = null
	for tc in candidates:
		if tc.value > best:
			best = tc.value
			best_o = tc
	return  best_o
