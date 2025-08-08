extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


@export var target_body: RigidBody2D
@export var player: Node2D

func _draw():
    if target_body and player:
        draw_line(Vector2.ZERO, player.global_position - target_body.global_position, Color.RED)

func _process(delta):
    update()