extends RefCounted
class_name UMLClassBoxPlacer

func place_as_grid(boxes:Dictionary[String,ClassBoxTool]) -> void:
	var x_line:float = 3000
	var x:float = 0
	var y:float = 0
	var level:Array[float] = [0]
	var tmp_boxes:Array[ClassBoxTool] = boxes.values().filter(func(b):return !b.locked)
	
	tmp_boxes.sort_custom(func(a,b):return a.size.y > b.size.y)

	for i in tmp_boxes.size():
		var box:ClassBoxTool = tmp_boxes[i]
		box.global_position = Vector2(x,y)
		
		level.append(box.size.y)
		x += box.size.x

		if x > x_line:
			x = 0
			y += level.max()
			level = [0]
	
	_redraw(boxes)

func place_by_force(boxes:Dictionary[String,ClassBoxTool]) -> void:
	for nom:String in boxes.keys():
		var off_x = hash(nom) % 4000
		var off_y = hash(nom + nom) % 4000
		boxes[nom].global_position = Vector2(off_x,off_y)
	
	for iter in 100:
		for box_a:ClassBoxTool in boxes.values():
			var force:Vector2
			
			for box_b:ClassBoxTool in boxes.values():
				if box_a == box_b: continue
				var vec:Vector2 = box_a.global_position - box_b.global_position
				var dir = vec.normalized()
				var dist = vec.length_squared()
				force += dir.normalized() * 4000 / (dist)
			
			var links:Array[ClassBoxTool] = box_a.deps_boxes.duplicate()
			links.append_array(box_a.derived_boxes)
			if box_a.parent_box: links.append(box_a.parent_box)
			
			for dep_box:ClassBoxTool in links:
				var vec = dep_box.global_position - box_a.global_position
				force += vec * 0.3
			
			box_a.global_position += force * 0.01
	
	_upd_from_box_size(boxes)
	_redraw(boxes)

func _upd_from_box_size(boxes:Dictionary[String,ClassBoxTool]) -> void:
	var center:Vector2
	for b in boxes.values():
		center += b.global_position
	center /= boxes.size()
	
	var sorted:Array[ClassBoxTool] = boxes.values()
	
	sorted.sort_custom(
		func(a, b): return (abs(
			a.global_position + a.size * 0.5 - center) < 
			abs(b.global_position + b.size * 0.5 - center)
			))
	
	var sz = sorted.size()
	for i in sz:
		var box_a:ClassBoxTool = sorted[i]
		for j in range(i + 1,sz):
			var box_b:ClassBoxTool = sorted[j]
			if box_a.get_rect().intersects(box_b.get_rect()):
				_resolve_collision(box_a, box_b)

func _resolve_collision(box_a:ClassBoxTool, box_b:ClassBoxTool) -> void:
	var overlap_x: float
	var overlap_y: float
	
	if box_b.global_position.x < box_a.global_position.x:
		overlap_x = (box_b.global_position.x + box_b.size.x) - box_a.global_position.x
	else:
		overlap_x = (box_a.global_position.x + box_a.size.x) - box_b.global_position.x
	
	if box_b.global_position.y < box_a.global_position.y:
		overlap_y = (box_b.global_position.y + box_b.size.y) - box_a.global_position.y
	else:
		overlap_y = (box_a.global_position.y + box_a.size.y) - box_b.global_position.y
	
	if abs(overlap_x) < abs(overlap_y):
		if box_b.global_position.x < box_a.global_position.x:
			box_b.global_position.x -= overlap_x
		else:
			box_b.global_position.x += overlap_x
	else:
		if box_b.global_position.y < box_a.global_position.y:
			box_b.global_position.y -= overlap_y
		else:
			box_b.global_position.y += overlap_y

func _redraw(boxes:Dictionary[String,ClassBoxTool]) -> void:
	for b in boxes.values():
		b.queue_redraw()
