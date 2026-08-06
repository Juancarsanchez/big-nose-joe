extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_overdose_capture.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = true
	game.joe_high = 100.0
	game._trigger_overdose()
	await process_frame
	await process_frame
	var destination := "res://docs/overdose_dialog_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK:
		print("OVERDOSE_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		push_error("Could not save overdose capture: %s" % error_string(error))
		quit(1)
