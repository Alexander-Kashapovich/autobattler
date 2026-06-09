extends NomComp
class_name UnitNomComp

var rank:RankComp

func get_nom() -> String:
	return "{%s} %s %s%s [R:%s]" % [prefix, type, nom,id,rank.level]
