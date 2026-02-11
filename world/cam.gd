extends Camera2D
class_name Cam

@export var roll_speed:float = 2500

var w:float = 1920/2.0 - 10
var h:float = 1080/2.0 - 10

var drag_start: Vector2
var is_dragging:bool
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_to_point(0.95)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_to_point(1.05)
		elif event.is_action_pressed("cam_grab"):
			drag_start = get_global_mouse_position()
			is_dragging = true
		elif event.is_action_released("cam_grab"):
			is_dragging = false
	elif  event is InputEventMouseMotion and is_dragging:
			position += -get_global_mouse_position() + drag_start

	elif event.is_action_pressed("ui_accept"):
		get_tree().paused = !get_tree().paused
		
func zoom_to_point(zoom_factor: float):
	var new_zoom:Vector2 = zoom * zoom_factor
	new_zoom = new_zoom.clampf(0.3,1)
	position += (-get_global_mouse_position() + global_position) * (zoom - new_zoom)
	zoom = new_zoom

func _physics_process(delta: float) -> void:
	var m = get_local_mouse_position()
	if m.x > w/zoom.x or Input.is_action_pressed("ui_right"):
		position += Vector2.RIGHT * delta * roll_speed
	elif m.x < -w/zoom.x or Input.is_action_pressed("ui_left"):
		position += Vector2.LEFT *delta * roll_speed
	if m.y > h/zoom.y or Input.is_action_pressed("ui_down"):
		position += Vector2.DOWN *delta * roll_speed
	elif m.y < -h/zoom.y or Input.is_action_pressed("ui_up"):
		position += Vector2.UP *delta * roll_speed
	

func _ready() -> void:
	var a = AudioListener2D.new()
	a.make_current()
	add_child(a)
	a.owner = self
