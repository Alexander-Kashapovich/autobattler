extends SpawnerAssembler
class_name UnitSpawnerAssembler

func execute(actor:Alive,data:SpawnerData) -> void:
	actor = actor as Unit
	data = data as UnitSpawnerData

	assert(actor)
	assert(data.vision >= data.attack_range)
	
	actor.rank.limit = data.max_rang
	
	var attack:AttackComp = actor.get_node("AttackComp")
	attack.base_skill = data.attack.duplicate_deep(Resource.DEEP_DUPLICATE_ALL)
	attack.cast_range = data.attack_range
	
	#---setup_mover---
	var mover:MoveComp = actor.get_node("MoveComp")
	var nv:NavComp = actor.get_node("NavComp")
	nv.on()
	
	#---setup fsm context---
	var ctx:UnitContext = UnitContext.new()
	var spells_handler:SpellsHandler = actor.get_node("SpellsHandler")
	var targeter:Targeter = actor.get_node("EnemyTargeter")
	var ally_targeter:Targeter = actor.get_node("AllyTargeter")

	ctx.attack_comp = attack
	ctx.unit = actor
	ctx.mover = mover
	ctx.nv = nv
	ctx.spells = spells_handler
	ctx.targeter = targeter
	ctx._team = actor.team
	ctx.visual = actor.visual
	ctx.ally_targeter = ally_targeter

	actor.fsm.root = data.fsm_root.duplicate_deep()
	actor.fsm.start(ctx)
	assert(data.fsm_root.states[State.ID.ALIVE].states[State.ID.STUNNED].visual_data)
