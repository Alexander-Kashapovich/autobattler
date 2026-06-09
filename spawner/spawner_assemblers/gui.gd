extends SpawnerAssembler
class_name GUISpawnerAssembler

func execute(actor:Alive,_data:SpawnerData) -> void:
	actor.get_node("GUI").setup()
