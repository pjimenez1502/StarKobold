extends Node3D
class_name module_properties

@export var behaviours : Array[module_behaviour]

func start_behaviours():
	for module_behaviour in behaviours:
		module_behaviour.engange_property()
