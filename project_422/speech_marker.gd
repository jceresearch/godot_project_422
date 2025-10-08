extends Node2D

@onready
var parent=get_parent() as CharacterBody2D


func _ready():
	position = Vector2 (0, -20)

func _physics_process(_delta):
	pass
