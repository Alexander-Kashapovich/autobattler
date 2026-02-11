@abstract
@tool
extends Resource
class_name State

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

static var dict = {
	(Idle as Script).get_global_name() : ID.IDLE,
	(WaitIdle as Script).get_global_name() : ID.IDLE,
	
	(Move as Script).get_global_name() : ID.MOVE,
	
	(Chase as Script).get_global_name() : ID.CHASE,
	(RangedChase as Script).get_global_name() : ID.CHASE,
	
	(Hit as Script).get_global_name() : ID.ATTACK,
	(Swing as Script).get_global_name() : ID.SWING,

	(Cast as Script).get_global_name() : ID.CAST,
	(PreCast as Script).get_global_name() : ID.PRECAST,
	
	(Dying as Script).get_global_name() : ID.DYING,
	
	(Stunned as Script).get_global_name() : ID.STUNNED,
	
	(Rest as Script).get_global_name() : ID.REST,
	(Offensive as Script).get_global_name() : ID.OFFENSIVE,
	(Retreat as Script).get_global_name() : ID.RETREAT,
	(Travel as Script).get_global_name() : ID.TRAVEL,
	(AliveState as Script).get_global_name() : ID.ALIVE,
	
	(Root as Script).get_global_name(): ID.ROOT
	
}

var ctx:StateContext
var bb:BlackBoard

@warning_ignore("unused_signal")
signal request_transition(new_state:int)

func fsm_init(c:StateContext,_bb:BlackBoard) -> void:
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

func logg(s:String) -> void:
	bb.logg(nom() + " == " + s)
