extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_another_line_capture.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	seed(92741)
	game.levels.merge({"nails":2, "pawn":2, "shift":1, "container":1, "cart":1, "click_burst":1}, true)
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	game.cells = 900.0
	game.phase_work = 420.0
	game._rebuild_pawns()

	game.another_line_clock = 0.0
	game._update_another_line(0.01)
	while game.another_line_wave > 0:
		game._update_another_line(0.20)
	await create_timer(1.35).timeout

	var pile_before_punch: int = game.loose_chunks.size()
	game._buy("puncher")
	game._update_punchers(1.40)
	var punch_safety := 100
	while game.loose_chunks.size() < pile_before_punch + game.PUGILIST_GRAINS_PER_HIT and punch_safety > 0:
		game._update_punchers(0.06)
		punch_safety -= 1
	game._update_ui()
	var puncher_button := game.buttons.puncher as Button
	if puncher_button:
		game._scroll_to_required_upgrade(puncher_button)
	await process_frame
	await process_frame
	await process_frame

	var args := OS.get_cmdline_user_args()
	var destination := args[0] if not args.is_empty() else "res://docs/another_line_pugilist_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if error == OK:
		print("ANOTHER_LINE_CAPTURE_OK: %s" % destination)
		if FileAccess.file_exists(game.save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
		quit(0)
	else:
		push_error("Could not save another-line capture: %s" % error_string(error))
		quit(1)
