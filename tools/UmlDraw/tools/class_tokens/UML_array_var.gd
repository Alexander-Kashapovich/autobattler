extends Var
class_name ArrayVar

var nested:String
func bbcoded() -> String:
	return "%s : %s [%s]" % [
		nom,
		_format_type(type),
		_format_type(nested)
		]
