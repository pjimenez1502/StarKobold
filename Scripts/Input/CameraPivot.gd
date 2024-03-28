extends Node3D

@export var player : Node3D
@export var zoom_range : Vector2
@export var follow_speed : float

enum CAMERA_FOCUS {KOBOLD,SHIP}
@export var camera_focus : CAMERA_FOCUS

var target : Node3D
var camera : Camera3D
func _ready():
	ControlFocusManager.FOCUS_CHANGED.connect(check_control_focus_camera)
	camera = get_child(0)
	target = player

func _input(event):
	if Input.is_action_just_pressed("ScrollDown"):
		camera_zoom(1)
	if Input.is_action_just_pressed("ScrollUp"):
		camera_zoom(-1)
		
	if Input.is_action_pressed("ui_right"):
		rotate_y(0.5)
	if Input.is_action_pressed("ui_left"):
		rotate_y(-0.5)

func _physics_process(delta):
	var target_position = target.global_position
	position = lerp(position, target_position, delta * follow_speed)
	
	camera.position.z = lerp(camera.position.z, cam_distance, delta * 4)
	
@onready var cam_distance : float = zoom_range.x
func camera_zoom(value):
	cam_distance = clamp(cam_distance + value, zoom_range.x, zoom_range.y)
	#print(cam_distance)
	#camera.position.z = cam_distance
	
var looking_at_player = true

func check_control_focus_camera(_control_focus):
	match _control_focus:
		0: #control focus is KOBOLD
			if camera_focus == CAMERA_FOCUS.KOBOLD:
				camera.current = true
		1,2: #control focus is SHIP or EDIT
			if camera_focus == CAMERA_FOCUS.SHIP:
				camera.current = true
