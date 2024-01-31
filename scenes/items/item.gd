extends Area2D  # Inherits from Area2D, a class used for creating 2D detection areas in Godot.

var rotation_speed: int = 3  # Speed at which the object will rotate.
# Dictionary with item types and their respective probabilities (weights).
var available_options: Dictionary = {'laser': 50, 'grenade': 25, 'health': 25}
var type: String = weighted_choice(available_options)  # Determines the type of the item based on weights.

var direction: Vector2  # Direction in which the item will move.
var distance: int = randi_range(150, 250)  # Random distance for item movement.

# Called when the node enters the scene tree.
func _ready():
	# Change the color of the Sprite2D based on the item type.
	if type == 'laser':
		$Sprite2D.modulate = Color(0.1, 0.2, 0.8)  # Blue for laser.
		
	if type == 'grenade':
		$Sprite2D.modulate = Color(0.8, 0.2, 0.1)  # Red for grenade.

	if type == 'health':
		$Sprite2D.modulate = Color(0.1, 0.8, 0.1)  # Green for health.
		
	# Tween for movement and scaling.
	var target_pos = position + direction * distance  # Calculate target position.
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", target_pos, 0.5)  # Move to target position.
	tween.tween_property(self, "scale", Vector2(1, 1), 0.3).from(Vector2(0, 0))  # Scale up from 0 to 1.

# Called every frame; handles rotation.
func _process(delta):
	rotation += rotation_speed * delta  # Increment rotation.

# Function to choose an item type based on weighted probability.
func weighted_choice(weights_dict: Dictionary) -> String:
	var total_weight: int = 0
	# Calculate the total weight.
	for weight in weights_dict.values():
		total_weight += weight
	var random_num: int = randi() % total_weight
	var weight_sum: int = 0

	# Determine the item type based on the random number and weights.
	for key in weights_dict.keys():
		weight_sum += weights_dict[key]
		if random_num < weight_sum:
			return key
	return ""  # Fallback if something goes wrong.

# Signal handler for when a body enters the area.
func _on_body_entered(_body):
	# Increase the corresponding global item count based on the type.
	if type == 'laser':
		Globals.laser_amount += 5  # Increase laser amount.
		
	if type == 'grenade':
		Globals.grenade_amount += 1  # Increase grenade amount.
	
	if type == 'health':
		Globals.health += 10  # Increase health.

	# Play collection sound, hide the sprite, and then remove the item.
	$AudioStreamPlayer2D.play()
	$Sprite2D.hide()
	await $AudioStreamPlayer2D.finished
	queue_free()
