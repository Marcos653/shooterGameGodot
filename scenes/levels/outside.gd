extends LevelParent  # Inherits from LevelParent, a custom class presumably used for managing level-specific logic.

# Function triggered when a player enters the gate area.
func _on_gate_player_entered_gate(_body):
	var tween = create_tween()  # Create a new Tween instance.
	# Tween the player's speed property to 0 over 0.5 seconds for a smooth slowdown effect.
	tween.tween_property($Player, "speed", 0, 0.5)
	# Change the scene to 'inside.tscn' after the player enters the gate area.
	TransitionLayer.change_scene("res://scenes/levels/inside.tscn")

# Function triggered when a player enters a specified house area.
func _on_house_player_entered(_body):
	var tween = get_tree().create_tween()  # Create a Tween instance using the SceneTree.
	# Tween the camera's zoom to Vector2(1, 1) over 1 second to reset the zoom to normal.
	tween.tween_property($Player/Camera2D, "zoom", Vector2(1, 1), 1)

# Function triggered when a player exits the house area.
func _on_house_player_exited(_body):
	var tween = get_tree().create_tween()  # Create another Tween instance using the SceneTree.
	# Tween the camera's zoom to Vector2(0.6, 0.6) over 1 second for a zoomed-out effect.
	tween.tween_property($Player/Camera2D, "zoom", Vector2(0.6, 0.6), 1)
