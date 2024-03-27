extends Node
class_name player_resources

var resources = {
	"credits": 0,
	
	"scrap": 0,
	"magnetic_elements": 0,
	"electrical_components": 0,
	"blastproof_modules": 0,
	"polyplastics": 0,
}

func add_resource(resource, value):
	resources[resource] += value

func remove_resource(resource, value):
	resources[resource] -= value

func add_resourcelist(resourcelist):
	for resource in resourcelist:
		resources[resource] += resourcelist[resource]

func remove_resourcelist(resourcelist):
	for resource in resourcelist:
		resources[resource] -= resourcelist[resource]

func can_afford(resourcelist) -> bool:
	for resource in resourcelist:
		if resources[resource] < resourcelist[resource]:
			return false
	return true
