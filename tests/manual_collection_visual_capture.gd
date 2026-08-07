extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_manual_collection_capture.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.levels.merge({"nails":2, "pawn":2, "shift":1, "container":1, "cart":1}, true)
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	game.cells = 240.0
	seed(41872)
	for index in range(96):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), randf_range(0.068, 0.078))
	game._restack_pile("right")
	game._update_ui()
	for launch in range(5):
		var surface: Array = game._top_pieces("right")
		var piece = surface[(launch * 3) % surface.size()]
		game._manual_collect_at(Vector2(piece.position.x, game._ground_y() - 2.0))
		await create_timer(0.055).timeout
	await create_timer(0.18).timeout
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/manual_collection_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("MANUAL_COLLECTION_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save manual collection capture: %s" % error_string(error))
		quit(1)
