@tool
extends CommonLock
class_name Cast

func get_id() -> ID:
	return ID.CAST

func enter_update() -> void:
	if bb.choosen_spell_target and bb.choosen_spell_target.alive:
		#ctx.text("Charged " + bb.choosen_spell.nom + " to " + bb.choosen_spell_target.name)
		bb.choosen_spell.execute(ctx.unit,bb.choosen_spell_target)
		ctx.spells.on_executed(bb.choosen_spell)
	else:
		logg("Spell target died")
	bb.choosen_spell_target = null
	bb.choosen_spell = null
	
func timeout() -> void:
	if ctx.target():
		request_transition.emit(ID.CHASE)
	else:
		request_transition.emit(ID.TRAVEL)
