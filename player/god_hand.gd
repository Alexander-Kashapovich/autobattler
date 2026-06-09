extends Node2D
class_name GodHand
## Player

@export var skills:Array[Skill]
var cur_skill:Skill
var skill_id:int = 0

var target:Alive

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				handle_lbm()
		else:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				skill_id += 1
				if skill_id == skills.size():
					skill_id = 0
					set_spell_name()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				skill_id -= 1
				if skill_id == 0:
					skill_id = skills.size()
					set_spell_name()

func _process(delta: float) -> void:
	global_position = get_global_mouse_position()

func handle_lbm() -> void:
	var skill:Skill = skills[skill_id]
	skill.execute(SkillExecutionContext.new())
	
func set_spell_name() -> void:
	$Label.text = "%s: %s" % [
		skill_id,
		skills[skill_id].resource_name]
