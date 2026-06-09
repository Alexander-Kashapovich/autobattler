@icon("res://assets/editor_assets/spell_icon.svg")
@tool
extends Resource
class_name Spell
##Personal instance for Unit.
## Only Unit may use Spell
## Stateless

##For DBG
@export var nom:String = "FORGET SPELL NOM"

## Use in execute
@export var sound:SoundData

## Const
@export var cd:float = 1.0
@export var cast_range:float = 50.0

@export var _skill:Skill

## Continue precast when target die or not
@export var is_blind:bool = 0

@export_group("Evaluating")
@export var on_ally:bool = 0
@export var on_self:bool = 0

@export var bonus_value:float = 0
var _base_value:float = -INF

@export var evaluators:Array[TestCastEvaluator]
@export var selectors:Array[TestCastSelector]

#Once. In spawner
func base_evaluate() -> float:
	_base_value = _skill.base_evaluate()
	_base_value += bonus_value
	return _base_value

func get_value() -> float:
	assert(_base_value != -INF)
	return _base_value

## From brain evaluator
func evaluate(ctx:TestCast) -> float:
	var res:float = get_value()
	for evaluator in evaluators:
		res += evaluator.exec(ctx)
	return res

## From brain selector
func select(ctx:TestCast) -> bool:
	for selector in selectors:
		if !selector.exec(ctx):
			return false
	return true

## From brain.
func execute(c:Alive,t:Alive) -> void:
	if sound: c.sound.play_manual(sound)
	
	var ctx = SkillExecutionContext.new()
	ctx.setup_from_unit(c,t)
	if c is Unit:ctx.exp_gained.connect(c.add_exp,CONNECT_ONE_SHOT)
	
	_skill.execute(ctx)
	
func range_sq() -> float: 
	return cast_range * cast_range
