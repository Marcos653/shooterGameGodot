extends ItemContainer  # Inherits from ItemContainer, a custom class presumably used for creating item containers in the game.

# Function called when the container is hit.
func hit():
	if not opened:  # Check if the container is not already opened.
		$LidSprite.hide()  # Hide the lid sprite, which represents opening the container.
		$AudioStreamPlayer2D.play()  # Play an audio clip, likely representing the sound of the container opening.
		
		# Get the global position of a marker, presumably for spawning items or effects.
		var pos = $SpawnPositions/Marker2D.global_position
		open.emit(pos, current_direction)  # Emit the 'open' signal with the position and current direction.

		opened = true  # Set the 'opened' flag to true, indicating that the container is now open.
