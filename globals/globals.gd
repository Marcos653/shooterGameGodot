extends Node  # Inherit from the Node class, which is a fundamental building block in Godot.

signal stat_change  # Define a custom signal 'stat_change' to notify other parts of your game about changes in stats.

# Declare and initialize an AudioStreamPlayer2D object to handle sound effects related to the player.
var player_hit_sound: AudioStreamPlayer2D  

var laser_amount = 20:  # Set initial amount of lasers.
	set(value):  # Setter for laser_amount. Called whenever the value of laser_amount is changed.
		laser_amount = value  # Update the laser amount.
		stat_change.emit()  # Emit the 'stat_change' signal to indicate a change in stats.

var grenade_amount = 5:  # Set initial amount of grenades.
	set(value):  # Setter for grenade_amount.
		grenade_amount = value  # Update the grenade amount.
		stat_change.emit()  # Emit the 'stat_change' signal.

var player_vulnerable: bool = true  # Boolean variable indicating whether the player is vulnerable or not.
var health = 60:  # Player's health, with a default value of 60.
	set(value):  # Setter for the health variable.
		if value > health:  # If the new health is greater than the current health,
			health = min(value, 100)  # Set health to the lesser of the new value or 100.
		else:  # If the new health is less or equal to the current health,
			if player_vulnerable:  # And if the player is vulnerable,
				health = value  # Update the health.
				player_vulnerable = false  # Make the player invulnerable temporarily.
				player_invulnerable_timer()  # Start a timer for invulnerability duration.
				player_hit_sound.play()  # Play the hit sound.

		stat_change.emit()  # Emit the 'stat_change' signal.

var player_pos: Vector2  # Variable to store the player's position.

func player_invulnerable_timer():
	await get_tree().create_timer(0.5).timeout  # Await a timeout of 0.5 seconds.
	player_vulnerable = true  # After the timeout, set the player back to vulnerable.

func _ready():  # Called when the node enters the scene tree.
	player_hit_sound = AudioStreamPlayer2D.new()  # Create a new AudioStreamPlayer2D instance.
	player_hit_sound.stream = load("res://audio/solid_impact.ogg")  # Load the audio file for the hit sound.
	add_child(player_hit_sound)  # Add the AudioStreamPlayer2D as a child to this node.
