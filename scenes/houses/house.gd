extends Area2D  # Inherits from Area2D, a class used for 2D areas that can detect and interact with other physics bodies.

# Define two signals: one for when a body enters the area and another for when a body exits the area.
signal player_entered
signal player_exited

# Function called when a body enters the area.
func _on_body_entered(body):
	player_entered.emit(body)  # Emit the 'player_entered' signal, passing the body that entered.

# Function called when a body exits the area.
func _on_body_exited(body):
	player_exited.emit(body)  # Emit the 'player_exited' signal, passing the body that exited.
