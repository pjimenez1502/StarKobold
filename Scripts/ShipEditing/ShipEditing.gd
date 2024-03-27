extends Node

@onready var player_ship = $".."

@onready var ship_builder = $"Ship Builder"
@onready var module_placer = $"Module Placer"

@onready var ship_grid_map = $"../NavigationRegion3D/ShipGridMap"

var editingmode_enabled := true

var current_selected_module
## Hotkey or button to enable edit mode
## Stop time?
## UI to select parts and show costs / stats
## LeftClick to place selected part, RightClick to remove

func toggle_editing():
	editingmode_enabled = !editingmode_enabled
	print("editing: ", editingmode_enabled)

func _physics_process(delta):
	if !editingmode_enabled:
		return
	move_preview_to_mouse()

func _input(event):
	if !editingmode_enabled:
		return
	if event.is_action_pressed("RightClick"):
		right_click()
	if event.is_action_pressed("LeftClick"):
		left_click()
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_B:
			select_module("debug")
	check_number_keys(event)

var current_category := 1
func check_number_keys(event):
	match current_category:
		1:
			if event.is_action_pressed("1"):
				select_module("floor_01")
			if event.is_action_pressed("2"):
				select_module("wall_01")
			if event.is_action_pressed("3"):
				select_module("wall_01_corner")
			if event.is_action_pressed("4"):
				select_module("")
			if event.is_action_pressed("5"):
				select_module("wall_01_T")
			if event.is_action_pressed("6"):
				select_module("wall_01_X")
		2:
			pass
func check_section_selectors(event):
	if event.is_action_pressed("mod_1"):
		current_category = 1
	if event.is_action_pressed("mod_2"):
		current_category = 2
	if event.is_action_pressed("mod_3"):
		current_category = 3
	if event.is_action_pressed("mod_4"):
		current_category = 4
	if event.is_action_pressed("mod_5"):
		current_category = 5
	print("Changed category to: ", current_category)

func right_click():
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.remove_module(position)

func left_click():
	if !module_placer.can_place:
		return
	var position = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	ship_builder.instantiate_module(current_selected_module, position)

func select_module(id):
	module_placer.select_module(id)
	current_selected_module = id
	pass

func move_preview_to_mouse():
	var grid_mouse_pos = ship_grid_map.local_to_map(player_ship.to_local(get_mouse_pos()))
	var local_from_grid_mouse_pos = ship_grid_map.map_to_local(grid_mouse_pos)
	module_placer.move_preview(local_from_grid_mouse_pos)

func get_mouse_pos():
	var camera = get_viewport().get_camera_3d()
	var position2D = get_viewport().get_mouse_position()
	var dropPlane  = Plane(Vector3(0, 1, 0), 0.1)
	var position3D = dropPlane.intersects_ray(camera.project_ray_origin(position2D),camera.project_ray_normal(position2D))
	if !position3D:
		return Vector3.ZERO
	return position3D
