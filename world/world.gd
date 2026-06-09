extends Node2D
class_name BattleMng

@export var teams:Array[Team]
@export var size:Vector2 = Vector2(2929 * 2,1899 * 2)

@export var fx:FXMng
@export var nv:NavMng

var is_world_ready:bool = 0
signal world_ready

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _ready() -> void:
	FXMng.setup(self)

	await NavigationServer2D.map_changed
	await NavigationServer2D.map_changed
	
	is_world_ready = 1
	world_ready.emit()
	
func rebake_nv() -> void:
	nv.rebake()
