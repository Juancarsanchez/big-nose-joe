extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_pinned_capture.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.phase_work = 250.0
	game.cells = 420.0
	game._toggle_upgrade_pin("nails")
	game._toggle_upgrade_pin("container")
	game._toggle_upgrade_pin("supersaiyan")
	game._update_ui()
	await process_frame
	await process_frame
	var destination := "res://docs/pinned_technology_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	game._open_technology_lab()
	game._select_technology_unit("manual")
	await process_frame
	await process_frame
	var lab_error := root.get_texture().get_image().save_png("res://docs/pinned_technology_lab_preview.png")
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK and lab_error == OK:
		print("PINNED_TECHNOLOGY_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		quit(1)
