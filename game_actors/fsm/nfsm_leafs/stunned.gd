@tool
extends CommonLock
class_name Stunned

func get_id() -> ID:
	return ID.STUNNED

func timeout() -> void:
	request_transition.emit(ID.RETREAT)
