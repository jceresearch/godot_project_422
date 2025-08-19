extends TileMapLayer
@onready var tile_map_layer:TileMapLayer = self
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	var cell_size: Vector2 = self.tile_set.tile_size
	# Move origin by half a tile to center the grid
	position = -cell_size / 2.0
	generate()

func generate():
	for x in range(50,100):
		for y in range(50,100):
			tile_map_layer.set_cell(Vector2i(x, y),1,Vector2i(5, 0),0)
			

#set_cell(coords: Vector2i, source_id: int = -1, atlas_coords: Vector2i = Vector2i(-1, -1), alternative_tile: int = 0)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# node_global_pos is a Vector2 (e.g., some_node.global_position)
# tilemap can be a TileMap or a TileMapLayer
func _global_to_cell(tilemap: Node, node_global_pos: Vector2) -> Vector2i:
	return tilemap.local_to_map(tilemap.to_local(node_global_pos))
# cell is a Vector2i (tile coords)
func _cell_to_global(tilemap: Node, cell: Vector2i) -> Vector2:
	return tilemap.to_global(tilemap.map_to_local(cell))
