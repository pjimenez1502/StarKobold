extends Node

var gridmap_tile_size = 2
@onready var ship_grid_map = $"../../NavigationRegion3D/ShipGridMap"
@onready var module_placer = $"../Module Placer"
@onready var ship_navigation_region = $"../../NavigationRegion3D"
@onready var ship_stats = $"../../Ship Stats"

var module_list := []
var occupied_tiles := [] ##id is comprised of id:"helm_01" and subId:"#1" to differentiate multiple modules of same type



func _ready():
	generate_occupied_list()
	pass

func generate_occupied_list(): ## Generate ship from list
	Resources_Manager.no_costs = true
	for module in load_module_list:
		var module_data = find_module_by_id(module["module_id"])
		if !module_data:
			printerr("data for id: ", module["module_id"], " not found.")
		else:
			#fill_occupied_tiles_from_module(module_data, module["position"])
			instantiate_module(module["module_id"], module["position"], module["rotation"])
	Resources_Manager.no_costs = false
	
func find_module_by_id(id):
	for module_data in ModulesDataManager.module_resources:
		if module_data["id"] == id:
			return module_data
	return null

func fill_occupied_tiles_from_module(module_data, position, instance, rotation) -> int:
	var module_id = get_next_module_id()
	
	module_list.append({
		"id": module_id, "module_id": module_data.id, "position": position, "rotation": rotation
	})
	
	for tile in module_data.tiles:
		occupied_tiles.append({
			"id": module_id ,"position": position + Vector3i(tile[0], 0, tile[1]), "module_id": module_data.id, "instance": instance, "module_data": module_data
			})
	return module_id

func get_next_module_id():
	if occupied_tiles.size() == 0:
		return 0
	#print(occupied_tiles)
	return occupied_tiles[occupied_tiles.size()-1]["id"] +1



## PLACE MODULE
func instantiate_module(module_id, position, rotation_index):
	var module_data = find_module_by_id(module_id)
	if !module_data:
		return
		
	if !Resources_Manager.can_afford(module_data.costs):
		print("NOT ENOUGH RESOURCES")
		return
	
	rotation_index = rotation_index if !module_data.fixed_rotation else 0
	
	var instance = module_data.object.instantiate()
	ship_grid_map.add_child(instance)
	
	instance.position = position * gridmap_tile_size
	instance.rotation = Vector3(0, deg_to_rad(90*rotation_index), 0)
	
	var module_instance_id = fill_occupied_tiles_from_module(module_data, position * gridmap_tile_size, instance, rotation_index)
	
	implement_module_behaviour(instance, position, rotation_index, module_instance_id, module_data)
	
	Resources_Manager.remove_resourcelist(module_data.costs)
	ship_navigation_region.bake_navigation_mesh()

func implement_module_behaviour(module_instance, position, rotation_index, module_instance_id, module_data):
	if module_instance is module_properties:
		for module_behaviour in module_instance.behaviours:
			
			if module_behaviour is adaptivewall_behaviour: ## CHECK DIRECT SURROUNDING TILES FOR WALLS
				var surrounding_tiles = get_surrounding_tile_data(position)
				module_behaviour.connect_surrounding_walls(surrounding_tiles) ## CHECK FOCUSED WALL
				update_surrounding_walls(surrounding_tiles) ## UPDATE SURROUNDING WALLS
				
			if module_behaviour is thruster_behaviour:
				ship_stats.add_thruster_module({"module": module_behaviour, "module_inst_id": module_instance_id, "module_name": module_data.name, "rotation": rotation_index, "enabled": true})
				
			if module_behaviour is power_behaviour:
				module_behaviour.set_value_from_stats(module_data.stats["power"])
				if module_data.stats["power"] > 0:
					ship_stats.add_generator_module({"module": module_behaviour, "module_inst_id": module_instance_id, "module_name": module_data.name, "enabled": true})
					
				if module_data.stats["power"] < 0:
					ship_stats.add_powered_module({"module": module_behaviour, "module_inst_id": module_instance_id, "module_name": module_data.name ,"enabled": true})
				
				
	ship_stats.update_mass(module_data.stats["mass"])



## REMOVE MODULE
func remove_module(position):
	var instance_to_remove
	var tile_to_remove = fetch_tile_by_pos(position * gridmap_tile_size)
	if !tile_to_remove:
		return
	instance_to_remove = tile_to_remove["instance"]
	
	if !instance_to_remove:
		return false
	
	ship_stats.remove_module(instance_to_remove)
	ship_stats.update_mass(-tile_to_remove.module_data.stats["mass"])
	return_resources(tile_to_remove.module_data.costs)
	
	remove_from_module_list(tile_to_remove["id"])
	
	var tiles_to_delete : Array ## erase occupied tiles
	for tile in occupied_tiles:
		if tile.instance == instance_to_remove:
			tiles_to_delete.append(tile)
	for tile in tiles_to_delete:
		occupied_tiles.erase(tile)
	instance_to_remove.get_parent().remove_child(instance_to_remove)
	ship_navigation_region.bake_navigation_mesh()
	instance_to_remove.queue_free()



func return_resources(module_costs):
	Resources_Manager.return_resources(module_costs)

func remove_from_module_list(module_id):
	for module_entry in module_list:
		if module_entry["id"] == module_id:
			module_list.erase(module_entry)

func fetch_tile_by_pos(position):
	for tile in occupied_tiles:
		if tile.position == position:
			return tile

