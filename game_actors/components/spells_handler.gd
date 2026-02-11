extends Timer
class_name SpellsHandler

@export var unit:Caster

var _spells:Dictionary[Spell,float]

func _ready() -> void:
	timeout.connect(update)
	start()

func execute_cast(spell:Spell,target:Alived) -> void:
	spell.execute(unit,target)
	_spells[spell] = spell.cd
	if is_stopped():start()
	
func execute_self_cast(spell:Spell) -> void:
	spell.execute(unit,unit)
	_spells[spell] = spell.cd
	if is_stopped():start()

func update() -> void:
	var all_ready:bool = 1
	for s in _spells:
		_spells[s] -= wait_time
		if _spells[s] <= 0:
			_spells[s] = 0
		else:
			all_ready = 0
	
	if all_ready:
		stop()

func get_spells() -> Array[Spell]:
	var ready_spells:Array[Spell]

	for spell in _spells:
		if _spells[spell] == 0.0:
			ready_spells.append(spell)
	
	return ready_spells
