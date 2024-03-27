extends Node

@onready var ship_grid_map = $"../../NavigationRegion3D/ShipGridMap"
@onready var module_placer = $"../Module Placer"


## Modules installed on ship:
var module_list := [ ## SIZE: [wide, long]
	{"id": "helm_01", "position": Vector3i(0,0,-1), "rotation": 0},
]

var occupied_tiles := [] ##id is comprised of id:"helm_01" and subId:"#1" to differentiate multiple modules of same type


func _ready():
	generate_occupied_list()
	
func instantiate_module(module_id, position):
	var module_data = find_module_by_id(module_id)
	var instance = module_data.object.instantiate()
	ship_grid_map.add_child(instance)
	instance.position = position
	fill_occupied_tiles_from_module(module_data, position, instance)


func generate_occupied_list():
	for module in module_list:
		var module_data = find_module_by_id(module["id"])
		if !module_data:
			printerr("data for id: ", module["id"], " not found.")
		else:
			#fill_occupied_tiles_from_module(module_data, module["position"])
			instantiate_module(module["id"], module["position"])

func find_module_by_id(id):
	for module_data in module_placer.MODULES_DATA:
		if module_data["id"] == id:
			return module_data
	return false

func fill_occupied_tiles_from_module(module_data, position, instance):
	for tile in module_data.tiles:
		occupied_tiles.append({
			"position": position + Vector3i(tile[0], 0, tile[1]), "id": module_data.id, "instance": instance
			})

func remove_module(position):
	var instance_to_remove
	for tile in occupied_tiles:
		if tile.position == position:
			instance_to_remove = tile.instance
			continue
	if !instance_to_remove:
		return false
		
	print("inst to remove = ", instance_to_remove)
	#print(occupied_tiles)
	var tiles_to_delete : Array
	for tile in occupied_tiles:
		if tile.instance == instance_to_remove:
			tiles_to_delete.append(tile)
			print(tile)

	for tile in tiles_to_delete:
		occupied_tiles.erase(tile)
	instance_to_remove.queue_free()
	
