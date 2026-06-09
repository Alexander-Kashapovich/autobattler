@tool
extends Node2D
class_name UMLClassBoxDrawer

@onready var b:ClassBoxTool = get_parent()

var arrow_size:float = 32
var w:float = 3

func _draw() -> void:
	if b.parent_box:
		_draw_parent()
	if b.draw_depends:
		_draw_depends()

func _draw_parent() -> void:
	_draw_arrow(b.parent_box.global_position,b.parent_box.size,[Color.NAVY_BLUE,Color.AQUA])

func _draw_depends() -> void:
	for d:ClassBoxTool in b.deps_boxes:
		_draw_arrow(d.global_position,d.size,[Color.YELLOW,Color.ORANGE_RED])

func _draw_arrow(p:Vector2,s:Vector2,c:Array[Color]) -> void:
		var mod_s:Vector2
		var mod_t:Vector2
		
		if p.x + s.x < global_position.x:
			mod_s = b.size * Vector2(0,0.5)
			mod_t = s * Vector2(1,0.5)
		elif global_position.x + b.size.x < p.x:
			mod_s = b.size * Vector2(1,0.5)
			mod_t = s * Vector2(0,0.5)
		elif p.y + s.y < global_position.y:
			mod_s = b.size * Vector2(0.5,0)
			mod_t = s * Vector2(0.5,1)
		elif global_position.y + b.size.y < p.y:
			mod_s = b.size * Vector2(0.5,1)
			mod_t = s * Vector2(0.5,0)
		else:
			return


		var start = mod_s
		var end = (p + mod_t) * get_global_transform()
		var l1 = end + (start - end).normalized().rotated(PI * 0.15) * arrow_size
		var l2 = end + (start - end).normalized().rotated(-PI * 0.15) * arrow_size
		draw_polyline_colors([start,end],c,w)
		draw_line(end,l1,c[1],w + 1)
		draw_line(end,l2,c[1],w + 1)
