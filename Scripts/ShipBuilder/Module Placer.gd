extends Node

const PLACEMENT_CHECK_MAT = preload("res://Shaders/Placement_Check_Mat.tres")
#@export var MODULES_DATA : Array[Resource]

@onready var ship_builder = $"../Ship Builder"

@onready var module_placing_preview = $"../../NavigationRegion3D/ShipGridMap/Module_placing_preview"
@onready var preview_mesh = $"../../NavigationRegion3D/ShipGridMap/Module_placing_preview/PreviewMesh"

var preview_instance
var hovered_tile : Vector3i
var module_selected_rotation : float = 0
var current_module_fixed_rotation : bool

func _ready():
	ModulesDataManager.module_placer = self

func model_green():
	preview_mesh.get_active_material(0).set("shader_parameter/instance_color_01", Color("00ff0099"))

func model_red():
	preview_mesh.get_active_material(0).set("shader_parameter/instance_color_01", Color("ff000099"))

var selected_module

func select_module(id):
	for module in ModulesDataManager.module_resources:
		if module.id == id:
			show_preview_module(module)
			selected_module = module
			current_module_fixed_rotation = module.fixed_rotation
			

func show_preview_module(module):
	module_placing_preview.visible = true
	preview_instance = module.object.instantiate()
	preview_mesh.mesh = preview_instance.get_node("mesh").get_child(0).get_child(0).mesh
	
	preview_mesh.set_surface_override_material(0, PLACEMENT_CHECK_MAT)
	model_green()
	
var can_place := false
func check_module_placement():
	if check_current_tile_free() and check_current_tile_supported():
		can_place = true
		model_green()
		return
	can_place = false
	model_red()

func check_current_tile_free() -> bool:
	for tile in ship_builder.occupied_tiles:
		if tile["position"] == hovered_tile:
			return false
	return true

func check_current_tile_supported() -> bool: ##Check that module to place has something around to hold on to
	
	return true

func set_rotation(rotation_index):
	module_selected_rotation = deg_to_rad(90 * rotation_index)

func move_preview(processed_coords):
	if !preview_mesh.mesh:
		return
	hovered_tile = processed_coords
	
	module_placing_preview.position = hovered_tile
	module_placing_preview.rotation = Vector3(0, module_selected_rotation if !current_module_fixed_rotation else 0, 0)
	check_module_placement()


