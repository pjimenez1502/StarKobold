extends Node

@onready var debug_coords = %DebugCoords
@onready var debug_thrust = %DebugThrust

func _physics_process(delta):
	if !DebugManager.player_ship:
		return
	show_ship_coords()
	
	if !DebugManager.player_ship_stats:
		return
	show_ship_thrust()

func show_ship_coords():
	debug_coords.text = str(DebugManager.player_ship.position)

func show_ship_thrust():
	debug_thrust.text = str(
		"Thrust: ", DebugManager.player_ship_stats.longitudinal_thrust.x,
		"\nBack: ", DebugManager.player_ship_stats.longitudinal_thrust.y,
		"\nRight: ", DebugManager.player_ship_stats.lateral_thrust.x,
		"\nLeft: ", DebugManager.player_ship_stats.lateral_thrust.y,)

func show_ship_weight():
	pass

func show_ship_power():
	pass
