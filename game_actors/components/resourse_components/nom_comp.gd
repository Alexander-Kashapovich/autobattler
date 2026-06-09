extends Resource
class_name NomComp

var nom:String
var prefix:String
var id:int
var type:String

func get_nom() -> String:
	return "{%s} %s %s%s" %[prefix, type, nom,id]
