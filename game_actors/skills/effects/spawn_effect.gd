@tool
extends Effect
class_name SpawnEffect
## Affect caster

@export var data:SpawnerData
@export var scene:PackedScene
@export var count:int = 1

func _base_evaluate() -> float:
	return 1

func execute(c:SkillExecutionContext) -> void:
	for i in count:
		var spawner = Spawner.new()
		spawner.team = c.caster.team
		spawner.actor_scene = scene
		spawner.data = data
		
		spawner.global_position = c.get_cast_point()
		
		spawner.visible = 0
	
		c.caster.add_sibling(spawner)
		spawner.start_yield(0.1 + i* 0.5)
