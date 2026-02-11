extends Caster
class_name Unit

var rank:RankComp
@export var fsm:FSM
@export var blood_fx:UnitBlood
@export var fraction_shadow:ColorRect
signal stunned

func set_fraction(i:int) -> void:
	fraction = i
	fraction_shadow.color = Spawner.frac_colors[i]

func apply_damage(val:float) -> void:
	hp.force_decrease(val)
	blood_fx.set_blood(hp.percentage())
	rank.add_exp(val * 0.5)
	sound.exec(SoundComp.S.HURT)

func add_exp(val:float) -> void:
	rank.add_exp(val)

func level_up(i:int) -> void:
	stats.level_up(i)
	caster_stats.level_up(i)

	if name.find("[R") != -1:
		name = name.substr(0, name.find("[R")).strip_edges()

	name = "%s [R%s]" % [name, rank.rank]
	
func on_died() -> void:
	fraction_shadow.visible = 0
