extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_wall_chunk_capture.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	seed(73104)
	for index in range(38):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), randf_range(0.068, 0.078))
	game._restack_pile("right")
	game.right_hp = game.right_max
	game._damage_wall(game.right_max * 0.10)
	await create_timer(1.0).timeout
	game._update_ui()
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/wall_chunk_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("WALL_CHUNK_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save wall chunk capture: %s" % error_string(error))
		quit(1)
