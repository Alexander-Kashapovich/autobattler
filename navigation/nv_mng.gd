@tool
extends Node
class_name NavMng

@export var plain:NavPlain

func _ready() -> void:
	await  (get_parent() as BattleMng).world_ready
	for ch in get_children():
		
		ch.rebake()
