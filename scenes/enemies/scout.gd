extends CharacterBody2D  # Inherits from CharacterBody2D, a base class for 2D character bodies.

# Declare variables for the character's state and abilities.
var player_nearby: bool = false  # Flag to check if the player is nearby.
var can_laser: bool = true  # Boolean to control if the character can use its laser attack.
var right_gun_use: bool = true  # Toggle between different guns for laser firing.
var health: int = 30  # Health of the character.
var vulnerable: bool = true  # Boolean to track if the character is vulnerable to attacks.

signal laser(pos, direction)  # Declare a signal for the laser attack.

# Function called when the character is hit.
func hit():
	if vulnerable:
		health -= 10  # Reduce health by 10.
		vulnerable = false  # Make the character temporarily invulnerable.
		$Timers/HitTimer.start()  # Start a timer for vulnerability cooldown.
		$Sprite2D.material.set_shader_parameter("progress", 1)  # Update shader parameter for visual effect.
		$HitSound.play()  # Play a sound effect for being hit.
		
		if health <= 0:
			await get_tree().create_timer(0.5).timeout  # Wait for 0.5 seconds.
			queue_free()  # Remove the character from the scene.

# Called every frame.
func _process(_delta):
	if player_nearby:
		look_at(Globals.player_pos)  # Face towards the player.

		if can_laser:
			# Determine which gun to use and alternate it.
			var marker_node = $LaserSpawnPositions.get_child(right_gun_use)
			right_gun_use = not right_gun_use  # Toggle the gun use for next time.
			var pos: Vector2 = marker_node.global_position
			var direction: Vector2 = (Globals.player_pos - position).normalized()
			laser.emit(pos, direction)  # Emit the laser signal.
			can_laser = false  # Disable laser attack temporarily.
			$Timers/LaserCooldown.start()  # Start the laser cooldown timer.

# Signal handlers for the attack area.
func _on_attack_area_body_entered(_body):
	player_nearby = true  # Set flag when player enters the attack area.

func _on_attack_area_body_exited(_body):
	player_nearby = false  # Reset flag when player exits the attack area.

# Timer signal handler for laser cooldown.
func _on_laser_cooldown_timeout():
	can_laser = true  # Re-enable laser attack.

# Timer signal handler for hit vulnerability.
func _on_hit_timer_timeout():
	vulnerable = true  # Make the character vulnerable again.
	$Sprite2D.material.set_shader_parameter("progress", 0)  # Reset shader parameter.
