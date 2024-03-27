extends Node

@onready var player_ship = $".."
@onready var ship_camera = $"../../ShipCameraPivot/ShipCamera"
@onready var player_camera = $"../../PlayerCameraPivot/PlayerCamera"
@onready var editing_camera = $"../EditingCamera"

var ship_control_enabled := false

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F1:
			ship_control_enabled = false
			player_camera.set_current(true)
		if event.pressed and event.keycode == KEY_F2:
			ship_control_enabled = true
			ship_camera.set_current(true)
		if event.pressed and event.keycode == KEY_F3:
			ship_control_enabled = false
			editing_camera.set_current(true)
			
func _physics_process(delta):
	control()

func control():
	if !ship_control_enabled:
		return
	if Input.is_action_pressed("YawRight"):
		player_ship.ship_yaw(-1)
	if Input.is_action_pressed("YawLeft"):
		player_ship.ship_yaw(1)


	if Input.is_action_pressed("Forward"):
		player_ship.ship_forward_thrust(1)
	if Input.is_action_pressed("Backward"):
		player_ship.ship_forward_thrust(-0.4)
	if Input.is_action_pressed("Right"):
		player_ship.ship_lateral_thrust(1)
	if Input.is_action_pressed("Left"):
		player_ship.ship_lateral_thrust(-1)

