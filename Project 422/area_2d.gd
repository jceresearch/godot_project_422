extends Area2D


@export var attracting_node: Node2D  # Assign the node to be attracted to in the inspector

@export var gravity_strength = 100  # Adjust as needed

func _ready():
    gravity_space_override = PhysicsServer2D.SPACE_OVERRIDE_REPLACE
    gravity_point = true
    gravity_vec = gravity_direction * gravity_strength



func _on_body_entered(body: Node2D):
    print("Debug Body entered:", body.name)
    if body is RigidBody2D:
        var direction = (attracting_node.global_position - body.global_position).normalized()
        #body.apply_central_impulse(direction * 100)  # Adjust force as needed