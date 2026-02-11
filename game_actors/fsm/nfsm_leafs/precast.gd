extends CommonLock
class_name PreCast

func enter_update() -> void:
	assert(bb.choosen_spell)
	assert(bb.choosen_spell_target)
	ctx.sound(SoundComp.S.SWING)
	ctx.text("Charged " + bb.choosen_spell.nom + " to " + bb.choosen_spell_target.name)

func timeout() -> void:
	assert(bb.choosen_spell)
	assert(bb.choosen_spell_target)
	request_transition.emit(ID.CAST)
