extends RefCounted
class_name UnitContext
## Keeped in fsm. Storage of ref of modules.

var unit:Unit
var _team:Team

var mover:MoveComp
var nv:NavComp

var spells:SpellsHandler

var targeter:Targeter
var attack_comp:AttackComp

var visual:VisualComp

var ally_targeter:Targeter

func attack() -> void:attack_comp.attack(target())
func move(m:Vector2) -> void:mover.move(m)
func target() -> Alive:return targeter.get_target()
func ally() -> Alive:return ally_targeter.get_target()
func sound(s:SoundComp.S) -> void:unit.sound.exec(s)
func text(s:String) ->void:FXMng.add_text(unit.global_position,s)
func get_invasion() -> Vector2:return _team.get_invasion_point()
func get_home() -> Vector2: return _team.get_home_point()
