extends Area2D
class_name Alive
## May be target

@export var buff_handler:BuffHandler
@export var sound:SoundComp

@export var visual:VisualComp

var hp:VitalProperty
var stats:AliveStat

var team:Team

var meta:PackedStringArray
var nom:NomComp

var alive:bool = 1

signal team_setted(val:Team)
signal damaged(val:float)
signal died(who:Alive)

#hard calculation
func get_apply_point(v:Node) -> Vector2:
	var sz:Vector2 = visual.get_area()
	var h:int = hash(v)
	var x:float = fposmod(h,sz.x)
	var y:float = fposmod(h + hash(self),sz.y)
	return visual.global_transform * (Vector2(x,y) + visual.sp.offset)

func set_team(t:Team) -> void:
	team = t
	team_setted.emit(t)

##for multi buffs
func append_buff(buff:BuffSkill,c:SkillExecutionContext) -> void:
	buff_handler.append(buff,c)

func apply_damage(val:float) -> void:
	hp.force_decrease(val)
	sound.exec(SoundComp.S.HURT)
	damaged.emit(val)
	FXMng.add_text(global_position,"-%.0f" % val)

func die() -> void:
	if alive:
		alive = 0
		collision_layer = 0
		buff_handler.off()
		died.emit(self)
		on_died()

func on_died() -> void:
	pass

func update_name() -> void:
	name = nom.get_nom()
