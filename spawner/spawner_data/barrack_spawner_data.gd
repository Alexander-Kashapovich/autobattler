@tool
extends SpawnerData
class_name BarrackSpawnerData
## Barrack is caster who use spawn skill only.

##set reverting 
func _property_can_revert(property: StringName) -> bool:
	match property:
		"is_building":return 1
		"spawner_assemblers":return 1
	return 0

## set revert value
func _property_get_revert(property: StringName) -> Variant:
	match property:
		"is_building": return true
		"spawner_assemblers":
			print(_def_barrack_SpawnerAssembler_idx())
			return _def_barrack_SpawnerAssembler_idx()
	return null

func _def_barrack_SpawnerAssembler_idx() -> Array[Spawner.SpawnerAssemblerID]:
	return [
		Spawner.SpawnerAssemblerID.ALIVE,
		Spawner.SpawnerAssemblerID.CASTER,
		Spawner.SpawnerAssemblerID.STATIC,
		Spawner.SpawnerAssemblerID.GUI
	]
