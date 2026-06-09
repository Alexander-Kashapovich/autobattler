@tool
extends SpawnerData
class_name UnitSpawnerData
## Unit is Unit.

@export_category("Unit data")
@export var fsm_root:Root
@export var attack:Skill
@export var attack_range:float
@export var max_rang:int = 18

func _property_can_revert(property: StringName) -> bool:
	match property:
		"is_building":return 1
		"spawner_assemblers":return 1
	return 0

func _property_get_revert(property: StringName) -> Variant:
	match property:
		"is_building": return false
		"spawner_assemblers":
			print(_def_unit_SpawnerAssemblers_idx())
			return _def_unit_SpawnerAssemblers_idx()
	return null

func _def_unit_SpawnerAssemblers_idx() -> Array[Spawner.SpawnerAssemblerID]:
	return [
		Spawner.SpawnerAssemblerID.ALIVE,
		Spawner.SpawnerAssemblerID.CASTER,
		Spawner.SpawnerAssemblerID.TARGETING,
		Spawner.SpawnerAssemblerID.ALLY_TARGETING,
		Spawner.SpawnerAssemblerID.UNIT,
		Spawner.SpawnerAssemblerID.GUI,
	]
