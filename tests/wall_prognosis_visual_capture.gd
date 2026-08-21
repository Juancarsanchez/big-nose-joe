extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_wall_prognosis_capture.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 4
	game.joe_high = 58.0
	game.joe_high_display = 58.0
	game.tissue_damage = 54.0
	game.right_hp = game.right_max * 0.01
	seed(91354)
	for index in range(52):
		game.powder_field.add("right", game._choose_landing_column("right"), 1.0, "player")
	game.powder_surface.refresh()
	game._restack_pile("right")
	game._update_world()
	game._update_crisis_visuals()
	game._update_ui()
	game._wall_damage_feedback("right", 0.021, 0.009)
	await create_timer(0.18).timeout
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/wall_prognosis_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("WALL_PROGNOSIS_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save wall and prognosis capture: %s" % error_string(error))
		quit(1)
