extends Node

@onready var debug_coords = %DebugCoords

func _physics_process(delta):
	shop_ship_coords()

func shop_ship_coords():
	if !DebugManager.player_ship:
		return
	debug_coords.text = str(DebugManager.player_ship.position)
	
