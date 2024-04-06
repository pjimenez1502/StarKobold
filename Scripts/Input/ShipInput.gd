extends Node

@onready var player_ship = $".."
@onready var ship_camera = $"../../ShipCameraPivot/Camera"
@onready var player_camera = $"../../PlayerCameraPivot/Camera"


func _physics_process(delta):
	control()

func control():
	if !ControlFocusManager.current_control_focus == ControlFocusManager.CONTROL_FOCUS.SHIP:
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

