extends Var
class_name DictVar

var key:String
var val:String

func bbcoded() -> String:
	return "%s : %s [%s:%s]" % [
		nom,
		_format_type(type),
		_format_type(key),
		_format_type(val)
		]
