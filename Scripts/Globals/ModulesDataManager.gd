extends Node

var module_selector_ui

var module_resources = [
	load("res://Scenes/Modules/0_COCKPIT/cockpit_small_01/cockpit_small_01.tres"),
	load("res://Scenes/Modules/1_POWER/reactor_01/reactor_01.tres"),
	load("res://Scenes/Modules/2_THRUSTER/thruster_main_small_01/thruster_main_small_01.tres"),
	load("res://Scenes/Modules/3_CARGO/cargo_small_01/cargo_small_01.tres"),
	load("res://Scenes/Modules/3_CARGO/fuel_small_01/fuel_small_01.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_n/hallway_01_n.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_corner/hallway_01_corner.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_X/hallway_01_X.tres"),
	#load(),
]

var module_references = {
		"COCKPIT": {
			1: ["cockpit_small_01"],
		},
		"POWER":{
			1: ["reactor_01"]
		},
		"THRUSTER":{
			1: ["thruster_main_small_01"]
		},
		"CARGO":{
			1: ["cargo_small_01"],
			2: ["fuel_small_01"],
		},
		"HALLWAY":{
			1: ["hallway_01", "hallway_01_corner", "hallway_01_X"]
		},
		"HABITATION":{
			
		},
		"HARDPOINT":{
			
		},
		"UTILITY":{
			
		}
	}

func get_modules_from_category(category: String):
	return module_references[category]
