extends RefCounted
class_name TestCast

var spell:Spell
var target:Alived
var caster:Caster

var value:float = 0

func _init(s:Spell,t:Alived,c:Caster) -> void:
	spell = s
	target = t
	caster = c
