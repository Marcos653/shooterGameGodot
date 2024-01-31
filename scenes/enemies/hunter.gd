extends CharacterBody2D  # Inherit from CharacterBody2D, a base class for 2D character bodies in Godot.

# Declare variables for the character's state and properties.
var active: bool = false  # Indicates whether the character is active.
var speed: int = 200  # Movement speed of the character.
var player_near: bool = false  # Flag to check if the player is near.
var vulnerable: bool = true  # Indicates if the character can take damage.
var health: int = 100  # Health of the character.

# Called when the node is added to the scene.
func _ready():
	$NavigationAgent2D.path_desired_distance = 4.0
	$NavigationAgent2D.target_desired_distance = 4.0
	$NavigationAgent2D.target_position = Globals.player_pos  # Set the initial target position to the player's position.

# Called every physics frame.
func _physics_process(_delta):
	if active:  # If the character is active,
		var next_path_pos: Vector2 = $NavigationAgent2D.get_next_path_position()  # Get the next position on the path.
		var direction: Vector2 = (next_path_pos - global_position).normalized()  # Calculate direction to the next path position.
		velocity = direction * speed  # Set the velocity in the calculated direction.
		move_and_slide()  # Move the character.
		var look_angle = direction.angle()  # Calculate the angle to look in the direction of movement.
		rotation = look_angle + PI / 2  # Rotate the character to face the direction of movement.

# Signal handlers for the notice area.
func _on_notice_area_body_entered(_body):
	active = true  # Activate the character when the player enters the notice area.
	$AnimationPlayer.play("walk")  # Play walking animation.

func _on_notice_area_body_exited(_body):
	active = false  # Deactivate the character when the player exits the notice area.

# Timer signal handler for navigation.
func _on_navigation_timer_timeout():
	if active:  # If the character is active,
		$NavigationAgent2D.target_position = Globals.player_pos  # Update the target position to the player's position.

# Signal handlers for the attack area.
func _on_attack_area_body_entered(_body):
	player_near = true  # Set flag when player enters the attack area.
	$AnimationPlayer.play("attack")  # Play attack animation.

func _on_attack_area_body_exited(_body):
	player_near = false  # Reset flag when player exits the attack area.

# Function to handle attacks.
func attack():
	if player_near:  # If the player is near,
		Globals.health -= 20  # Reduce the player's health.

# Function to handle being hit.
func hit():
	if vulnerable:  # If the character is vulnerable,
		health -= 10  # Reduce health.
		$Timers/HitTimer.start()  # Start hit timer.

	if health <= 0:  # If health is depleted,
		queue_free()  # Remove the character from the scene.

# Timer signal handler for hit vulnerability.
func _on_hit_timer_timeout():
	vulnerable = true  # Make the character vulnerable again.
