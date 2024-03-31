extends Node

var generator_modules := []
var powered_modules := []
##   power module example:  {"module": module_behaviour, "module_inst_id": module_instance_id, "enabled": true}
var thrust_modules := []
##   thrust module example: {"module": module_behaviour, "module_inst_id": module_instance_id, "rotation": rotation_index, "enabled": true}

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
		#if thruster["module"] != null:
		if thruster["enabled"]:
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
	
	for generator_module in generator_modules:
		if generator_module["enabled"]:
			available_power += generator_module["module"].power
	
	for powered_module in powered_modules:
		if powered_module["enabled"]:
			drained_power += powered_module["module"].power
	update_show_stats()

func remove_behaviours(module_behaviours):
	## search on powered_modules and thrust_modules and remove entries with this module??
	
	for behaviour in module_behaviours:
		if behaviour is power_behaviour:
			for power_module in powered_modules:
				if power_module["module"] == behaviour:
					powered_modules.erase(power_module)
			for power_module in generator_modules:
				if power_module["module"] == behaviour:
					generator_modules.erase(power_module)
			calculate_power()
					
		if behaviour is thruster_behaviour:
			for thruster_module in thrust_modules:
				if thruster_module["module"] == behaviour:
					thrust_modules.erase(thruster_module)
			calculate_thrust_vectors()

	update_show_stats()

func update_mass(value):
	mass += value
	update_show_stats()

func update_show_stats():
	Resources_Manager.SHIP_STAT_UPDATE.emit({"mass": mass, "available_power": available_power, "drained_power": drained_power})

func toggle_module_enabled(module_id, value):
	## TODO: REFERENCE FROM CONTROL PANEL BY "module_inst_id"
	## find in each list and toggle enabled
	pass
