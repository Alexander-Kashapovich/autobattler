extends Timer
class_name ReactiveTargetCasterAI

@export var unit:Caster

@export var targeter:Targeter
@export var spells:SpellsHandler

func _ready() -> void:
	timeout.connect(upd)
	start()


func upd() -> void:
	var target:Alive = targeter.get_target()
	
	var candidates:Array[Spell] = spells.handle_spells(wait_time)
	
	if candidates.is_empty():return
	#---selector---
	var choosen:Spell = candidates.pick_random()

	spells.execute_cast(choosen,target)
	
