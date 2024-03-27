extends Node3D

@export var player : Node3D
@export var zoom_range : Vector2
@export var follow_speed : float

var target : Node3D
var camera : Camera3D
func _ready():
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
