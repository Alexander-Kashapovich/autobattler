extends Timer
class_name ReactiveTargetCasterAI

@export var unit:Caster

@export var targeter:Targeter
@export var spells:SpellsHandler

func _ready() -> void:
	timeout.connect(upd)
	start()

func range_sq() -> float:
	return unit.get_cast_point().distance_squared_to(targeter.get_target().get_apply_point(self))

func upd() -> void:
	var target:Alived = targeter.get_target()
	
	var candidates:Array[Spell] = spells.handle_spells(wait_time)
	
	if candidates.is_empty():return
	#---selector---
	var choosen:Spell = candidates.pick_random()

	spells.execute_cast(choosen,target)
	
