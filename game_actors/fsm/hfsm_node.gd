@abstract
@warning_ignore("missing_tool")
extends State
class_name NFSMNode

@export var default_state:ID

@export var __build_states:Array[State]

var states:Dictionary[ID,State]
var _state:State

func fsm_init(c:StateContext,_bb:BlackBoard) -> void:
	super.fsm_init(c,_bb)
	
	for st in __build_states:
		states[dict[st.nom()]] = st
		st.fsm_init(c,_bb)

	__build_states.clear()

func control_flow_enter() -> void:
	super.control_flow_enter()
	_state = states[default_state]
	_state.control_flow_enter()
	_state.request_transition.connect(_transition_to)

func _transition_to(new_state_id:int) -> void:
	var new_state:State = states[new_state_id]
	
	assert(_state.request_transition.is_connected(_transition_to))
	_state.request_transition.disconnect(_transition_to)
	_state.control_flow_exit()
	
	bb.logg(
		"%s -> %s" % [_state.nom(),new_state.nom()])
	
	_state = new_state
	_state.control_flow_enter()
	_state.request_transition.connect(_transition_to)
	
	if _state is LeafState:
		bb.set_cur(_state.nom())

func exec(delta:float) -> void:
	_state.exec(delta)
	exec_update(delta)

@warning_ignore("unused_parameter")
func exec_update(delta:float) -> void:
	pass

func control_flow_exit() -> void:
	assert(_state.request_transition.is_connected(_transition_to))
	_state.request_transition.disconnect(_transition_to)
	_state.control_flow_exit()
	exit_update()
	logg("Exit")
