@tool
extends NavigationObstacle2D
class_name NavPolygonSegment

@export var outline:PackedVector2Array

func get_polygon() -> PackedVector2Array:
	var pols:Array[PackedVector2Array]
	var res:PackedVector2Array = outline.duplicate()
	
	for i in res.size():
		res[i] = global_transform * res[i]

	for ch in get_children():
		ch.rebake()
		pols.append(ch.get_polygon())
	
	for i in pols.size():
		var s = Geometry2D.merge_polygons(res,pols[i])
		if not s.is_empty():
			res = s[0]

	return res

@warning_ignore("unused_private_class_variable")
@export_tool_button("bake") var __asdasf = rebake
func rebake() -> void:
	outline = vertices
	queue_redraw()

func _draw() -> void:
	draw_polyline(outline,Color.YELLOW,5)
	draw_polygon(outline,[Color(Color.GREEN,0.3)])
	draw_line(outline[0], outline[outline.size() - 1],Color.YELLOW,5)
