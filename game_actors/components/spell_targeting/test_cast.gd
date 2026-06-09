extends RefCounted
class_name TestCast

var spell:Spell
var target:Alive
var caster:Caster

var value:float = 0

func _init(s:Spell,t:Alive,c:Caster) -> void:
	spell = s
	target = t
	caster = c
