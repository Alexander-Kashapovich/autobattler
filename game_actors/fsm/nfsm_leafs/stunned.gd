extends CommonLock
class_name Stunned

func timeout() -> void:
	request_transition.emit(ID.RETREAT)
