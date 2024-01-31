extends CanvasLayer  # Inherits from CanvasLayer, typically used for UI elements in Godot.

# Define colors for use in UI elements.
var green: Color = Color("6bbfa3")  # A shade of green.
var red: Color = Color(0.9, 0, 0, 1)  # Red color.

# Load references to various UI elements on ready.
@onready var laser_label: Label = $LaserCounter/VBoxContainer/Label
@onready var laser_icon: TextureRect = $LaserCounter/VBoxContainer/TextureRect
@onready var grenade_label: Label = $GrenadeCounter/VBoxContainer/Label
@onready var grenade_icon: TextureRect = $GrenadeCounter/VBoxContainer/TextureRect
@onready var health_bar: TextureProgressBar = $MarginContainer/TextureProgressBar

# Called when the node enters the scene tree.
func _ready() -> void:
	Globals.connect("stat_change", update_stat_text)  # Connect to a 'stat_change' signal from Globals.
	update_stat_text()  # Update the stat text initially.

# Update the laser counter's text and color.
func update_laser_text() -> void:
	laser_label.text = str(Globals.laser_amount)  # Set the text to the amount of lasers.
	update_color(Globals.laser_amount, laser_label, laser_icon)  # Update the color based on the amount.

# Update the grenade counter's text and color.
func update_grenade_text() -> void:
	grenade_label.text = str(Globals.grenade_amount)  # Set the text to the amount of grenades.
	update_color(Globals.grenade_amount, grenade_label, grenade_icon)  # Update the color based on the amount.

# Update the stats text.
func update_stat_text():
	update_laser_text()
	update_grenade_text()
	update_health_text()  # Update the health text.

# Update the color of the label and icon based on the amount.
func update_color(amount: int, label: Label, icon: TextureRect) -> void:
	if amount != 0:
		label.modulate = green  # If amount is not zero, set color to green.
		icon.modulate = green
	else:
		label.modulate = red  # If amount is zero, set color to red.
		icon.modulate = red

# Update the health bar's value.
func update_health_text():
	health_bar.value = Globals.health  # Set the health bar's value to the current health.
