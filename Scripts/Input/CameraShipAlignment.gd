extends Node

var cam_pivot
@export var rotation_follow_speed := 2.0

func _ready():
	cam_pivot = get_parent()

func _process(delta):
	cam_pivot.rotation.y = lerp_angle(cam_pivot.rotation.y, cam_pivot.ship.rotation.y, delta * rotation_follow_speed)
	
