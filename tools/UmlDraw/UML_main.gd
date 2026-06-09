@tool
extends Node2D
class_name UMLMain

const SCAN_ROOT := "res://"
var _placer:UMLClassBoxPlacer = UMLClassBoxPlacer.new()

@export var print_vars:bool = 1:
	set(val):
		print_vars = val
		for b:ClassBoxTool in boxes.values():b.set_vars(val)
			
@export var print_funcs:bool = 1:
	set(val):
		print_funcs = val
		for b:ClassBoxTool in boxes.values():b.set_funcs(val)

@export var classes:Dictionary[String,Class]
@export var boxes:Dictionary[String,ClassBoxTool]
@export var boxes_dest:Node

@export_tool_button("clear") var __gas = clear
func clear() -> void:
	for box in boxes_dest.get_children():
		box.queue_free()
	await get_tree().process_frame
	
	classes.clear()
	boxes.clear()

@export_tool_button("go") var __asd = go
func go():
	await clear()
	var c = UMLClassCollector.new()
	classes = c.collect_classes(SCAN_ROOT)
	
	var b = UMLBoxBuilder.new()
	b.setup_and_go(classes,boxes_dest)
	
	for ch:ClassBoxTool in boxes_dest.get_children():
		boxes[ch.name] = ch
	
	for ch:ClassBoxTool in boxes_dest.get_children():
		ch.set_deps(boxes)
	
	__asg.call()

@export_tool_button("place_as_grid") var __asg = func():_placer.place_as_grid(boxes)

@export_tool_button("place_with_force") var _ss_asg = func():_placer.place_by_force(boxes)
