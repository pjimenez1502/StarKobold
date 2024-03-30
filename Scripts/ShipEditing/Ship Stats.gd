extends Node

var power_modules := []
var thrust_modules := []

var mass : int

var available_power : int
var drained_power : int

var longitudinal_thrust : Vector2
var lateral_thrust : Vector2

func _ready():
	DebugManager.player_ship_stats = self
	update_show_stats()

func calculate_thrust_vectors():
	longitudinal_thrust = Vector2.ZERO
	lateral_thrust = Vector2.ZERO
	#print(thrust_modules)
	
	for thruster in thrust_modules:
		if thruster["module"] != null:
			match thruster["rotation"]:
				0:#FORWARD
					longitudinal_thrust.x += thruster["module"].thrust
				2:#BACK
					longitudinal_thrust.y += thruster["module"].thrust
				1:#LEFT
					lateral_thrust.y += thruster["module"].thrust
				3:#RIGHT
					lateral_thrust.x += thruster["module"].thrust

func calculate_power():
	available_power = 0
	drained_power = 0
	
	for powered_module in power_modules:
		#if powered_module["module"] != null:
			if powered_module["module"].power > 0:
				available_power += powered_module["module"].power
			if powered_module["module"].power <0:
				drained_power += powered_module["module"].power
	update_show_stats()

func remove_behaviours(module):
	## search on power_modules and thrust_modules and remove entries with this module??
	pass

func update_mass(value):
	mass += value
	update_show_stats()

func update_show_stats():
	Resources_Manager.SHIP_STAT_UPDATE.emit({"mass": mass, "available_power": available_power, "drained_power": drained_power})
	
