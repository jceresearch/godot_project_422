extends Node2D



func _ready() -> void:
	spawn_tribbles(5)

func spawn_tribbles(count: int) -> void:
	var original_tribble := $Tribble  # Reference to the existing node
	for i in count:
		print(i)
		var new_tribble := original_tribble.duplicate() as RigidBody2D
		new_tribble.position = Vector2(
		randf_range(100, 500),
		randf_range(100, 500))
		add_child(new_tribble)
		new_tribble.add_to_group("tribbles")
	original_tribble.queue_free()
	
	
	
	
	
	
	
	
	
	
	


