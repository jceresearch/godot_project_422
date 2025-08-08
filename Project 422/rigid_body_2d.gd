
extends RigidBody2D

@export var gravity_force: float = 5.0
@export var player_path: NodePath  # Assign in the editor or dynamically



var player: CharacterBody2D
func log_base(value: float, base: float) -> float:
	return log(value) / log(base)

func _ready():
	player = get_node(player_path)
	gravity_scale = 0  # Disable built-in gravity

func _physics_process(_delta):
	var to_player = player.global_position - global_position
	var distance = to_player.length()
	var impulse = 0
	$Label.text=str(int(distance))
	var direction = to_player.normalized()
	if distance >500:
		impulse = direction * gravity_force/ (distance * .5)
		apply_impulse(impulse)
	elif distance > 100.0:
		impulse = direction * gravity_force /(distance)
		apply_impulse(impulse)
		#apply_central_force(impulse)
	else:
		pass
		#linear_velocity = Vector2.ZERO 
		linear_velocity= linear_velocity
