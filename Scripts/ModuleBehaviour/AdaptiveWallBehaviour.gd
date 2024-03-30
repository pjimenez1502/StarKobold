extends module_behaviour
class_name adaptivewall_behaviour

@export var north_section : Node3D
@export var south_section : Node3D
@export var east_section : Node3D
@export var west_section : Node3D
@export var corner : Node3D
@export var center : Node3D

func start_behaviour():
	pass

func connect_surrounding_walls(surrounding_tiles):
	reset_walls_visible()
	var found_tiles = []
	for tile in surrounding_tiles:
		if surrounding_tiles[tile]:
			if surrounding_tiles[tile]["module_data"].category == 0:
				found_tiles.append(tile)
		else:
			continue
	
	if place_if_corner(found_tiles):
		return
		
	place_if_not_corner(surrounding_tiles)



func place_if_corner(found_tiles):
	if found_tiles.size() != 2:
		return false
	print(found_tiles)
	match found_tiles:
			["north","east"]:
				print("northeast")
				center.visible = false
				corner.visible = true
				corner.rotation = Vector3(0, deg_to_rad(90 * 1), 0)
				return true
			["south","east"]:
				print("eastsouth")
				center.visible = false
				corner.visible = true
				corner.rotation = Vector3(0, deg_to_rad(90 * 0), 0)
				return true
			["south","west"]:
				print("southwest")
				center.visible = false
				corner.visible = true
				corner.rotation = Vector3(0, deg_to_rad(90 * 3), 0)
				return true
			["north","west"]:
				print("westnorth")
				center.visible = false
				corner.visible = true
				corner.rotation = Vector3(0, deg_to_rad(90 * 2), 0)
				return true
	return false

func place_if_not_corner(surrounding_tiles):
	for tile in surrounding_tiles:
		if !surrounding_tiles[tile]:
			continue
		match tile:
			"north": 
				if surrounding_tiles["north"]["module_data"].category == 0:
					north_section.visible = true
			"south": 
				if surrounding_tiles["south"]["module_data"].category == 0:
					south_section.visible = true
			"east": 
				if surrounding_tiles["east"]["module_data"].category == 0:
					east_section.visible = true
			"west": 
				if surrounding_tiles["west"]["module_data"].category == 0:
					west_section.visible = true

func reset_walls_visible():
	north_section.visible = false
	south_section.visible = false
	east_section.visible = false
	west_section.visible = false
	corner.visible = false
