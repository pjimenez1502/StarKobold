extends Node3D

#ui bob vars
const BOB_FREQ = 2.0
const BOB_AMP = .02
var t_bob = 0.0

@onready var pos = position
@onready var player = get_viewport().get_camera_3d()
#get_node("/root/Day/Player")

@export var bob : bool
@export var shake : bool
@export var shake_ammount := 0.01

var initial_position

func _ready():
	initial_position = position


func _physics_process(delta):
	
	var calculated_shake = shake_ammount * global_position.distance_to( get_viewport().get_camera_3d().global_position)
	var calculated_bob = BOB_AMP * global_position.distance_to( get_viewport().get_camera_3d().global_position)
	
	if bob:
		t_bob += delta
		position.y = pos.y + sin(t_bob * BOB_FREQ) * calculated_bob
		
	if shake:
		position.x = initial_position.x + randf_range(-1.0, 1.0) * calculated_shake
		position.y = initial_position.y + randf_range(-1.0, 1.0) * calculated_shake
