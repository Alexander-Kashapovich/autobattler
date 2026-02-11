extends CommonLock
class_name WaitIdle

func timeout() -> void:
	request_transition.emit(ID.MOVE)
