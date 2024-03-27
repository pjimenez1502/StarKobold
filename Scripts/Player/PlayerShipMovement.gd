extends RigidBody3D

var partslist #Save list of parts to be referenced? or unique variables for each object? Dictionary??
var thruster_list
@export var thrust_mult := 100.0

func ship_forward_thrust(value):
	var aim = get_global_transform().basis
	var forward = -aim.z
	
	apply_central_force(forward * value * 6 * thrust_mult)

func ship_lateral_thrust(value):
	var aim = get_global_transform().basis
	var right = aim.x
	
	apply_central_force(right * value * 2 * thrust_mult)

func ship_yaw(value):
	#reduce 
	apply_torque(Vector3.UP * value * 10)
