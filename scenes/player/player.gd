extends CharacterBody2D  # Inherits from CharacterBody2D, a base class for 2D character bodies.

# Declare custom signals for laser and grenade actions.
signal laser(pos, direction)
signal grenade(pos, direction)

# Boolean variables to control the ability to shoot lasers and grenades.
var can_laser: bool = true
var can_grenade: bool = true

@export var max_speed: int = 500  # Maximum speed, settable in the editor.
var speed: int = max_speed  # Current speed of the player.

# Function called when the player is hit.
func hit():
	Globals.health -= 10  # Reduce the global health by 10.

# Called every frame.
func _process(_delta):
	# Handle input for movement.
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()  # Move the player.
	Globals.player_pos = global_position  # Update the global player position.

	# Calculate and set the player's rotation to face the mouse cursor.
	var mouse_pos = get_global_mouse_position()
	var direction_to_mouse = (mouse_pos - global_position).normalized()
	var angle_to_mouse = atan2(direction_to_mouse.y, direction_to_mouse.x)
	var angle_correction = deg_to_rad(90)  # Correct the angle by 90 degrees.
	rotation = angle_to_mouse + angle_correction

	# Handle laser shooting.
	var player_direction = (get_global_mouse_position() - position).normalized()
	if Input.is_action_just_pressed("primary action") and can_laser and Globals.laser_amount > 0:
		Globals.laser_amount -= 1
		$GPUParticles2D.emitting = true  # Start emitting particles.
		var laser_markers = $LaserStartPositions.get_children()
		var selected_laser = laser_markers[randi() % laser_markers.size()]
		can_laser = false
		$Timer.start()  # Start a cooldown timer.
		laser.emit(selected_laser.global_position, player_direction)  # Emit the laser signal.

	# Handle grenade shooting.
	if Input.is_action_just_pressed("secondary action") and can_grenade and Globals.grenade_amount > 0:
		Globals.grenade_amount -= 1
		var grenade_markers = $GrenadeStartPositions.get_children()
		var selected_grenade = grenade_markers[randi() % grenade_markers.size()]
		can_grenade = false
		$GrenadeReoladTimer.start()  # Start the grenade reload timer.
		grenade.emit(selected_grenade.global_position, player_direction)  # Emit the grenade signal.

# Timer signal handlers for laser and grenade reload.
func _on_timer_timeout():
	can_laser = true  # Re-enable laser shooting.

func _on_grenade_reolad_timer_timeout():
	can_grenade = true  # Re-enable grenade shooting.
