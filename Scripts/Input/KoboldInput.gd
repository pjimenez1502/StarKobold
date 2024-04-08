extends Node

@export var nav_agent : NavigationAgent3D

func _input(event):
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.KOBOLD:
		return
		
	if event.is_action_pressed("RightClick"):
		right_click()

func _process(delta):
	pass

func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0.1)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D

const reticle = preload("res://Scenes/reticle.tscn")
var reticle_instance
func draw_reticle():
	if !reticle_instance:
		reticle_instance = reticle.instantiate()
		get_parent().get_parent().add_child(reticle_instance)
	reticle_instance.global_position = get_mouse_pos()

func right_click():
	nav_agent.set_target_pos(get_mouse_pos())
	draw_reticle()
