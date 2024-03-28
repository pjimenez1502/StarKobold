extends Node
class_name player_resources

signal RESOURCE_UPDATE

var resources = {
	"credits": 0,
	
	"scrap": 100,
	"magnetic_elements": 0,
	"electrical_components": 0,
	"blastproof_modules": 0,
	"polyplastics": 0,
}

#@export var initial_resources = {
	#"credits": 0,
	#"scrap": 0,
	#"magnetic_elements": 0,
	#"electrical_components": 0,
	#"blastproof_modules": 0,
	#"polyplastics": 0,
#}

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
	for resource in resourcelist:
		if resources[resource] < resourcelist[resource]:
			return false
	return true

func update_resource_signal():
	RESOURCE_UPDATE.emit(resources)
