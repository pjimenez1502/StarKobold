extends Node

signal RESOURCE_UPDATE

signal SHIP_STAT_UPDATE
signal SHIP_CALCULATE_POWER

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

var module_return_chance := 20 ## chance in % of resources to recover
func return_resources(module_costs):
	var returned_resources = {
	"credits": 0,
	"scrap": 0,
	"magnetic_elements": 0,
	"electrical_components": 0,
	"baroplastic_segments": 0,
	"blastproof_modules": 0,
	"semiconductive_fibers": 0,
	#"": 0,
	}
	for resource in module_costs:
		if module_costs[resource] == 0:
			continue
		for i in range(0,module_costs[resource]):
			if randi_range(0, 100) <= module_return_chance: 
				returned_resources[resource] += 1
	print("RETURNED: ", returned_resources)
func update_resource_signal():
	RESOURCE_UPDATE.emit(resources)

func _input(event):
	if Input.is_action_just_pressed("(debug)Toggle_NoCosts"):
			no_costs = !no_costs
