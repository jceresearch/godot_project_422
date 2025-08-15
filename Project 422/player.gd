extends CharacterBody2D

@onready var tilemap: TileMapLayer = get_tree().root.get_node("World").get_node("TileMapLayer")
@onready var world=get_tree().root.get_node("World")
@onready var speed_label= get_parent().get_node("Label") as Label


var generator := AudioStreamGenerator.new()
var audio_playback : AudioStreamGeneratorPlayback
var audio_player := AudioStreamPlayer.new()
var audio_is_beeping := false

# For the player movements
var acceleration := 500.0
var friction := 300.0
var max_speed := 500.0

# for pushing around objects
const PUSH_MULT := 1.5		# scale the impulse strength
const MIN_REL_SPEED := 1.0	# ignore tiny nudgesx


func _ready() -> void:
	# Use the project's audio mix rate to avoid resampling
	generator.mix_rate = AudioServer.get_mix_rate()
	generator.buffer_length = 0.1
	add_child(audio_player)
	audio_player.stream = generator
	audio_player.play()
	await get_tree().process_frame
	audio_playback = audio_player.get_stream_playback()
	await get_tree().create_timer(0.3).timeout
	#test bip
	play_bip(440.0,0.15) # 440 Hz, 150 ms

func play_bip(frequency: float, duration: float):
	if audio_is_beeping:
		return
		
	audio_is_beeping = true
	var sample_rate = generator.mix_rate
	var total_samples = int(duration * sample_rate)
	
	
	# Push the whole tone into the generator buffer, but yield if buffer is full.
	var i := 0
	while i < total_samples:
		var space := audio_playback.get_frames_available()
		if space <= 0:
			await get_tree().process_frame
			continue
		var chunk := min(space, total_samples - i) as float
		for j in range(chunk):
			var t := float(i + j) / sample_rate as float
			var s := sin(TAU * frequency * t) * 0.2 as float
			audio_playback.push_frame(Vector2(s, s))
		i += chunk

	# Wait roughly for playback to finish before allowing a new beep
	await get_tree().create_timer(duration, false).timeout
	audio_is_beeping = false
	
	
	

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO
	var tile_coords = tilemap.local_to_map(global_position)
	$Label.text= str( tile_coords[0])+ " , " + str(tile_coords[1])
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized() # Normalize the vector to avoid faster diagonal movement
	var raise_temperature=false as bool
	if input_vector != Vector2.ZERO:
		raise_temperature=true
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		# Apply friction when no input
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	speed_label.text=str(world.world_temperature)
	move_and_slide() 
	
	var collision
	var body
	for i in get_slide_collision_count():
		collision = get_slide_collision(i)
		body = collision.get_collider()
		if body is RigidBody2D:
			_push_rigidbody(body, collision)
			play_bip(300,.1)

			
	if Input.is_key_pressed(KEY_SPACE):
		play_bip(500,0.5)
		raise_temperature=true
		for enemy in get_tree().get_nodes_in_group("tribbles"):
				enemy.target_cell=tilemap._global_to_cell(tilemap,global_position)
	elif Input.is_key_pressed(KEY_1):
		global_position=Vector2(0,0)
		velocity= Vector2(0,0)
		
	if raise_temperature==true:
		world.world_temperature=world.world_temperature_max
	else:
		world.world_temperature=world.world_temperature * world.cool_down_speed
		if world.world_temperature<1:
			world.world_temperature=0
		
func _push_rigidbody(body: RigidBody2D, collision: KinematicCollision2D) -> void:
	# Normal points from RigidBody -> CharacterBody.
	var n := collision.get_normal()
	# Component of our velocity into the body (positive when moving into it).
	var rel_speed := -velocity.dot(n)
	if rel_speed < MIN_REL_SPEED:
		return
	# Impulse magnitude J = m * Δv. Give the RB some of our speed along the normal.
	# Scale up with PUSH_MULT if you want it stronger.
	var j_mag := body.mass * rel_speed * PUSH_MULT
	var impulse := n * j_mag

	# Apply at contact point to also give it torque if off-center.
	var contact_world := collision.get_position()
	body.apply_impulse(impulse, contact_world - body.global_position)
	
				
