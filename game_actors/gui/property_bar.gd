@tool
extends Control
class_name PropertyBar
## only UI component

@onready var val_bar:ColorRect = $Val
@onready var tmp_bar:ColorRect = $Tmp

var _cur:float

func setup(prop:VitalProperty) -> void:
	prop.modified.connect(_set_cur)
	resize()
	_set_cur(prop.percentage())

func _set_cur(new_val:float) -> void:
	#upd bars must be earlier condition check
	var old_val:float = _cur
	_cur = new_val
	_upd_bars()
	
	if new_val < old_val:
		set_process(1)
	else:
		set_process(0)
		#for this
		tmp_bar.size.x = val_bar.size.x

func _ready() -> void:
	set_process(0)

func _upd_bars() -> void:
	val_bar.size.x = size.x * _cur

func _process(delta: float) -> void:
	tmp_bar.size.x += (val_bar.size.x - tmp_bar.size.x - 5.0) * delta
	
	if (tmp_bar.size.x - val_bar.size.x < 1):
		tmp_bar.size = val_bar.size
		set_process(0)

	
@warning_ignore("unused_private_class_variable")
@export_tool_button("resize") var ___asdds = resize
func resize() -> void:
	tmp_bar.size.y = size.y
	val_bar.size.y = size.y
	tmp_bar.position.x = 0
	val_bar.position.x = 0
	_upd_bars()
