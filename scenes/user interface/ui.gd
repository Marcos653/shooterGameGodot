extends CanvasLayer

@onready var laser_label: Label = $LaserCounter/VBoxContainer/Label

func update_laser_text():
	laser_label.text = str(Globals.laser_amount)
