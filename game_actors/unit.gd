extends Caster
class_name Unit

@export var fsm:FSM
@export var blood_fx:UnitBlood
@export var team_shadow:ColorRect

var rank:RankComp = RankComp.new()
signal stunned

func _ready() -> void:
	team_setted.connect(_on_team_setted)
	damaged.connect(_on_damaged)
	rank.level_upped.connect(_on_level_up)

func _on_team_setted(i:Team) -> void:
	team_shadow.color = team.color

func _on_damaged(val:float) -> void:
	blood_fx.set_blood(hp.percentage())
	rank.add_exp(val * 0.5)

func add_exp(val:float) -> void:
	rank.add_exp(val)

func _on_level_up(i:int) -> void:
	stats.level_up(i)
	caster_stats.level_up(i)
	update_name()

func on_died() -> void:
	team_shadow.visible = 0
	FXMng.add_blood(global_position)
