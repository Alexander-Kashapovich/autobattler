@icon("res://editor_assets/leaf.svg")
@abstract
@warning_ignore("missing_tool")
extends State
class_name LeafState
##have VisualComp

@export var visual_data:StateVisualData

func control_flow_enter() -> void:
	assert(visual_data)
	ctx.visual.set_tex(visual_data)
	super.control_flow_enter()
