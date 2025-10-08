extends RayCast2D


func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	if is_enabled():
		draw_line(Vector2.ZERO, target_position, Color.GREEN, 2.0)