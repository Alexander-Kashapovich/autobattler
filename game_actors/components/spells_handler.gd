extends Timer
class_name SpellsHandler
## Storage of [Spells]'s. Handle cooldownds.
## Frined of [GodHand]
## Friend of [SpawnerExecutor]

## keys >= 0.0
var _spells:Dictionary[Spell,float]

signal changed

func _ready() -> void:
	timeout.connect(_upd)
	start()

func get_spells_count() -> int:
	return _spells.size()

func on_executed(spell:Spell) -> void:
	assert (_spells.has(spell))
	_spells[spell] = spell.cd
	if is_stopped():start()
	changed.emit()
	
func _upd() -> void:
	var is_all_ready:bool = 1
	for s in _spells:
		_spells[s] -= wait_time
		if _spells[s] <= 0:
			_spells[s] = 0
		#At least an one is in cooldown
		else:
			is_all_ready = 0
	
	if is_all_ready:stop()
	
	changed.emit()

func get_ready_spells() -> Array[Spell]:
	var ready_spells:Array[Spell]

	for spell in _spells:
		if _spells[spell] == 0.0:
			ready_spells.append(spell)
	
	return ready_spells

func GodHand_get_spell(i:int) -> Spell:
	return _spells.keys()[i]

func GodHand_is_spell_ready(i:int) -> bool:
	return _spells[_spells.keys()[i]] == 0
