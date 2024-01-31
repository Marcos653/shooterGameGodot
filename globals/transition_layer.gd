extends CanvasLayer  # Inherits from CanvasLayer, typically used for UI elements and layering in Godot.

# Function to change the scene with a fade-to-black animation.
func change_scene(target: String) -> void:
	$AnimationPlayer.play("fade_to_black")  # Start playing the fade-to-black animation.
	await $AnimationPlayer.animation_finished  # Wait until the animation is finished.
	get_tree().change_scene_to_file(target)  # Change the scene to the specified target.
	$AnimationPlayer.play_backwards("fade_to_black")  # Play the fade-to-black animation in reverse.
