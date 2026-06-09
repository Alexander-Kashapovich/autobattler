extends Node
class_name FSM
#root

var root:State

var bb:BlackBoard = BlackBoard.new()

signal new_state(s:String)

func _ready() -> void:
	set_physics_process(0)

func start(ctx:UnitContext) -> void:
	bb.ctx = ctx
	root.fsm_init(ctx,bb)
	root.control_flow_enter()
	set_physics_process(1)

func _physics_process(delta: float) -> void:
	#setted in root
	bb.cur_state.exec(delta)

#find first instance of ID
func find_state(val:State.ID) -> State:
	return _find_state_rec(root,val)

func _find_state_rec(from:NFSMNode,val:State.ID) -> State:
	for st_key in from.states:
		var st:State = from.states[st_key]
		if st_key == val:
			return st
		if st is NFSMNode:
			var ast = _find_state_rec(st,val)
			if ast != null:
				return ast
	return null
