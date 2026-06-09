extends Resource
class_name Var

var type_color:String = "GOLDENROD"

@export var nom:String
@export var type:String

func _format_type(t:String) -> String:
	return "[color=%s]%s[/color]" % [type_color,t]
	
func bbcoded() -> String:
	return "%s:%s" %[
		nom,
		_format_type(type)
	]
