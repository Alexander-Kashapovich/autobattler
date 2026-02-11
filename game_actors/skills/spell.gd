@icon("res://editor_assets/spell_icon.svg")
@tool
extends Resource
class_name Spell
##personal instance for caster

@export var nom:String = "FORGET SPELL NOM"
@export var sound:SoundData

@export var cd:float = 1.0
@export var cast_range:float

@export var _skill:Skill

@export var meta:PackedStringArray

@export var bonus_value:float = 0
@export var _base_value:float = -INF

@export var evaluators:Array[TestCastEvaluator]
@export var selectors:Array[TestCastSelector]

func base_evaluate() -> float:
	_base_value = _skill.base_evaluate()
	_base_value += bonus_value
	return _base_value

func get_base_value() -> float:
	assert(_base_value != -INF)
	return _base_value

func evaluate(t:Alived) -> float:
	var res:float = get_base_value()
	for evaluator in evaluators:
		res += evaluator.exec(t)
	return res

func select(t:Alived) -> bool:
	for selector in selectors:
		if !selector.exec(t):
			return false
	return true
	
func execute(c:Alived,t:Alived) -> void:
	if sound: c.sound.play_manual(sound)
	
	_skill.execute(SkillExecutionContext.new(c,t))
	
func range_sq() -> float: 
	return cast_range * cast_range
