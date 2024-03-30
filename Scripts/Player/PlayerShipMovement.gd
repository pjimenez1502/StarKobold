extends RigidBody3D

@onready var ship_stats = $"Ship Stats"

func _ready():
	DebugManager.player_ship = self

func ship_forward_thrust(value):
	var aim = get_global_transform().basis
	var forward = -aim.z
	
	if value > 0:
		apply_central_force(forward * value * ship_stats.longitudinal_thrust.x)
	if value < 0:
		apply_central_force(forward * value * ship_stats.longitudinal_thrust.y)
	

func ship_lateral_thrust(value):
	var aim = get_global_transform().basis
	var right = aim.x
	
	if value > 0:
		apply_central_force(right * value * ship_stats.lateral_thrust.x)
	if value < 0:
		apply_central_force(right * value * ship_stats.lateral_thrust.y)

func ship_yaw(value):
	var yaw_power = (ship_stats.lateral_thrust.x + ship_stats.lateral_thrust.y) / 50
	
	apply_torque(Vector3.UP * value * yaw_power)
