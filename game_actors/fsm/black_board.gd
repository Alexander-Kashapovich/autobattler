extends RefCounted
class_name BlackBoard

var current_target_position:Vector2

var choosen_spell:Spell
var choosen_spell_target:Alived

var l:String

func logg(s:String) -> void:
	l += str(Engine.get_process_frames()) +"::  "+ s + "\n"

var cur_state:String
signal new_state(cur_state:String)
func set_cur(s:String) -> void:
	cur_state = s
	new_state.emit(s)
