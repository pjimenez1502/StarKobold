extends Node

signal RESOURCE_UPDATE

signal SHIP_STAT_UPDATE

var no_costs := false

var resources = {
	"credits": 0,
	"scrap": 2000,
	
	"magnetic_elements": 10,
	"electrical_components": 10,
	"baroplastic_segments": 50,
	
	"blastproof_modules": 0,
	"semiconductive_fibers": 0,
	#"": 0,
}

func add_resource(resource, value):
	resources[resource] += value
	update_resource_signal()

func remove_resource(resource, value):
	resources[resource] -= value
	update_resource_signal()

func add_resourcelist(resourcelist):
	for resource in resourcelist:
		resources[resource] += resourcelist[resource]
	update_resource_signal()

func remove_resourcelist(resourcelist):
	for resource in resourcelist:
		resources[resource] -= resourcelist[resource]
	update_resource_signal()

func can_afford(resourcelist) -> bool:
	if no_costs:
		return true
	
	for resource in resourcelist:
		if resources[resource] < resourcelist[resource]:
			return false
	return true

func update_resource_signal():
	RESOURCE_UPDATE.emit(resources)

func _input(event):
	if Input.is_action_just_pressed("(debug)Toggle_NoCosts"):
			no_costs = !no_costs
