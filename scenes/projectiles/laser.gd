extends Area2D  # Inherits from Area2D, which is used for creating 2D areas that can detect and interact with other bodies.

@export var speed: int = 1000  # Export the speed variable, allowing it to be set in the Godot Editor. Default value is 1000.
var direction: Vector2 = Vector2.UP  # Set the initial movement direction to upwards.

func _ready():
	$SelfDestructTimer.start()  # Start the self-destruct timer upon the node entering the scene.

func _process(delta):
	position += direction * speed * delta  # Update the position based on the speed and direction. Delta is the time since the last frame.

func _on_body_entered(body):
	if "hit" in body:
		body.hit()  # If the entered body has a 'hit' method, call it.

	queue_free()  # Remove the object from the scene after interacting with a body.

func _on_self_destruct_timer_timeout():
	queue_free()  # Remove the object from the scene when the self-destruct timer times out.
