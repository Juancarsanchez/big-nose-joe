extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_new_bridges_capture.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.current_phase = 5
	game.levels = game._empty_levels()
	game.levels.merge({"hammer":1, "hammer_power":1, "meteor":1, "meteor_power":1}, true)
	game._rebuild_pawns()
	game._rebuild_punchers()
	game._rebuild_transporters()
	game._update_ui()
	game.camera_x = game._closed_camera_min() + 520.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	game.playing = false
	await process_frame
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/new_extraction_bridges_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK:
		print("NEW_BRIDGES_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		push_error("Could not save new bridge capture: %s" % error_string(error))
		quit(1)
