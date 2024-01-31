extends ItemContainer  # Inherit from ItemContainer, a custom class (presumably) representing a container for items.

# Define the 'hit' function, which is presumably called when the container is interacted with or 'hit' in some way.
func hit():
	if not opened:  # Check if the container is not already opened.
		$LidSprite.hide()  # Hide the lid sprite, representing the action of opening the container.
		$AudioStreamPlayer2D.play()  # Play an audio clip, likely representing the sound of the container opening.

		for i in range(5):  # Iterate 5 times, possibly to spawn 5 items or effects.
			# Calculate a random position for spawning items or effects.
			# This is done by selecting a random child of the 'SpawnPositions' node and using its global position.
			var pos = $SpawnPositions.get_child(randi() % $SpawnPositions.get_child_count()).global_position
			open.emit(pos, current_direction)  # Emit the 'open' signal with the position and current direction.

		opened = true  # Set the 'opened' flag to true, indicating that the container is now open.
