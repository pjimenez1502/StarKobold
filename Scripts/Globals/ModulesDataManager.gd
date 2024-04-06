extends Node

var module_selector_ui
var module_placer

var module_resources = [
	## COCKPIT
	load("res://Scenes/Modules/0_COCKPIT/cockpit_small_01/cockpit_small_01.tres"),
	## POWER
	load("res://Scenes/Modules/1_POWER/reactor_01/reactor_01.tres"),
	## THRUST
	load("res://Scenes/Modules/2_THRUSTER/thruster_main_small_01/thruster_main_small_01.tres"),
	## CARGO
	load("res://Scenes/Modules/3_CARGO/cargo_small_01/cargo_small_01.tres"),
	load("res://Scenes/Modules/3_CARGO/cargo_large_01/cargo_large_01.tres"),
	load("res://Scenes/Modules/3_CARGO/fuel_small_01/fuel_small_01.tres"),
	## HALLWAY
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_n/hallway_01_n.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_T/hallway_01_T.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_corner/hallway_01_corner.tres"),
	load("res://Scenes/Modules/4_HALLWAY/hallway_01_X/hallway_01_X.tres"),
	## FACILITY
	load("res://Scenes/Modules/5_FACILITY/communications_module_01/communications_module_01.tres"),
	## DEFENSE
	#load(),
]
enum categories {
	COCKPIT, POWER, THRUST, CARGO, HALLWAY, FACILITY, DEFENSE, UTILITY
}

var module_references = {
		"COCKPIT":[
			"cockpit_small_01",
		],
		"POWER":[
			"reactor_01",
		],
		"THRUST":
		[
			"thruster_main_small_01",
		],
		"CARGO": [
			"cargo_small_01",
			"cargo_large_01",
			"fuel_small_01",
		],
		"HALLWAY": [
			"hallway_01", "hallway_01_T", "hallway_01_corner", "hallway_01_X"
		],
		"FACILITY": [
			"communications_module_01"
		],
		"DEFENSE": [
			
		],
		"UTILITY": [
			
		]
	}

var current_category := "COCKPIT"
var current_selected_module

func select_category(category_id):
	module_selector_ui.highligh_active_category_button(category_id)
	module_selector_ui.load_category(category_id)

func select_all_category():
	pass
	
func select_module(module_id):
	module_placer.select_module(module_id)
	current_selected_module = module_id
	pass

func get_modules_from_category(category: String):
	return module_references[category]

func get_module_data(module_id):
	for module in module_resources:
		if module.id == module_id:
			return module
