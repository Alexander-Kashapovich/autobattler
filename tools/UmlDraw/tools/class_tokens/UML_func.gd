extends Resource
class_name Func

var ret_color:String = "YELLOW_GREEN"

@export var nom:String
@export var ret:String
@export var args:Array[Var]

func _format_ret() -> String:
	return "[color=%s]%s[/color]" % [ret_color,ret]

func _format_args() -> String:
	var types:PackedStringArray
	for a in args:
		types.append(a._format_type(a.type))
	return ", ".join(types)
	
func bbcoded() -> String:
	if args.size() > 0:
		pass
	var res:String =  "%s %s(%s)" % [
		_format_ret(),
		nom,
		_format_args()
		]
	return res
