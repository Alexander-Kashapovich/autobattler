extends Resource
class_name SpawnerData

@export_category("Util")
@export var nom:String = "UNIT TYPE NOM"
@export var is_building:bool = 0
@export var spawner_assemblers:Array[Spawner.SpawnerAssemblerID]
@export var meta:PackedStringArray

@export_category("Alive data")
@export var max_hp:float = 50
@export var sound_data:Dictionary[SoundComp.S,SoundData]

@export_category("Caster data")
@export var spells:Dictionary[Spell,bool]

@export var texture:StateVisualData = StateVisualData.new()

@export var vision:float = 200
