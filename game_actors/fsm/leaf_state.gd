@icon("res://assets/editor_assets/leaf.svg")
@abstract
@warning_ignore("missing_tool")
extends State
class_name LeafState
## Leaf is end state with visual data. Current leaf referenced as bb.current_state

#entering in cast may request transition (several transition in one frame)

#spritesheets
@export var visual_data:StateVisualData

#setup visual and set current in bb
func control_flow_enter() -> void:
	assert(visual_data)
	assert(!bb.cur_state)
	bb.set_cur(self)
	ctx.visual.set_tex(visual_data)
	super.control_flow_enter()

func control_flow_exit() -> void:
	assert(visual_data)
	super.control_flow_exit()
	assert(bb.cur_state == self)
	#for consistency and asserting
	bb.set_cur(null)
	
	
