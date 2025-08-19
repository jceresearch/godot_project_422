extends Node2D

var gravity_force= 400.0  as float
var world_temperature = 100 as float
var world_temperature_max=100 as float
var cool_down_speed=1

var nav_region: NavigationRegion2D
var dialogic_layout =null  

func _ready() -> void:
	
	var player=$Player
	dialogic_layout=Dialogic.start("timeline_player")
	dialogic_layout.register_character("res://dialogic_assets/dlg_character_player.dch",player.get_node("speech_marker"))
	

	
	
	
	
	
	spawn_enemy(5,get_node("Tribble"),"flying", true)
	spawn_enemy(2,get_node("Hunter"),"walking",true)
	

	# Create NavigationRegion2D
	nav_region = $NavigationRegion2D


	# Create a NavigationPolygon that is a big rectangle
	var nav_poly := NavigationPolygon.new()
	var outline := [
		Vector2(0, 0),
		Vector2(GM.GAME_SIZE.x, 0),
		Vector2(GM.GAME_SIZE.x, GM.GAME_SIZE.y),
		Vector2(0, GM.GAME_SIZE.y)
	]
	nav_poly.add_outline(outline)
	nav_poly.make_polygons_from_outlines()
	nav_region.navigation_polygon = nav_poly

	

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

			

	
	
	
	
	
	
	
