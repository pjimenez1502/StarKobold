extends Node
class_name overlays_manager

enum TOGGLE_EFFECT { OPEN, CLOSE, TOGGLE}
signal INVENTORY_TOGGLE
signal KOBOLD_TOGGLE
signal SHIP_TOGGLE
signal EDIT_TOGGLE

func _input(event):
	if Input.is_action_just_pressed("HoldInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.OPEN)
	if Input.is_action_just_released("HoldInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.CLOSE)
	if Input.is_action_just_pressed("ToggleInventory"):
		INVENTORY_TOGGLE.emit(TOGGLE_EFFECT.TOGGLE)



func toggle_kobold_overlay(value):
	KOBOLD_TOGGLE.emit(value)

func toggle_ship_overlay(value):
	SHIP_TOGGLE.emit(value)

func toggle_edit_overlay(value):
	EDIT_TOGGLE.emit(value)
