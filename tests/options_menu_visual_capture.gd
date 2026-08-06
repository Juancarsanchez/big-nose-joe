extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var game := (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_menu_capture.save"
	game.settings_path = "user://big_nose_joe_menu_capture.cfg"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = true
	game._open_options_menu()
	game.music_slider.value = 63.0
	game.sfx_slider.value = 81.0
	await process_frame
	var destination := "res://docs/options_menu_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	for path in [game.save_path, game.settings_path]:
		if FileAccess.file_exists(path): DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("OPTIONS_MENU_CAPTURE_OK: %s" % destination)
	quit(0 if error == OK else 1)