func get_surrounding_tile_data(position):
	var north = fetch_tile_by_pos(position + Vector3i(0,0,-1))
	var south = fetch_tile_by_pos(position + Vector3i(0,0,1))
	var east = fetch_tile_by_pos(position + Vector3i(1,0,0))
	var west = fetch_tile_by_pos(position + Vector3i(-1,0,0))
	return {
		"north": north,
		"south": south,
		"east": east,
		"west": west,
	}

func update_surrounding_walls(surrounding_tiles):
	for tile in surrounding_tiles:
		if !surrounding_tiles[tile]:
			continue
		var module_instance = surrounding_tiles[tile]["instance"]
		if !module_instance:
			continue
		if surrounding_tiles[tile]["instance"] is module_properties:
			for module_behaviour in module_instance.behaviours:
				if module_behaviour is adaptivewall_behaviour:
					var new_surrounding_tiles = get_surrounding_tile_data(surrounding_tiles[tile]["position"])
					module_behaviour.connect_surrounding_walls(new_surrounding_tiles)



func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_P:
			print(module_list)

## REPLACE: position": (    TO:   position": Vector3i(
var load_module_list = [{ "id": 0, "module_id": "cockpit_small_01", "position": Vector3i(0, 0, -1), "rotation": 0 }, { "id": 1, "module_id": "thruster_main_small_01", "position": Vector3i(0, 0, 0), "rotation": 0 }]
#var load_module_list = [{ "id": 1, "module_id": "helmChair_01", "position": Vector3i(0, 0, -2), "rotation": 0 }, { "id": 2, "module_id": "wall_01", "position": Vector3i(0, 0, -3), "rotation": 0 }, { "id": 3, "module_id": "wall_01", "position": Vector3i(-1, 0, -3), "rotation": 0 }, { "id": 4, "module_id": "wall_01", "position": Vector3i(1, 0, -3), "rotation": 0 }, { "id": 5, "module_id": "wall_01", "position": Vector3i(1, 0, -2), "rotation": 0 }, { "id": 6, "module_id": "wall_01", "position": Vector3i(-1, 0, -2), "rotation": 0 }, { "id": 7, "module_id": "wall_01", "position": Vector3i(-1, 0, -1), "rotation": 0 }, { "id": 8, "module_id": "wall_01", "position": Vector3i(1, 0, -1), "rotation": 0 }, { "id": 10, "module_id": "wall_01", "position": Vector3i(-1, 0, 0), "rotation": 0 }, { "id": 11, "module_id": "floor_01", "position": Vector3i(0, 0, -1), "rotation": 0 }, { "id": 12, "module_id": "door_01", "position": Vector3i(0, 0, 0), "rotation": 1 }, { "id": 13, "module_id": "wall_01", "position": Vector3i(2, 0, 0), "rotation": 0 }, { "id": 14, "module_id": "wall_01", "position": Vector3i(1, 0, 0), "rotation": 0 }, { "id": 15, "module_id": "wall_01", "position": Vector3i(-2, 0, 0), "rotation": 0 }, { "id": 16, "module_id": "wall_01", "position": Vector3i(2, 0, 1), "rotation": 0 }, { "id": 17, "module_id": "wall_01", "position": Vector3i(2, 0, 2), "rotation": 0 }, { "id": 18, "module_id": "wall_01", "position": Vector3i(-2, 0, 1), "rotation": 0 }, { "id": 19, "module_id": "wall_01", "position": Vector3i(-2, 0, 2), "rotation": 0 }, { "id": 20, "module_id": "wall_01", "position": Vector3i(-2, 0, 3), "rotation": 0 }, { "id": 21, "module_id": "wall_01", "position": Vector3i(-1, 0, 3), "rotation": 0 }, { "id": 22, "module_id": "wall_01", "position": Vector3i(0, 0, 3), "rotation": 0 }, { "id": 23, "module_id": "wall_01", "position": Vector3i(1, 0, 3), "rotation": 0 }, { "id": 24, "module_id": "wall_01", "position": Vector3i(2, 0, 3), "rotation": 0 }, { "id": 25, "module_id": "floor_01", "position": Vector3i(0, 0, 1), "rotation": 0 }, { "id": 26, "module_id": "floor_01", "position": Vector3i(-1, 0, 1), "rotation": 0 }, { "id": 27, "module_id": "floor_01", "position": Vector3i(-1, 0, 2), "rotation": 0 }, { "id": 28, "module_id": "floor_01", "position": Vector3i(1, 0, 1), "rotation": 0 }, { "id": 29, "module_id": "floor_01", "position": Vector3i(1, 0, 2), "rotation": 0 }, { "id": 30, "module_id": "reactor_01", "position": Vector3i(0, 0, 2), "rotation": 1 }, { "id": 31, "module_id": "manouverthruster_01", "position": Vector3i(3, 0, 1), "rotation": 2 }, { "id": 32, "module_id": "manouverthruster_01", "position": Vector3i(3, 0, 2), "rotation": 1 }, { "id": 33, "module_id": "manouverthruster_01", "position": Vector3i(-3, 0, 1), "rotation": 2 }, { "id": 34, "module_id": "manouverthruster_01", "position": Vector3i(-3, 0, 2), "rotation": 3 }, { "id": 35, "module_id": "mainthruster_01", "position": Vector3i(3, 0, 3), "rotation": 0 }, { "id": 36, "module_id": "mainthruster_01", "position": Vector3i(-3, 0, 3), "rotation": 0 }]
