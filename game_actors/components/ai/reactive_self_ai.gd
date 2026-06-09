extends Timer
class_name ReactiveSelfAI
## Trash

@export var unit:Caster
@export var spells:SpellsHandler

func _ready() -> void:
	assert(unit)
	timeout.connect(upd)
	start()

func upd() -> void:
	var candidates:Array[Spell] = spells.get_ready_spells()
	
	for c in candidates:
		assert(c.on_self)
	if candidates.is_empty():return
	#---selector---
	var choosen:Spell = candidates.pick_random()

	if choosen:
		choosen.execute(unit,unit)
		spells.on_executed(choosen)
