extends KinematicBody

# declare of object
onready var pivot_point: Spatial = $PivotPoint
onready var fps_label: Label = $MainUI/FPS_label

# declare of export variables
export var mouse_sensitivity: float = 0.3
export var full_screen: bool = false
onready var interaction_label: Label = $WorldMainUI/InteractionLabel

# declare of conditions
var gravity: float = -20.0
var movement_speed: float = 10.0

# declare of directional variables
var up_dir: Vector3 = Vector3.UP
var _velocity: Vector3 = Vector3()
var _dir: Vector3 = Vector3()
var gravity_local: Vector3 = Vector3()
var snap_vector: Vector3 = Vector3.ZERO



func _ready():
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
#	if not interaction_label.rect_size.y == 582:
#		interaction_label.rect_size.y = 582
	
	if full_screen == true:
		OS.window_fullscreen = true
	
	
func _physics_process(delta):
	var input_move = process_movement() * movement_speed
	if is_on_floor():
		gravity_local = Vector3.ZERO
		snap_vector = -get_floor_normal()
	else:
		gravity_local.y += gravity * delta
	
	
	var player_movement = move_and_slide_with_snap(input_move + gravity_local, snap_vector, Vector3.UP, true)
	
	process_input()
	

func _process(delta):
	var fps_frame_rate = Engine.get_frames_per_second()
	fps_label.text = str("fps: ", fps_frame_rate)

func process_input():
	if Input.is_action_just_pressed("DebugFullScreen"):
		if OS.window_fullscreen == true:
			OS.window_fullscreen = false
		else:
			OS.window_fullscreen = true
	
	if Input.is_action_just_pressed("F1"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("Debug_Quit"):
		get_tree().quit()

func process_movement() -> Vector3:
	var X: float
	X = Input.get_action_strength("movement_left") * -1 - Input.get_action_strength("movement_right") * -1
	
	var Z: float
	Z = Input.get_action_strength("movement_up") * -1 - Input.get_action_strength("movement_down") * -1
	
	return transform.basis.xform(Vector3(X,0,Z).normalized())
	

func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		pivot_point.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var pivot_point_rot = pivot_point.rotation_degrees
		pivot_point_rot.x = clamp(pivot_point_rot.x, -90, 90)
		pivot_point.rotation_degrees = pivot_point_rot






