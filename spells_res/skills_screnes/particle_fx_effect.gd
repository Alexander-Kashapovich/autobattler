extends EffectFxScene
class_name ParticleEffectFX

func start() -> void:
	assert($CPUParticles2D.one_shot)
	$CPUParticles2D.finished.connect(queue_free)
	$CPUParticles2D.restart()
	
