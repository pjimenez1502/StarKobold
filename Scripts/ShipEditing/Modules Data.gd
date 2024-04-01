extends Resource

class_name Module_Resource

enum ModuleCategories { COCKPIT, POWER, THRUSTER, CARGO, HALLWAY, HABITATION, HARDPOINT, UTILITY}

@export var id : String
@export var name : String
@export var desc : String
@export var category : ModuleCategories
@export var object : PackedScene
@export var tiles := [[0,0]]
@export var costs = {
	"credits": 0,
	"scrap": 0,
	"magnetic_elements": 0,
	"electrical_components": 0,
	"baroplastic_segments": 0,
	"blastproof_modules": 0,
	"semiconductive_fibers": 0,
	#"": 0,
}
@export var stats = {
	"mass": 0,
	"integrity": 1000,
	"power": 0,
	"fuelcapacity": 0, ## in KG
	"fuelconsumption": 0, ## in KG per min
}
@export var fixed_rotation : bool
