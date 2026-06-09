extends Caster
class_name Barrack

func _ready() -> void:
	died.connect(_on_died)

func _on_died(_who:Alive) -> void:
	queue_free()
	
