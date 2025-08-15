extends Node2D

@export var gravity_force= 5.0  as float
var world_temperature = 100 as float
@export var world_temperature_max=100 as float
@export var cool_down_speed=.95

func _ready() -> void:
	spawn_tribbles(5)

func spawn_tribbles(count: int) -> void:
	var original_tribble := $Tribble  # Reference to the existing node
	for i in count:
		var new_tribble := original_tribble.duplicate() as RigidBody2D
		new_tribble.position = Vector2(
		randf_range(100, 500),
		randf_range(100, 500))
		add_child(new_tribble)
		new_tribble.add_to_group("tribbles")
	original_tribble.queue_free()
	
	
	
	
	
	
	
	
	
	
	
