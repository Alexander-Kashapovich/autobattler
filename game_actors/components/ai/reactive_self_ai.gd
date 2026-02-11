extends Timer
class_name ReactiveSelfAI

@export var spells:SpellsHandler

func _ready() -> void:
	timeout.connect(upd)
	start()

func upd() -> void:
	var candidates:Array[Spell] = spells.get_spells()
	
	for c in candidates:
		assert((c.meta.has("on_self")))
	if candidates.is_empty():return
	#---selector---
	var choosen:Spell = candidates.pick_random()

	if choosen:
		spells.execute_self_cast(choosen)
