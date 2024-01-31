extends StaticBody2D  # Inherits from StaticBody2D, typically used for non-moving game objects that interact with physics bodies.

# Define two signals for when a body enters or exits the gate.
signal player_entered_gate(body)
signal player_exited_gate(body)

# Function called when a body enters the associated area.
func _on_area_2d_body_entered(body):
	player_entered_gate.emit(body)  # Emit the 'player_entered_gate' signal, passing along the body that entered.

# Function called when a body exits the associated area.
func _on_area_2d_body_exited(body):
	player_exited_gate.emit(body)  # Emit the 'player_exited_gate' signal, passing along the body that exited.
