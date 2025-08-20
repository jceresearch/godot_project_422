extends CharacterBody2D
class_name Player

@onready var tilemap: TileMapLayer = get_tree().root.get_node("Game/World/TileMapLayer")
@onready var world=get_tree().root.get_node("Game/World") 
@onready var hud : Control = get_tree().root.get_node("Game/HUD/HUDRoot")


# For the player movements
var acceleration := 1000.0
var friction := 100.0
var max_speed := 400.0

# for pushing around objects
const PUSH_MULT := 300		# scale the impulse strength
const PUSH_MULT_CHARACTERBODY2D:=500
const MIN_REL_SPEED := 1.0	# ignore tiny nudgesx
const MAX_PUSH_FORCE=300

func _ready() -> void:
	# Use the project's audio mix rate to avoid resampling
	motion_mode=MOTION_MODE_FLOATING
	
	var dialogic_layout=Dialogic.start("res://dialogic_assets/player_timeline.dtl")
	var speech_marker = get_tree().root.get_node("Game/World/Player/speech_marker")
	#var speech_marker= get_node("speech_marker")
	var player_character=load("res://dialogic_assets/character_player.dch")
	dialogic_layout.register_character(player_character,speech_marker)
	
	


func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	#var tile_coords = tilemap.local_to_map(global_position)
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized() # Normalize the vector to avoid faster diagonal movement
	var raise_temperature=false as bool
	if input_vector != Vector2.ZERO:
		raise_temperature=true
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	#$Label.text= (str( tile_coords[0])+ " , " + str(tile_coords[1]))
	$Label.text=str(global_position)
	hud.update_debug(str(int(world.world_temperature)))
	
	

	move_and_slide() 

	global_position.x = clamp(global_position.x, 0.0, GM.GAME_SIZE.x)
	global_position.y = clamp(global_position.y, 0.0, GM.GAME_SIZE.y)
	var collision
	var body
	for i in get_slide_collision_count():
		collision = get_slide_collision(i)
		body = collision.get_collider()
		if body is RigidBody2D:
			_push_rigidbody(body, collision)
			GM.play_bip(300,.1)
		elif body is CharacterBody2D:
			_push_characterbody(body, collision)
			
	if  Input.is_action_just_pressed("Fire"):
		GM.play_bip(500,0.5)
		raise_temperature=true
		for enemy in get_tree().get_nodes_in_group("enemy"):
			enemy.target_cell=tilemap._global_to_cell(tilemap,global_position)
	elif  Input.is_action_just_pressed("Reposition"):
		global_position=Vector2(100,100)
		velocity= Vector2(0,0)
		
	if raise_temperature==true:
		world.world_temperature=world.world_temperature_max
	else:
		world.world_temperature=world.world_temperature * world.cool_down_speed
		if world.world_temperature<1:
			world.world_temperature=0
		
func _push_rigidbody(body: RigidBody2D, collision: KinematicCollision2D) -> void:
	# Normal points from RigidBody -> CharacterBody.
	var normal := collision.get_normal()
	# Component of our velocity into the body (positive when moving into it).
	var rel_speed := -velocity.dot(normal)
	if rel_speed < MIN_REL_SPEED:
		return
	# Impulse magnitude J = m * Δv. Give the RB some of our speed along the normal.
	# Scale up with PUSH_MULT if you want it stronger.
	var j_mag := body.mass * rel_speed * PUSH_MULT
	var impulse := normal * j_mag
	if impulse.length() > MAX_PUSH_FORCE:
		impulse = impulse.normalized() * MAX_PUSH_FORCE


	# Apply at contact point to also give it torque if off-center.
	var contact_world := collision.get_position()
	body.apply_impulse(impulse, contact_world - body.global_position)

func _push_characterbody(enemy: CharacterBody2D, collision: KinematicCollision2D) -> void:
	# Normal points from enemy -> player
	var n := collision.get_normal()

	# Component of our velocity into the enemy (positive when moving into it)
	var rel_speed := -velocity.dot(n)
	if rel_speed < MIN_REL_SPEED:
		return
	# Calculate the push vector (impulse)
	var push_vector := n * rel_speed * PUSH_MULT_CHARACTERBODY2D
	if push_vector.length() > MAX_PUSH_FORCE:
		push_vector = push_vector.normalized() * MAX_PUSH_FORCE

	# Apply to the enemy’s velocity
	enemy.velocity += push_vector
				
