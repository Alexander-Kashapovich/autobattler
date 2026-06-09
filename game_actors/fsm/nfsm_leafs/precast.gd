@tool
extends CommonLock
class_name PreCast

func get_id() -> ID:
	return ID.PRECAST

func enter_update() -> void:
	assert(bb.choosen_spell)
	assert(bb.choosen_spell_target)
	ctx.sound(SoundComp.S.SWING)
	
	if not bb.choosen_spell.is_blind:
		bb.choosen_spell_target.died.connect(on_target_died,CONNECT_DEFERRED)
		
	#ctx.text("Charged " + bb.choosen_spell.nom + " to " + bb.choosen_spell_target.name)

func timeout() -> void:
	assert(bb.choosen_spell)
	assert(bb.choosen_spell_target)
	request_transition.emit(ID.CAST)

func on_target_died(who:Alive) -> void:
	if ctx.target():
		request_transition.emit(ID.CHASE)
	else:
		request_transition.emit(ID.TRAVEL)
		
