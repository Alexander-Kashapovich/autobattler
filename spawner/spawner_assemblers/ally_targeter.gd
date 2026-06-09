extends SpawnerAssembler
class_name AllyTargeterSpawnerAssembler

func execute(actor:Alive,data:SpawnerData) -> void:
	var vis:VisionComp = actor.get_node("VisionComp")
	vis.set_range(data.vision)
	vis.team = actor.team

	var ally_targeter:Targeter = actor.get_node("AllyTargeter")
	
	ally_targeter.setup(vis.ally_enter,vis.ally_exit)
