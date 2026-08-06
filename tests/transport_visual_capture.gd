extends SceneTree

func _init() -> void:
	call_deferred("_capture")

func _capture() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_transport_capture_test.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 5
	game.septum_open = true
	game.levels = game._empty_levels()
	game.levels.merge({"container":1, "cart":1, "silo":1, "ox_convoy":1, "plant":1, "train":1}, true)
	game.cells = 18400.0
	seed(80526)
	for index in range(170):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), randf_range(0.068, 0.078))
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	var train: Node2D = null
	for child in game.transporters.get_children():
		var transporter := child as Node2D
		if transporter.get_meta("transport_kind", "") == "cart":
			transporter.position = Vector2(4700.0, game._ground_y())
		elif transporter.get_meta("transport_kind", "") == "ox":
			transporter.position = Vector2(5000.0, game._ground_y())
		else:
			train = transporter
			transporter.position = Vector2(game.RIGHT_TUNNEL_X - 650.0, game._ground_y() - 10.0)
			transporter.scale.x = -1.0
	game.camera_x = 6190.0
	game.camera_goal = 6190.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	game._update_ui()
	await process_frame
	await process_frame
	var destination := "res://docs/transport_chain_preview.png"
	var error := root.get_texture().get_image().save_png(destination)
	game.camera_x = 4100.0
	game.camera_goal = 4100.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	await process_frame
	await process_frame
	var depot_destination := "res://docs/transport_depot_preview.png"
	var depot_error := root.get_texture().get_image().save_png(depot_destination)
	if train:
		train.position = Vector2(650.0, game._ground_y() - 10.0)
		train.scale.x = -1.0
	game.camera_x = 0.0
	game.camera_goal = 0.0
	game.stage.position.x = -round(game.camera_x * game.WORLD_SCALE)
	await process_frame
	await process_frame
	var plant_destination := "res://docs/transport_plant_preview.png"
	var plant_error := root.get_texture().get_image().save_png(plant_destination)
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if error == OK and depot_error == OK and plant_error == OK:
		print("TRANSPORT_CAPTURE_OK: %s  ·  %s  ·  %s" % [destination, depot_destination, plant_destination])
		quit(0)
	else:
		push_error("Could not save transport capture: %s" % error_string(error))
		quit(1)
