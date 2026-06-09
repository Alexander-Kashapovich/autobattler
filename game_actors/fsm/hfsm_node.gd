@abstract
@warning_ignore("missing_tool")
extends State
class_name NFSMNode

@export var default_state:ID

@export var states:Dictionary[ID,State]
var _state:State

func fsm_init(c:UnitContext,_bb:BlackBoard) -> void:
	super.fsm_init(c,_bb)
	
	for st in states.values():
		st.fsm_init(c,_bb)

func control_flow_enter() -> void:
	super.control_flow_enter()
	_state = states[default_state]
	_state.control_flow_enter()
	_state.request_transition.connect(_transition_to)
	logg("%s request connected" % _state.nom())

func _transition_to(new_state_id:int) -> void:
	var new_state:State = states[new_state_id]
	
	assert(_state.request_transition.is_connected(_transition_to))
	_state.request_transition.disconnect(_transition_to)
	logg("%s request disconnected" % _state.nom())
	_state.control_flow_exit()
	
	bb.logg("%s -> %s" % [_state.nom(),new_state.nom()])
	
	_state = new_state
	_state.request_transition.connect(_transition_to)
	logg("%s request connected" % _state.nom())
	_state.control_flow_enter()
	
func control_flow_exit() -> void:
	assert(_state.request_transition.is_connected(_transition_to))
	_state.request_transition.disconnect(_transition_to)
	logg("%s request disconnected" % _state.nom())
	_state.control_flow_exit()
	super.control_flow_exit()
