extends CommonLock
class_name Hit

func enter_update() -> void:
	if ctx.target():
		ctx.attack()
		ctx.sound(SoundComp.S.ATTACK)

func timeout() -> void:
	if ctx.target():
		request_transition.emit(ID.CHASE)
	else:
		request_transition.emit(ID.TRAVEL)
