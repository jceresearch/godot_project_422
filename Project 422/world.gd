extends Node2D
#world.gs

var gravity_force= 400.0  as float
var world_temperature = 100 as float
var world_temperature_max=100 as float
var cool_down_speed=1

var nav_region: NavigationRegion2D
var dialogic_layout =null  

@onready var player: CharacterBody2D = get_tree().root.get_node("Game/World/Player")

func _ready() -> void:
	spawn_enemy(5,get_node("Tribble"),"flying", true)
	spawn_enemy(2,get_node("Hunter"),"walking",true)
func spawn_enemy(count: int, original_node, group: String, destroy: bool=true) -> void:
	for i in count:
		var clone = original_node.duplicate() 
		clone.position = Vector2(
		randf_range(100, GM.GAME_SIZE.x),
		randf_range(100, GM.GAME_SIZE.y))
		add_child(clone)
		clone.add_to_group(group)
	if destroy:
		original_node.queue_free()

			

	
	
	
	
