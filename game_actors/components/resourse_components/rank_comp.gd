extends Resource
class_name RankComp

var _exp:float = 0
var exp_to_next:float = 12 * pow(_grow,1)

var _grow:float = 1.4
var rank:int = 0
var limit:int = 16

signal level_upped(val:int)

func add_exp(val:float) -> void:
	_exp += val
	while _exp > exp_to_next:
		level_up()

func level_up() -> void:
	if rank + 1 > limit:
		exp_to_next = INF
		return
	rank += 1
	exp_to_next = 12 * pow(_grow, rank + 1)
	level_upped.emit(rank)
