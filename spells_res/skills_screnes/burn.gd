extends EffectFxScene
class_name BurnEffectFX

@export var time:float
var _acc:float = 0
func _ready() -> void:
	set_process(0)

func start() -> void:
	$GPUParticles2D.finished.connect(queue_free)
	$GPUParticles2D.restart()
	set_process(1)

func _process(delta: float) -> void:
	_acc += delta
	if _acc > time:
		queue_free()
		
	$GPUParticles2D.amount_ratio = _acc/time
