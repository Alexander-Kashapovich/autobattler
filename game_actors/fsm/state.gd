@abstract
@tool
extends Resource
class_name State
## Base state.

enum ID
{
#leaf
	IDLE,
	MOVE,
	
	CHASE,
	
	SWING,
	ATTACK,
	
	PRECAST,
	CAST,
	
	STUNNED,
	
#node
	ALIVE,
	DYING,
	
	OFFENSIVE,
	RETREAT,
	REST,
	
	TRAVEL,
#root
	ROOT
}

##Keep modules and handle its
var ctx:UnitContext
##Current around state
var bb:BlackBoard

signal request_transition(new_state:int)

func fsm_init(c:UnitContext,_bb:BlackBoard) -> void:
	ctx = c
	bb = _bb
	init()

func init() -> void:pass

func control_flow_enter() -> void:
	logg("Enter")
	enter_update()

func enter_update() -> void: pass

func control_flow_exit() -> void:
	exit_update()
	logg("Exit")

func exit_update() -> void:pass

func exec(delta:float) -> void: pass

func nom() -> String:
	return get_script().get_global_name()

@abstract
func get_id() -> ID

func logg(s:String) -> void:
	bb.logg(nom() + "::" + s)
