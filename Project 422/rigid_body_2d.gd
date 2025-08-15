
extends RigidBody2D
@onready
var tilemap: TileMapLayer = get_tree().root.get_node("World").get_node("TileMapLayer")

@onready
var world=get_tree().root.get_node("World")

@onready
var player = get_tree().root.get_node("World").get_node("Player") as CharacterBody2D

@onready
var target_cell: Vector2i = Vector2i(0,0)

func _ready():
	gravity_scale = 0  # Disable built-in gravity
	target_cell=tilemap._global_to_cell(tilemap,global_position)


func _physics_process(_delta):
	if world.world_temperature<=0:
		linear_velocity=Vector2(0,0)
		return
	var target_cell_global: Vector2 = tilemap._cell_to_global(tilemap,target_cell)
	var to_target= target_cell_global - global_position
	var distance=to_target.length()
	var impulse = 0.0 as float
	var temperature= world.world_temperature/world.world_temperature_max
	$Label.text="Distance:" + str(int(distance)) + " Target "+ str(target_cell[0])+ " , " + str(target_cell[1])
	var direction = to_target.normalized()
	if distance >500:
		impulse = direction * temperature* world.gravity_force /distance
		apply_impulse(impulse)
	elif distance > 10.0:
		impulse = direction * temperature * world.gravity_force /(distance)
		apply_impulse(impulse)
		#apply_central_force(impulse)
	else:		
		pass
