@tool
extends CommonLock
class_name Dying

func get_id() -> ID:
	return ID.DYING

func enter_update() -> void:
	ctx.sound(SoundComp.S.DIE)

func timeout() -> void:
	ctx.unit.queue_free()
