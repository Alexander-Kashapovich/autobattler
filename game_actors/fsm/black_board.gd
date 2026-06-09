extends RefCounted
class_name BlackBoard
## AI Memory

var ctx:UnitContext
var current_target_position:Vector2

var choosen_spell:Spell
var choosen_spell_target:Alive

var cur_state:LeafState

var l:String
var cur_state_nom:String
signal new_state(cur_state:String)

func logg(s:String) -> void:
	l += str(Engine.get_process_frames()) +"::  "+ s + "\n"

func set_cur(s:LeafState) -> void:
	cur_state = s
	if s:
		cur_state_nom = s.nom()
		new_state.emit(cur_state_nom)

func is_have_a_good_spell() -> bool:
	var spells:Array[Spell] = ctx.spells.get_ready_spells()
	if spells.is_empty():return false
	
	#---setup and selecting---
	var ally_spells:Array[Spell]
	var enemy_spells:Array[Spell]
	var self_spells:Array[Spell]
	
	for s:Spell in spells:
		if s.on_self:
			self_spells.append(s)
		if s.on_ally:
			ally_spells.append(s)
		else:
			enemy_spells.append(s)
			
	var candidates:Array[TestCast]
	
	_select(candidates,enemy_spells,ctx.targeter.targets)
	_select(candidates,ally_spells,ctx.ally_targeter.targets)
	_select(candidates,self_spells,[ctx.unit])

	if candidates.is_empty():return false
	
	#--evaluating
	for tc in candidates:
		tc.value += tc.spell.evaluate(tc)
		assert(tc.target != null)
	
	#--final---
	var choosen:TestCast = _get_best(candidates)
	assert(choosen.target != null)
	
	choosen_spell = choosen.spell
	choosen_spell_target = choosen.target
	logg("chose %s to %s" %[choosen_spell,choosen_spell_target])
	return true

func _get_best(candidates:Array[TestCast]) -> TestCast:
	var best:float = -INF
	var best_o:TestCast = null
	for tc in candidates:
		if tc.value > best:
			best = tc.value
			best_o = tc
	return  best_o

func _select(
	candidates:Array[TestCast],
	spells:Array[Spell],
	targets:Array[Alive]) -> void:
	for spell in spells:
		for t in targets:
			if not t.alive: continue
			
			# cast range selecting
			var tp = t.get_apply_point(ctx.unit)
			var cp = ctx.unit.get_cast_point()
			var is_rng = tp.distance_squared_to(cp) < spell.range_sq()
			if not is_rng: continue
			
			# inner spell selecting
			var candidate:TestCast = TestCast.new(spell,t,ctx.unit)
			if not spell.select(candidate):continue
			
			candidates.append(candidate)
