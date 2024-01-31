extends LevelParent  # Inherits from LevelParent, a custom class presumably used for managing level-specific logic.

# Signal handler for when a body enters the exit gate area.
func _on_exit_gate_area_body_entered(_body):
	var tween = create_tween()  # Create a new Tween instance.
	# Tween the player's speed property to 0 over 0.5 seconds. This gradually slows down the player.
	tween.tween_property($Player, "speed", 0, 0.5)
	# Change the scene to 'outside.tscn' after the player enters the exit gate area.
	TransitionLayer.change_scene("res://scenes/levels/outside.tscn")
