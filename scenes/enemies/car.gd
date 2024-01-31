extends PathFollow2D  # Inherit from PathFollow2D, typically used for objects that follow a path.

var player_near: bool = false  # Flag to check if the player is near the turret.

# Load references to nodes on ready.
@onready var line1: Line2D = $Turret/RayCast2D/Line2D
@onready var line2: Line2D = $Turret/RayCast2D2/Line2D
@onready var gun_fire1: Sprite2D = $Turret/GunFire1
@onready var gun_fire2: Sprite2D = $Turret/GunFire2

func fire():
	Globals.health -= 20  # Inflict damage on the global player's health.
	# Set the alpha value of the gun fire sprites to fully opaque.
	gun_fire1.modulate.a = 1
	gun_fire2.modulate.a = 1
	
	# Create a tween to animate the gun fire sprites' transparency.
	var tween = create_tween()
	tween.set_parallel(true)  # Set the tween to process in parallel.
	# Tween the alpha values to 0 over a random duration between 0.1 and 0.5 seconds.
	tween.tween_property(gun_fire1, "modulate:a", 0, randf_range(0.1, 0.5))
	tween.tween_property(gun_fire2, "modulate:a", 0, randf_range(0.1, 0.5))

func _ready():
	line2.add_point($Turret/RayCast2D2.target_position)  # Add a point to line2 at the target position.

func _process(delta):
	progress_ratio += 0.01 * delta  # Progress the ratio, potentially for path following.

	if player_near:  # If the player is near,
		$Turret.look_at(Globals.player_pos)  # Make the turret look at the player.

# Signal handlers for the notice area.
func _on_notice_area_body_entered(_body):
	player_near = true  # Set flag when player enters the notice area.
	$AnimationPlayer.play("laser_load")  # Play the laser loading animation.

func _on_notice_area_body_exited(_body):
	var tween = create_tween()
	player_near = false  # Reset flag when player exits the notice area.
	$AnimationPlayer.pause()  # Pause the animation player.
	
	# Tween the line widths back to 0.
	tween.set_parallel(true)
	tween.tween_property(line1, "width", 0, randf_range(0.1, 0.5))
	tween.tween_property(line2, "width", 0, randf_range(0.1, 0.5))
	await tween.finished  # Wait for the tween to finish.
	$AnimationPlayer.stop()  # Stop the animation player.
