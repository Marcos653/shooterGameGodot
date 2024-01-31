extends CharacterBody2D  # Inherit from CharacterBody2D, a base class for 2D character bodies.

# Define properties of the enemy character.
var active: bool = false  # Indicates if the enemy is active.
var speed: int = 300  # Movement speed of the enemy.
var vulnerable: bool = true  # Indicates if the enemy can be damaged.
var player_near: bool = false  # Flag to check if the player is near.
var health = 20  # Health of the enemy.

# Define the hit() function, called when the enemy takes damage.
func hit():
	if vulnerable:  # Check if the enemy is vulnerable.
		vulnerable = false  # Make the enemy temporarily invulnerable.
		$Timers/HitTimer.start()  # Start a timer for hit vulnerability.
		health -= 10  # Reduce health.
		# Update visual effects to indicate the enemy has been hit.
		$AnimatedSprite2D.material.set_shader_parameter("progress", 0.9)
		$Particles/HitParticles.emitting = true  # Emit hit particles.
		$AudioStreamPlayer2D.play()  # Play a hit sound.

	if health <= 0:  # Check if the enemy's health is depleted.
		await get_tree().create_timer(0.5).timeout  # Wait for 0.5 seconds.
		queue_free()  # Remove the enemy from the scene.

# Process function called every frame.
func _process(_delta):
	var direction = (Globals.player_pos - position).normalized()  # Calculate direction towards the player.
	velocity = direction * speed  # Set the velocity towards the player.

	if active:  # If the enemy is active,
		move_and_slide()  # Move the enemy.
		look_at(Globals.player_pos)  # Make the enemy look at the player.

# Signal handlers for attack and notice areas.
func _on_attack_area_body_entered(_body):
	player_near = true  # Set flag when player enters attack area.
	$AnimatedSprite2D.play("attack")  # Play attack animation.

func _on_attack_area_body_exited(_body):
	player_near = false  # Reset flag when player exits attack area.
	$AnimatedSprite2D.stop()  # Stop the attack animation.

func _on_notice_area_body_entered(_body):
	active = true  # Activate the enemy when the player enters the notice area.
	$AnimatedSprite2D.play("walk")  # Play walking animation.

func _on_notice_area_body_exited(_body):
	active = false  # Deactivate the enemy when the player exits the notice area.
	$AnimatedSprite2D.stop()  # Stop the walking animation.

# Additional signal handlers.
func _on_animated_sprite_2d_animation_finished():
	if player_near:  # If the player is near after an animation finishes,
		Globals.health -= 10  # Reduce the player's health.
		$Timers/AttackTimer.start()  # Start the attack timer.

func _on_hit_timer_timeout():
	vulnerable = true  # Make the enemy vulnerable again after a timeout.
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)  # Reset visual effect.

func _on_attack_timer_timeout():
	$AnimatedSprite2D.play("attack")  # Play attack animation again.
