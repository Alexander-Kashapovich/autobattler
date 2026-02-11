@tool
extends Node2D

@export var visual:Node2D
@export_dir var assets_dir:String
@export var unit_nom:String

@export_tool_button("go") var __asg = go
func go() -> void:
	var root = Root.new()
	
	root.default_state = State.ID.OFFENSIVE
	
	#---leafs visual
	var idle_t:StateVisualData = lsvd("idle")
	var move_t:StateVisualData = lsvd("move")
	var chase_t:StateVisualData = lsvd("chase")
	var hit_t:StateVisualData = lsvd("hit")
	var swing_t:StateVisualData = lsvd("swing")
	var cast_t:StateVisualData = lsvd("cast")
	var precast_t:StateVisualData = lsvd("precast")
	var stunned_t:StateVisualData = lsvd("stunned")
	var dying_t:StateVisualData = lsvd_dying()

	#--leafs states
	var idle:State = Idle.new()
	var move:State = Move.new()
	
	var chase:State = Chase.new()
	
	var hit:State = Hit.new()
	var swing:State = Swing.new()
	
	var cast:State = Cast.new()
	var pre_cast:State = PreCast.new()
	
	var wait_idle:WaitIdle = WaitIdle.new()
	var dying:State = Dying.new()
	
	var stunned:Stunned = Stunned.new()
	
	#--set visual data
	idle.visual_data = idle_t
	wait_idle.visual_data = idle_t

	move.visual_data = move_t
	
	chase.visual_data = chase_t
	
	hit.visual_data = hit_t
	swing.visual_data = swing_t
	
	cast.visual_data = hit_t
	pre_cast.visual_data = swing_t
	
	dying.visual_data = dying_t
	
	stunned.visual_data = stunned_t
	#--nodes
	var alive:NFSMNode = AliveState.new()
	alive.default_state = State.ID.OFFENSIVE
	
	var offensive:NFSMNode = Offensive.new()
	offensive.default_state = State.ID.TRAVEL
	
	var travel:NFSMNode = Travel.new()
	travel.default_state = State.ID.MOVE
	
	var retreat:NFSMNode = Retreat.new()
	retreat.default_state = State.ID.MOVE
	
	var rest:NFSMNode = Rest.new()
	rest.default_state = State.ID.IDLE
	
	root.default_state = State.ID.ALIVE

	root.__build_states = st([dying,alive])
	alive.__build_states = st([rest,retreat,offensive,stunned])
	rest.__build_states = st([move,wait_idle])
	retreat.__build_states = st([move])
	offensive.__build_states = st([travel,chase,pre_cast,cast,swing,hit])
	travel.__build_states = st([idle,move])
	
	visual.root = root
	visual.go()

func st(a:Array) -> Array[State]:
	var s:Array[State]
	for i in a:
		s.append(i)
	return s

func lsvd(nom:String) -> StateVisualData:
	return load(assets_dir.path_join(unit_nom).path_join(nom + ".tres"))

func lsvd_dying() -> StateVisualData:
	return load("res://assets/units/misc/die.tres")
	
