extends Resource

class_name Module_Resource

enum ModuleCategories {SYSTEM, HULL}

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
	"blastproof_modules": 0,
	"polyplastics": 0,
}
