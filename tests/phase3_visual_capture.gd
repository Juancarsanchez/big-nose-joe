extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_phase3_capture_test.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.current_phase = 3
	game.levels = game._empty_levels()
	game.levels.merge({"nails":3, "puncher":4, "punch_power":2, "punch_speed":2, "pawn":4, "shift":2, "container":1, "cart":1, "silo":1, "ox_convoy":1, "breaker":1, "detector":1, "sponge":2, "sponge_power":3}, true)
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	game.cells = 6200.0
	game.contamination = 100.0
	game._update_box_jam(0.0)
	game.phase_work = 860.0
	game._rebuild_pawns()
	game._rebuild_punchers()
	game._rebuild_adaptations()
	seed(73137)
	for index in range(92):
		game.powder_field.add("right", game._choose_landing_column("right"), 1.0, "player")
	for index in range(18):
		var material: String = ["serrín", "yeso", "tiza"][index % 3]
		game._create_piece("impurity", "right", 1.0, 0, game._choose_landing_column("right"), randf_range(0.078, 0.092), material)
	for index in range(4):
		game._create_piece("rock", "right", 6.0, 0, game._choose_landing_column("right"), 0.18)
	game.powder_surface.refresh()
	game._restack_pile("right")
	game._trigger_spray()
	game._update_crisis_visuals()
	game._update_pressure_visuals()
	game._update_ui()
	game._focus_required_upgrade()
	game.playing = false
	await process_frame
	await process_frame
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/phase3_contamination_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("PHASE3_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save phase 3 capture: %s" % error_string(error))
		quit(1)
