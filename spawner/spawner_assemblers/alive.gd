extends SpawnerAssembler
class_name AliveSpawnerAssembler

static var id:int = 0
func execute(actor:Alive,data:SpawnerData) -> void:
	actor.hp = VitalProperty.new()
	assert(data.max_hp > 0)
	actor.hp.max_val = data.max_hp
	actor.hp.fill()
	actor.hp.out.connect(actor.die)
	
	actor.stats = AliveStat.new()
	
	actor.sound.sound_data = data.sound_data
	
	actor.visual.Spawner_setup_randomly()
	actor.meta = data.meta
	
