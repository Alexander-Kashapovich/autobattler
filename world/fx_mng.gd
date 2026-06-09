extends Node2D
##WorldFXManager SingleTon

## TextFX Scene
var text:PackedScene = preload("res://world/VFX/text.tscn")
var blood:PackedScene = preload("res://world/VFX/die_blood.tscn")

var _mng:BattleMng
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_focus_next"):
		if visible: unshow_fx()
		else: show_fx()

func setup(m:BattleMng) -> void:
	_mng = m

func show_fx() -> void:
	visible = 1

func unshow_fx() -> void:
	visible = 0
	for ch in get_children():ch.queue_free()

func add_text(p:Vector2, s:String) -> void:
	if not visible: return
	
	var t:TextFX = text.instantiate()
	_mng.add_child(t)
	t.global_position = p
	t.start(s)

func add_blood(p:Vector2) -> void:
	if not visible: return
	
	var b = blood.instantiate()
	_mng.add_child(b)
	b.global_position = p
	b.start()

	
