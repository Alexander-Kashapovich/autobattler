@tool
extends Node2D
class_name BuildCombatantRoot

@export var fsm_visualizer:Node2D
@export_dir var assets_dir:String
@export var unit_nom:String

@export_category("dbg")
@export var chase_is_move:bool = 0
@export var cast_is_hit:bool = 0
@export var stun_is_idle:bool = 0
@export var wait_is_idle:bool = 0

@export var ranger:bool = 0

@export_tool_button("go") var __asg = go
func go() -> void:
	var root = Root.new()
	
	root.default_state = State.ID.OFFENSIVE
	
	#---leafs fsm_visualizer
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
	
	var chase:State
	if ranger:
		chase = RangedChase.new()
	else:
		chase = Chase.new()
	
	var hit:State = Hit.new()
	var swing:State = Swing.new()
	
	var cast:State = Cast.new()
	var pre_cast:State = PreCast.new()
	
	var wait_idle:WaitIdle = WaitIdle.new()
	var dying:State = Dying.new()
	
	var stunned:Stunned = Stunned.new()
	
	#--set fsm_visualizer data
	idle.visual_data = idle_t
	if wait_is_idle:
		wait_idle.visual_data = idle_t
	else:
		wait_idle.visual_data = idle_t

	move.visual_data = move_t
	
	if chase_is_move:
		chase.visual_data = move_t
	else:
		chase.visual_data = chase_t
	
	hit.visual_data = hit_t
	swing.visual_data = swing_t
	
	if cast_is_hit:
		cast.visual_data = hit_t
		pre_cast.visual_data = swing_t
	else:
		cast.visual_data = cast_t
		pre_cast.visual_data = precast_t
		
	
	dying.visual_data = dying_t
	
	if stun_is_idle:
		stunned.visual_data = idle_t
	else:
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
	
	setup_states(root,[dying,alive])
	setup_states(alive,[rest,retreat,offensive,stunned])
	setup_states(rest,[move,wait_idle])
	setup_states(retreat,[move])
	setup_states(offensive,[travel,chase,pre_cast,cast,swing,hit])
	setup_states(travel,[idle,move])
	
	fsm_visualizer.root = root
	fsm_visualizer.go()

func st(a:Array) -> Array[State]:
	var s:Array[State]
	for i in a:
		s.append(i)
	return s

func setup_states(dest:NFSMNode,states:Array[State]) -> void:
	for s in states:
		dest.states[s.get_id()] = s

func lsvd(nom:String) -> StateVisualData:
	return load(assets_dir.path_join(unit_nom).path_join(nom + ".tres"))

func lsvd_dying() -> StateVisualData:
	return load("res://assets/units/misc/die.tres")
	
