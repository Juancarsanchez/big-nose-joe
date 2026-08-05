extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_phase5_capture_test.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.current_phase = 5
	game.levels = game._empty_levels()
	game.levels.merge({"nails":3, "pawn":6, "shift":3, "box":2, "coord":1, "breaker":2, "umbrella":3, "umbrella_power":2, "detector":2, "sorting":1, "sponge":2, "sponge_power":3, "platelets":3, "repair":2, "handlers":2, "signals":1, "catapult":2, "catapult_power":2}, true)
	game.cells = 18400.0
	game.tissue_damage = 58.0
	game.infection = 61.0
	game.phase_work = 2800.0
	game._rebuild_pawns()
	game._rebuild_platelets()
	game._rebuild_adaptations()
	seed(73119)
	for index in range(64):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), randf_range(0.068, 0.078))
	for index in range(12):
		var material: String = ["serrín", "yeso", "tiza"][index % 3]
		game._create_piece("impurity", "right", 1.0, 0, game._choose_landing_column("right"), 0.064, material)
	for index in range(9):
		game._create_piece("bacteria", "right", 2.0, 0, game._choose_landing_column("right"), 0.078)
	game._trigger_scratch()
	game._trigger_mucus()
	game._update_crisis_visuals()
	game._update_pressure_visuals()
	game._update_ui()
	game.playing = false
	await process_frame
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/progression_phase5_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("PHASE5_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save phase 5 capture: %s" % error_string(error))
		quit(1)
