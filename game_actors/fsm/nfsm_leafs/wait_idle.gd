@tool
extends CommonLock
class_name WaitIdle

func get_id() -> ID:
	return ID.IDLE

func timeout() -> void:
	request_transition.emit(ID.MOVE)
