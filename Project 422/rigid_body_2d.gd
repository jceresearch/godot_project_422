
extends RigidBody2D
@onready
var tilemap: TileMapLayer = get_parent().get_node("TileMapLayer")
@export var gravity_force: float = 10
@export var player_path: NodePath  # Assign in the editor or dynamically
@onready
var target_cell: Vector2i = tilemap._global_to_cell(tilemap,global_position)


var player: CharacterBody2D
func log_base(value: float, base: float) -> float:
	return log(value) / log(base)

func _ready():
	player = get_node(player_path)
	gravity_scale = 0  # Disable built-in gravity


func _physics_process(_delta):
	var target_cell_global: Vector2 = tilemap._cell_to_global(tilemap,target_cell)
	var to_target= target_cell_global - global_position
	var distance=to_target.length()
	var impulse = 0
	$Label.text="Distance:" + str(int(distance)) + " Target "+ str(target_cell[0])+ " , " + str(target_cell[1])
	var direction = to_target.normalized()
	if distance >500:
		impulse = direction * gravity_force /distance
		apply_impulse(impulse)
	elif distance > 10.0:
		impulse = direction * gravity_force /(distance)
		apply_impulse(impulse)
		#apply_central_force(impulse)
	else:
		
		pass
