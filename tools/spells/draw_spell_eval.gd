@tool
extends Node2D

@export var spell: Spell
@export var font: Font = ThemeDB.fallback_font

const X_STEP := 250
const Y_STEP := 80
var size := Vector2(240, 80)

@export_tool_button("go") var __asf = go
func go():
	queue_redraw()

func _draw():
	spell.base_evaluate()
	_draw_spell(spell, Vector2(40, 40))

func _draw_spell(s: Spell, pos: Vector2) -> float:
	var v:float = s.get_value()
	_draw_box(pos, "Spell: %s \n %.2f" % [s.nom, v])
	return _draw_skill(s._skill, pos + Vector2(X_STEP, 0), pos)

func _draw_skill(sk: Skill, pos: Vector2, parent_pos: Vector2) -> float:
	var v := sk.get_value()
	_draw_box(pos, "Skill %s \n %.2f" % [nom(sk),v])
	draw_line(parent_pos + Vector2(160, 20), pos + Vector2(0, 20), Color.WHITE, 2)

	var y := pos.y
	for e in sk.target_effects:
		y = _draw_effect(e, Vector2(pos.x + X_STEP, y), pos)
	return y

func _draw_effect(e: Effect, pos: Vector2, parent_pos: Vector2) -> float:
	var v := e.get_value()
	_draw_box(pos, "%s\n%.2f" % [nom(e), v])
	draw_line(parent_pos + Vector2(160, 20), pos + Vector2(0, 20), Color.WHITE, 2)

	if e is BuffEffect:
		var buff:BuffSkill = e.buff
		var bpos := pos + Vector2(X_STEP, 0)
		var bv := buff.base_evaluate()
		_draw_box(bpos, "BuffSkill\n%.2f" % bv)
		draw_line(pos + Vector2(160, 20), bpos + Vector2(0, 20), Color.WHITE, 2)

		var y := bpos.y
		for ee in buff.target_effects:
			y = _draw_effect(ee, Vector2(bpos.x + X_STEP, y), bpos)
		return y + Y_STEP

	return pos.y + Y_STEP

func _draw_box(pos: Vector2, text: String):
	draw_rect(Rect2(pos, size), Color(0.1,0.1,0.1), true)
	draw_rect(Rect2(pos, size), Color.WHITE, false, 2)
	draw_multiline_string(font,pos + Vector2(8,24),text)

func nom(o:Object) -> String:
	return o.get_script().get_global_name()
