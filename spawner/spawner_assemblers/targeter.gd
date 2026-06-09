extends SpawnerAssembler
class_name TargeterSpawnerAssembler

func execute(actor:Alive,data:SpawnerData) -> void:
	var vis:VisionComp = actor.get_node("VisionComp")
	vis.set_range(data.vision)
	vis.team = actor.team

	var targeter:Targeter = actor.get_node("EnemyTargeter")
	targeter.setup(vis.enemy_enter,vis.enemy_exit)
