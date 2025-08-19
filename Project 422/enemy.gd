
extends RigidBody2D

var target_cell: Vector2i = Vector2i(0,0)
var max_speed: float = 400.0
var slowing_strength: float = 1.0  # Higher = stronger drag when over speed

@onready var tilemap: TileMapLayer = get_tree().root.get_node("Game/World/TileMapLayer")
@onready var world=get_tree().root.get_node("Game/World") 
@onready var hud : Control = get_tree().root.get_node("Game/HUD/HUDRoot")


func _ready():
	add_to_group("enemy")
	gravity_scale = 0  # Disable built-in gravity
	target_cell=tilemap._global_to_cell(tilemap,global_position)


func _physics_process(_delta):
	if world.world_temperature<=1:
		linear_velocity=Vector2.ZERO
		$Label.text= str(linear_velocity.length())
		return
	var target_cell_global: Vector2 = tilemap._cell_to_global(tilemap,target_cell)
	var to_target= target_cell_global - global_position
	var distance=to_target.length()
	var impulse : Vector2
	var temperature= world.world_temperature/world.world_temperature_max
	var current_speed= linear_velocity.length() as float
	var direction = to_target.normalized()

	if current_speed> max_speed:
		var excess_ratio = (current_speed - max_speed) / current_speed
		var slowdown = linear_velocity * excess_ratio * slowing_strength
		linear_velocity -= slowdown
	if distance >500:
		impulse = direction * temperature * world.gravity_force /distance
		apply_impulse(impulse)
	elif distance > 10.0:
		impulse = direction * temperature * world.gravity_force /(distance)
		apply_impulse(impulse)
		#apply_central_force(impulse) # this is the nudge mode
	else:		
		pass
		
	#$Label.text="D:" + str(int(distance)) + \
	#" T: " + str(target_cell[0]) + " , " + str(target_cell[1]) + \
	#" V: "+ str(int(current_speed))
	
	$Label.text= str(linear_velocity.length())
	#$Label.text=str(int(linear_velocity[0]))+","+str(int(linear_velocity[1]))
