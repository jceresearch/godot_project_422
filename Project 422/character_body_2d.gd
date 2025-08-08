extends CharacterBody2D

# Speed of the character in pixels per second
@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var input_vector := Vector2.ZERO

	# Get input from arrow keys or WASD
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	# Normalize the vector to avoid faster diagonal movement
	input_vector = input_vector.normalized()

	# Set velocity and move
	velocity = input_vector * speed
	move_and_slide()