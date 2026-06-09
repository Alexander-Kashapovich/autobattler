@tool
extends Spawner
class_name PreSpawner

@export var mng:BattleMng
func _ready() -> void:
	if not Engine.is_editor_hint():
		if not mng.is_world_ready:
			await mng.world_ready
		spawn()
