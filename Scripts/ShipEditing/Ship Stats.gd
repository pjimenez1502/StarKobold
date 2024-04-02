extends Node

var generator_modules := []
var powered_modules := []
##   power module example:  {"module": module_behaviour, "module_inst_id": module_instance_id, "enabled": true}
var thrust_modules := []
##   thrust module example: {"module": module_behaviour, "module_inst_id": module_instance_id, "rotation": rotation_index, "enabled": true}
var hardpoint_module := []
##   thrust module example: {"module": module_behaviour, "module_inst_id": module_instance_id, "enabled": true, "firing": false}

var mass : int

var available_power : int
var drained_power : int

var longitudinal_thrust : Vector2
var lateral_thrust : Vector2

func _ready():
	Resources_Manager.SHIP_CALCULATE_POWER.connect(calculate_power)
	
	DebugManager.player_ship_stats = self
	update_show_stats()



func add_thruster_module(module_data):
	thrust_modules.append(module_data)
	calculate_thrust_vectors()

func add_generator_module(module_data):
	generator_modules.append(module_data)
	calculate_power()
	OverlaysManager.add_controlpanel_generator_entry(module_data)

func add_powered_module(module_data):
	powered_modules.append(module_data)
	calculate_power()
	OverlaysManager.add_controlpanel_powered_entry(module_data)

#func add_hardpoint_module(module_data):
	#pass



func remove_module(module):
	if !module is module_properties:
		return
	remove_behaviours(module.behaviours)
	##signal to remove from controlpanel
	
func remove_behaviours(module_behaviours):
	for behaviour in module_behaviours:
		if behaviour is power_behaviour:
			for power_module in powered_modules:
				if power_module["module"] == behaviour:
					powered_modules.erase(power_module)
					OverlaysManager.remove_controlpanel_powered_entry(power_module["module_inst_id"])
					
			for power_module in generator_modules:
				if power_module["module"] == behaviour:
					generator_modules.erase(power_module)
					OverlaysManager.remove_controlpanel_generator_entry(power_module["module_inst_id"])
			calculate_power()
					
		if behaviour is thruster_behaviour:
			for thruster_module in thrust_modules:
				if thruster_module["module"] == behaviour:
					thrust_modules.erase(thruster_module)
			calculate_thrust_vectors()
		
		#if behaviour is hardpoint_behaviour:
					#OverlaysManager.remove_controlpanel_powered_entry(power_module["module_inst_id"])
	update_show_stats()



func calculate_thrust_vectors():
	longitudinal_thrust = Vector2.ZERO
	lateral_thrust = Vector2.ZERO
	#print(thrust_modules)
	
	for thruster in thrust_modules:
		longitudinal_thrust.x += thruster["module"].thrust.x
		longitudinal_thrust.y += thruster["module"].thrust.y
		lateral_thrust.x += thruster["module"].thrust.z
		lateral_thrust.x += thruster["module"].thrust.w

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

func update_mass(value):
	mass += value
	update_show_stats()

func update_show_stats():
	Resources_Manager.SHIP_STAT_UPDATE.emit({"mass": mass, "available_power": available_power, "drained_power": drained_power})

