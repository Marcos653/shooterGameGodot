extends CharacterBody2D  # Inherits from CharacterBody2D, a base class for 2D character bodies in Godot.

# Declare variables for state and properties.
var active: bool = false  # Indicates whether the drone is active.
var max_speed: int = 600  # The maximum speed of the drone.
var speed: int = 0  # Current speed of the drone.
var speed_multiplier: int = 1  # Multiplier for speed adjustment.

var vulnerable: bool = true  # Indicates if the drone can take damage.
var health: int = 50  # Health of the drone.

var explosion_active: bool = false  # Flag to track if an explosion is active.

# Called when the node is added to the scene.
func _ready():
	$Explosion.hide()  # Initially hide the explosion sprite.
	$DroneImage.show()  # Show the drone image.

# Called every frame.
func _process(delta):
	if active:  # If the drone is active,
		look_at(Globals.player_pos)  # Make the drone face the player.
		var direction = (Globals.player_pos - position).normalized()  # Calculate direction towards the player.
		velocity = direction * speed  # Set the velocity in the calculated direction.
		var collision = move_and_collide(velocity * delta)  # Move the drone and check for collisions.

		if collision:  # If a collision occurs,
			$AnimationPlayer.play("explosion")  # Play explosion animation.
			explosion_active = true  # Set explosion flag to true.

		if explosion_active:  # If an explosion is active,
			# Gather all nodes in groups 'Container' and 'Entity'.
			var targets = get_tree().get_nodes_in_group("Container") + get_tree().get_nodes_in_group("Entity")
			for target in targets:  # Iterate over each target.
				var in_range = target.global_position.distance_to(global_position) < 400  # Check if target is within range.

				if in_range and "hit" in target:  # If target is in range and has a 'hit' method,
					target.hit()  # Call the target's hit method.

# Handles being hit.
func hit():
	if vulnerable:  # If the drone is vulnerable,
		health -= 10  # Reduce health.
		vulnerable = false  # Set vulnerability to false.
		$Timers/HitTimer.start()  # Start hit timer.
		# Update visual effects to indicate damage.
		$DroneImage.material.set_shader_parameter("progress", 0.9)
		$Sounds/HitSound.play()  # Play hit sound.

	if health <= 0:  # If health is depleted,
		$AnimationPlayer.play("explosion")  # Play explosion animation.
		explosion_active = true  # Set explosion flag to true.

func stop_movement():
	speed_multiplier = 0  # Stop the drone's movement.

# Signal handler for entering the notice area.
func _on_notice_area_body_entered(_body):
	active = true  # Activate the drone.
	var tween = create_tween()  # Create a tween.
	tween.tween_property(self, "speed", max_speed, 6)  # Tween the speed to max_speed over 6 seconds.

# Signal handler for hit timer timeout.
func _on_hit_timer_timeout():
	vulnerable = true  # Make the drone vulnerable again.
	$DroneImage.material.set_shader_parameter("progress", 0)  # Reset shader parameter for visual effects.
