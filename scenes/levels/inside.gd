extends LevelParent

var outside_level_scene: PackedScene = preload("res://scenes/levels/outside.tscn") 

func _on_exit_gate_area_body_entered(body):
	var tween = create_tween()
	tween.tween_property($Player, "speed", 0, 0.5)
#	get_tree().change_scene_to_file("res://scenes/levels/outside.tscn")
	get_tree().change_scene_to_packed(outside_level_scene)
