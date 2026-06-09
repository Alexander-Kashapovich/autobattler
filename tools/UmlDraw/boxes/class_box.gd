@tool
extends PanelContainer
class_name ClassBoxTool

@export var data:Class
@export var boxes:Dictionary[String,ClassBoxTool]

@export var locked:bool:
	set(val):
		locked = val
		var b = StyleBoxFlat.new()
		if locked:
			b.bg_color = Color("ff0000")
		else:
			b.bg_color = Color("727aa6")
		
		add_theme_stylebox_override("panel",b)

@export var draw_depends:bool = 1:
	set(val):
		draw_depends = val
		queue_redraw()

@export var parent_box:ClassBoxTool:
	set(val):
		if not val:return
		parent_box = val
		if not parent_box.item_rect_changed.is_connected(queue_redraw):
			parent_box.item_rect_changed.connect(queue_redraw)
		queue_redraw()

@export var deps_boxes:Array[ClassBoxTool]:
	set(val):
		deps_boxes = val
		for d in deps_boxes:
			if not d.item_rect_changed.is_connected(queue_redraw):
				d.item_rect_changed.connect(queue_redraw)
			queue_redraw()

@export var derived_boxes:Array[ClassBoxTool]

@export_tool_button("place_parent") var ______aaasdg = place_parent
func place_parent(is_forced:bool = 0) -> void:
	if parent_box:
		if parent_box.locked:
			if is_forced:parent_box.locked = 0
			else:return
		parent_box.global_position = Vector2(
			global_position.x + (size.x - parent_box.size.x) * 0.5,
			global_position.y - parent_box.size.y - 128
			)
		parent_box.place_parent(is_forced)
		parent_box.queue_redraw()

@export_tool_button("place_depends") var _____aasg = place_depends
func place_depends(is_forced:bool = 0) -> void:
	var x:float = size.x + 32
	for d:ClassBoxTool in deps_boxes:
		if d.locked:
			if is_forced:d.locked = 0
			else:continue
		d.global_position = Vector2(global_position.x + x + 32,global_position.y)
		x += d.size.x
		d.queue_redraw()

@export_tool_button("place_derived") var __aasdg = place_derived
func place_derived(is_forced:bool = 0) -> void:
	var x:float = size.x
	for d:ClassBoxTool in derived_boxes:
		if d.locked:
			if is_forced:d.locked = 0
			else:continue
		
		d.global_position = Vector2(
			global_position.x + x + 32,
			global_position.y + size.y + 64
			)
		x += d.size.x + 32

	for d:ClassBoxTool in derived_boxes:
		if d.locked:
			if is_forced:d.locked = 0
			else:continue
		d.global_position.x -= x * 0.5
		d.queue_redraw()

@export_tool_button("place_parent_forced") var __aaasdvvg = func():place_parent(1)
@export_tool_button("place_depends_forced") var __aassg = func():place_depends(1)
@export_tool_button("place_derived_forced") var __aasdggs = func():place_derived(1)

func _format(c:String,s:String) -> String:
	return "[color=%s]%s[/color]" % [c,s]

func set_nom() -> void:
	var n:RichTextLabel = $"1/1/1/1/N"
	n.clear()
	n.append_text(_format("AQUA" if data.is_abstarct else "SNOW",data.nom))
	
	if data.base:
		n.append_text(" : " + _format("DODGER_BLUE",data.base))

func set_vars(vis:bool) -> void:
	$"1/1/1/1/V".clear()
	if vis:
		var s:String
		for v:Var in data.vars:
			s += v.bbcoded() + "\n"
		$"1/1/1/1/V".append_text(s)
	size = Vector2.ZERO
	
func set_funcs(vis:bool) -> void:
	var fs:RichTextLabel = $"1/1/1/1/M"
	fs.clear()
	if vis:
		var s:String
		for f:Func in data.funcs.values():
			s += f.bbcoded() + "\n"
		fs.append_text(s)
	size = Vector2.ZERO

func set_data(_data:Class) -> void:
	data = _data
	set_nom()
	set_vars(1)
	set_funcs(1)

func set_deps(boxes:Dictionary[String,ClassBoxTool]) -> void:
	for d in data.dependencies:
		deps_boxes.append(boxes[d])

func _draw() -> void:
	$Drawer.queue_redraw()
