extends ActorGUI
class_name UnitGUI

@export var unit:Unit

@export var attack:AttackComp
@export var nv:NavComp
@export var vis:VisionComp

@export var rank_drawer:RankDrawer
@export var path_drawer:PathDrawer
@export var hp_bar:PropertyBar

@export var transparent:float = 0.3
##!!!!!!
var chase:Chase

var team_color:Color

func on() -> void:
	visible = 1
	queue_redraw()

func off() -> void:
	visible = 0

func setup() -> void:
	hp_bar.setup(unit.hp)
	
	nv.new_path.connect(queue_redraw)
	unit.rank.level_upped.connect(rank_drawer.upd)
	
	$Name.text = unit.nom.get_nom()
	unit.mouse_entered.connect(on)
	unit.mouse_exited.connect(off)
	
	chase = unit.fsm.find_state(State.ID.CHASE)
	
	team_color = unit.team.color
	
	unit.fsm.bb.new_state.connect(func(x):$DBG_State.text = x)
	##!!!!!!!
	#off()

func _draw() -> void:
	#_draw_vision()
	_draw_attack()
	path_drawer.upd(nv._res.path)
	
func _draw_vision() -> void:
	draw_circle(Vector2.ZERO,vis.get_range(),Color.WHEAT * Color(1,1,1,transparent),0,1)
	
func _draw_attack() -> void:
	var r := attack.cast_range
	draw_circle(Vector2.ZERO,r,team_color,0,1)
	
	if chase is RangedChase:
		var rr = chase.backstep_factor * r
		draw_circle(Vector2.ZERO,rr,team_color * Color(1,1,1,transparent),0,1)
		for i in 36:
			var angle = float(i)/36 * TAU
			var base = Vector2.UP .rotated(angle)
			var start = base * rr
			var end = base * r
			draw_line(start,end,team_color)

	var cp = to_local(unit.get_cast_point())
	var offset:float = 10
	var n = cp + Vector2.UP * offset
	var s = cp + Vector2.DOWN * offset
	var w = cp + Vector2.LEFT * offset
	var e = cp + Vector2.RIGHT * offset
	draw_line(n,s,Color.WHEAT)
	draw_line(w,e,Color.WHEAT)
