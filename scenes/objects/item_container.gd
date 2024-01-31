extends StaticBody2D  # Inherit from StaticBody2D, which is used for non-moving game objects.

class_name ItemContainer  # Define a new class named ItemContainer. This allows the script to be used as a custom type in the editor.

@onready var current_direction: Vector2 = Vector2.DOWN.rotated(rotation)
# Initialize current_direction as a Vector2 pointing downwards, rotated by the object's current rotation.
# This is likely used to determine the direction in which items will be dispensed or effects will occur when the container is opened.

var opened: bool = false  # A boolean flag to track whether the container has been opened.

signal open(pos, direction)
# Define a custom signal named 'open'. This signal can be emitted with a position and direction, presumably when the container is opened.
