extends CharacterBody2D
#hunter.gs


var vision_distance: float = 700.0
const MAX_SPEED: float = 200.0
var acceleration: float = 100.0
var friction: float =200.0
@onready var tilemap: TileMapLayer = get_tree().root.get_node("MainScene/World/TileMapLayer")
@onready var world=get_tree().root.get_node("MainScene/World") 
@onready var hud : Control = get_tree().root.get_node("MainScene/HUD/HUDRoot")
@onready var player: CharacterBody2D = get_tree().root.get_node("MainScene/World/Player")
@onready var ray: RayCast2D = $RayCast2D
@onready var agent: NavigationAgent2D = $NavigationAgent2D
var default_color
var bounce_cooldown := 0.0
func _ready():

	default_color = $Sprite2D.modulate

	# Configure our raycast range
	ray.target_position.x = vision_distance
	
	# Setup NavAgent
	agent.target_desired_distance = 100
	agent.path_changed.connect(_on_path_computed)
	motion_mode=MOTION_MODE_FLOATING
	$hitbox.body_entered.connect(_on_Hitbox_body_entered)
	
func _physics_process(delta):
	
	# Aim the ray toward the player
	var direction_to_target: Vector2 =(player.global_position - global_position)
	ray.target_position = direction_to_target.limit_length(vision_distance)
	ray.force_raycast_update()
	var distance_to_target: float = direction_to_target.length()
		

	if ray.is_colliding() and ray.get_collider() == player:
		# player seen → set path
		agent.set_target_position(player.global_position)
		
		$Sprite2D.modulate = Color.RED
	else:
		# lost sight → optional: wander or stop
		$Sprite2D.modulate = default_color

	if bounce_cooldown > 0:
		bounce_cooldown -= delta
	else:

		if not agent.is_navigation_finished():
			var next_point: Vector2 = agent.get_next_path_position()
			var direction := (next_point - global_position).normalized()
			velocity += direction * acceleration * delta
			velocity = velocity.limit_length(MAX_SPEED)

		else:
			pass
		

	$Label.text=str(int(distance_to_target))


	move_and_slide()
	
func _on_path_computed():
	# NavAgent path was calculated
	pass

var bounce_force = 10.0

func _on_Hitbox_body_entered(body):
	if body == player:
		print("bounce back")
		var away = (global_position - player.global_position).normalized()
		velocity += away * bounce_force
		bounce_cooldown = 0.1 # enemy will move backwards for 0.2s
