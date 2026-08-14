extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_visual_capture_test.save"
	game._new_game()
	game.phase_event_pending = false
	game.current_phase = 2
	game.joe_dialog.hide()
	game.levels = game._empty_levels()
	game.levels.merge({"nails":3, "pawn":3, "smart_clump":1, "shift":2, "container":1, "cart":1, "silo":1, "ox_convoy":1, "coord":0, "breaker":1}, true)
	game.cells = 5200.0
	game._rebuild_pawns()
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	seed(72426)
	for index in range(118):
		var column: int = game._choose_landing_column("right")
		game._create_piece("grain", "right", 1.0 + float(index % 4 == 0), 0, column, randf_range(0.068, 0.078))
	for index in range(6):
		var column: int = game._choose_landing_column("right")
		game._create_piece("rock", "right", 7.0, 2 + index % 2, column, randf_range(0.175, 0.205))
	game.compaction_announced = true
	game._update_pressure_visuals()
	game._update_ui()
	await create_timer(6.2).timeout
	await process_frame
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/dynamic_pile_preview.png"
	var image := root.get_texture().get_image()
	var error := image.save_png(destination)
	if error == OK:
		print("VISUAL_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save visual capture: %s" % error_string(error))
		quit(1)
