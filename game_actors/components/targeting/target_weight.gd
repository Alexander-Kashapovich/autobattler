extends RefCounted
class_name TargetWeight

var pawn:Alive
var w:float

func _init(_e:Alive,_w:float) -> void:
	pawn = _e
	w = _w
