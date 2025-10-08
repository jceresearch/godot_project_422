extends Node2D
@export var nav_root_path: NodePath	# point this at your Navigation2D node in the scene

@onready var world=get_tree().root.get_node("Game/World") 

func _ready() -> void:
	var region := _create_nav_region_rect(Vector2(0, 0), Vector2(GM.GAME_SIZE.x, GM.GAME_SIZE.y))
	self.add_child(region)

	# If you need to toggle it later:
	# region.enabled = false

func _create_nav_region_rect(top_left: Vector2, size: Vector2) -> NavigationRegion2D:
	var region := NavigationRegion2D.new()
	region.position = top_left	# transform applies to the polygon
	var poly := NavigationPolygon.new()
	var outline := PackedVector2Array([
		Vector2.ZERO,
		Vector2(size.x, 0.0),
		size,
		Vector2(0.0, size.y)
	])
	poly.add_outline(outline)
	poly.make_polygons_from_outlines()	# bake triangulation
	region.navigation_polygon = poly
	region.enabled = true
	region.visibility_layer=1
	return region
	
	
	
	



	