extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_extraction_capture.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 5
	game.levels = game._empty_levels()
	game.levels.merge({"puncher":4, "punch_power":3, "punch_speed":2, "elephant":1, "pugilist_cannon":1, "supersaiyan":1, "breaker":3, "platelets":2}, true)
	game.right_hp = game.right_max
	seed(60826)
	for index in range(150):
		game._create_piece("grain", "right", 10.0, 0, game._choose_landing_column("right"), randf_range(0.068, 0.078))
	game._rebuild_punchers()
	game._rebuild_pawns()
	game._rebuild_platelets()
	for child in game.punchers.get_children():
		var kind := str(child.get_meta("extraction_kind", ""))
		if kind == "elephant":
			child.set_meta("state", "to_wall")
			(child as Node2D).position.x -= 125.0
		elif kind == "supersaiyan":
			child.set_meta("timer", 1.1)
	game._update_special_extractors(0.0)
	game.camera_x = 3370.0
	game.camera_goal = 3370.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	game._update_ui()
	await process_frame
	await process_frame
	var destination := "res://docs/extraction_rework_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK:
		print("EXTRACTION_REWORK_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		push_error("Could not save extraction capture: %s" % error_string(error))
		quit(1)
