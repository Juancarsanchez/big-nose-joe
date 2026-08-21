extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_phase12_visual.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 2
	game.levels = game._empty_levels()
	game.levels.merge({"nails":5, "pawn":4, "pawn_capacity":3, "smart_clump":3, "container":1, "cart":1, "container_capacity":1, "cart_reinforced":1, "warehouse":1, "cart_upgrade":1, "puncher":1, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":1, "punch_collective":1, "shift":1}, true)
	game.cells = 64000.0
	seed(81426)
	for index in range(180):
		game.powder_field.add("right", game._choose_landing_column("right"), 10.0, "player")
	game.powder_surface.refresh()
	game._rebuild_pawns()
	game._rebuild_punchers()
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	game._update_ui()
	game.camera_x = 3260.0
	game.camera_goal = 3260.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	await process_frame
	await process_frame
	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/phase12_progression_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK:
		print("PHASE12_VISUAL_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		push_error("Could not save phase 1-2 capture: %s" % error_string(error))
		quit(1)
