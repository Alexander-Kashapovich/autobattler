extends SpawnerAssembler
class_name StaticSpawnerAssembler

####!!!!!!!!!!!!!!!
func execute(actor:Alive,_data:SpawnerData) -> void:
	actor.visual.set_tex(_data.texture)
