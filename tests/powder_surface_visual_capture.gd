extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_powder_capture.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 3
	game.levels.smart_clump = 2
	game.levels.pawn = 3
	game.levels.breaker = 1
	game._clear_pile()
	seed(180826)
	for index in range(520):
		game.powder_field.add("right", game._choose_landing_column("right"), 3.0, "player")
	for index in range(95):
		game.powder_field.add("right", game._choose_landing_column("right"), 1.0, "joe")
	for index in range(22):
		var material := "serrín" if index % 2 == 0 else "yeso"
		game._create_piece("impurity", "right", 1.0, 0, game._choose_landing_column("right"), 0.084, material, "joe")
	game._rebuild_pile_index()
	game._restack_pile("right")
	game.powder_surface.refresh()
	game._rebuild_pawns()
	var pawn := game.pawns.get_child(0) as Sprite2D
	pawn.position = game._pile_access_point("right") + Vector2(115.0, 0.0)
	game._claim_pawn_load("right", pawn)
	game._set_pawn_carrying(pawn, true)
	game._update_carried_pieces(pawn)
	game.camera_x = 3220.0
	game.camera_goal = 3220.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	game.powder_surface.refresh()
	game._update_ui()
	for frame in range(12):
		await process_frame
	var destination := "res://docs/powder_surface_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK:
		print("POWDER_SURFACE_CAPTURE_OK: %s" % destination)
		quit(0)
	else:
		push_error("Could not save powder preview: %s" % error_string(error))
		quit(1)
