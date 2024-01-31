extends RigidBody2D  # Inherit from RigidBody2D, a class for physics-based 2D body.

const speed: int = 750  # Constant speed value for the object.
var explosion_active: bool = false  # Flag to track if an explosion has been activated.
var explosion_radius: int = 400  # Radius within which the explosion affects other objects.

# Function to handle the explosion.
func explode():
	$AnimationPlayer.play('Explosion')  # Play the explosion animation.
	explosion_active = true  # Set the explosion flag to true.

# Called every frame.
func _process(_delta):
	if explosion_active:  # Check if the explosion is active.
		# Gather all nodes in groups 'Container' and 'Entity'.
		var targets = get_tree().get_nodes_in_group('Container') + get_tree().get_nodes_in_group('Entity')

		for target in targets:  # Iterate through each target.
			# Calculate if the target is within the explosion radius.
			var in_range = target.global_position.distance_to(global_position) < explosion_radius

			# If the target has a 'hit' method and is in range,
			if "hit" in target and in_range:
				target.hit()  # Call the target's hit method.
