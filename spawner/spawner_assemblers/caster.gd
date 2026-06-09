extends SpawnerAssembler
class_name CasterSpawnerAssembler

func execute(actor:Alive,data:SpawnerData) -> void:
	actor = actor as Caster
	assert(actor)

	actor.caster_stats = CasterStat.new()
	
	var spells_handler:SpellsHandler = actor.get_node("SpellsHandler")
	
	for spell in data.spells:
		var is_immediatly_rechraged:bool =  data.spells[spell]
		var init_cd:float = 0.0 if is_immediatly_rechraged else spell.cd
		spells_handler._spells[spell] = init_cd
		
		if spell._base_value == -INF:
			spell.base_evaluate()
