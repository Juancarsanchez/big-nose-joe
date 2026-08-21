extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	print("POWDER UNIT FLOW SMOKE: START")

func _initialize() -> void:
	call_deferred("_run")

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _screen_area(game: Control, world_area: float) -> float:
	return world_area * game.WORLD_SCALE * game.WORLD_SCALE

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_powder_unit_flow_test.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game._clear_pile()

	# Excepción de lectura: 1–4 unidades valen lo mismo, pero todas ocupan cuatro
	# píxeles. A partir de cinco vuelve la equivalencia visual lineal.
	for small_amount in range(1, 6):
		game._clear_pile()
		game.powder_field.add("right", 0, float(small_amount), "player")
		game.powder_surface.refresh()
		var expected_pixels := 4.0 if small_amount < 5 else 5.0
		var pile_pixels := _screen_area(game, game.powder_surface.represented_world_area("right"))
		_check(is_equal_approx(game._pile_load("right"), float(small_amount)), "Small-powder readability must never alter its logical quantity.")
		_check(is_equal_approx(pile_pixels, expected_pixels), "%d logical units must occupy %.0f visible pixels, got %.2f." % [small_amount, expected_pixels, pile_pixels])
		game.powder_effects.set_mass_volume("small_test", Vector2.ZERO, float(small_amount), game._fossa_visual_area_per_unit(), "fall")
		_check(is_equal_approx(_screen_area(game, game.powder_effects.mass_volume_world_area("small_test")), expected_pixels), "The same small-volume rule must apply while powder is moving.")
	game.powder_effects.remove_mass_volume("small_test")
	game._clear_pile()

	# Pila: diez unidades lógicas deben ocupar diez píxeles de pantalla.
	game.powder_field.add("right", 0, 7.0, "player")
	game.powder_field.add("right", 1, 3.0, "joe")
	game.powder_surface.refresh()
	_check(is_equal_approx(game._pile_load("right"), 10.0), "The continuous pile must retain exactly ten logical units.")
	_check(is_equal_approx(_screen_area(game, game.powder_surface.represented_world_area("right")), 10.0), "Ten pile units must occupy exactly ten screen pixels of area.")
	_check(game.loose_chunks.is_empty(), "Normal cocaine must not create legacy PilePiece balls.")

	# Minado y caída: la misma masa existe en vuelo y aterriza sin multiplicarse.
	game._clear_pile()
	game._spawn_powder_drop(Vector2(4100.0, game._ground_y() - 200.0), 10.0, "right", 0, "player")
	var incoming: Dictionary = game._powder_units_by_state()
	_check(is_equal_approx(float(incoming.incoming), 10.0) and is_equal_approx(float(incoming.total), 10.0), "A ten-unit hit must remain ten units while falling.")
	var incoming_id = game.particle_motions[0].id
	_check(is_equal_approx(_screen_area(game, game.powder_effects.mass_volume_world_area(incoming_id)), 10.0), "A ten-unit falling cloud must occupy ten screen pixels.")
	game._update_particle_motions(2.0)
	var landed: Dictionary = game._powder_units_by_state()
	_check(is_equal_approx(float(landed.pile), 10.0) and is_equal_approx(float(landed.total), 10.0), "Landing must transfer all ten units into the pile without loss.")

	# Recogida manual: el clic divide masa, no selecciona una bola con valor oculto.
	game.levels.nails = 2 # 10 por clic
	var source_point := Vector2(game._pile_center("right"), game.powder_surface.surface_y_at("right", game._pile_center("right")))
	_check(game._manual_collect_powder("right", source_point, false), "Manual collection must claim continuous powder.")
	var manual: Dictionary = game._powder_units_by_state()
	_check(is_equal_approx(float(manual.manual_transit), 10.0) and is_equal_approx(float(manual.total), 10.0), "Manual transit must conserve the ten selected units.")
	game._update_particle_motions(2.0)
	_check(is_equal_approx(game.cells, 10.0), "The same ten manually transported units must reach storage.")

	# Peón: una capacidad de diez se ve como diez píxeles y descarga diez.
	game.cells = 0.0
	game.powder_field.add("right", 0, 10.0, "player")
	game.levels.pawn_capacity = 7
	var pawn := Sprite2D.new()
	pawn.set_meta("cargo", [])
	pawn.set_meta("side", "right")
	pawn.set_meta("specialist", false)
	pawn.set_meta("detector", false)
	pawn.set_meta("handler", false)
	game.pawns.add_child(pawn)
	_check(game._claim_pawn_load("right", pawn), "A normal pawn must claim divisible powder.")
	_check(is_equal_approx(float(pawn.get_meta("powder_amount", 0.0)), 10.0), "A ten-capacity pawn must carry ten real units.")
	var pawn_id := "pawn_%d" % pawn.get_instance_id()
	_check(is_equal_approx(_screen_area(game, game.powder_effects.mass_volume_world_area(pawn_id)), 10.0), "A pawn carrying ten units must visibly carry ten pixels.")
	game._finish_delivery(pawn)
	_check(is_equal_approx(game.cells, 10.0), "The pawn must deposit the same ten units it removed from the pile.")
	pawn.queue_free()
	await process_frame

	# Vehículo: las cargas se pueden partir a capacidad exacta y no son arrays de bolas.
	game.cells = 0.0
	game.powder_field.add("right", 0, 135.0, "player")
	var vehicle := Node2D.new()
	vehicle.set_meta("cargo", {})
	vehicle.set_meta("side", "right")
	vehicle.set_meta("transport_kind", "cart")
	game.transporters.add_child(vehicle)
	var vehicle_cargo: Dictionary = game._claim_transport_cocaine("right", 100.0, false)
	vehicle.set_meta("cargo", vehicle_cargo)
	game._update_transport_powder_visual(vehicle)
	_check(is_equal_approx(float(vehicle_cargo.amount), 100.0) and is_equal_approx(game._pile_load("right"), 35.0), "A 100-capacity vehicle must split exactly 100 units from a 135-unit pile.")
	var vehicle_id := "transport_%d" % vehicle.get_instance_id()
	_check(is_equal_approx(_screen_area(game, game.powder_effects.mass_volume_world_area(vehicle_id)), 100.0), "A full 100-unit vehicle must visibly carry 100 pixels.")
	game._deliver_transport_cargo(vehicle, Vector2.ZERO)
	_check(is_equal_approx(game.cells, 100.0) and is_equal_approx(game._pile_load("right"), 35.0), "Vehicle discharge must preserve both delivered and remaining mass.")

	# El guardado nuevo conserva columnas y fuentes; no vuelve a serializar bolas.
	game._clear_pile()
	game.cells = 17.0
	game.powder_field.add("right", 2, 11.0, "player")
	game.powder_field.add("right", 2, 4.0, "joe")
	var mixed_rock = game._create_piece("rock", "right", 6.0, 2, 3, 0.18, "", "joe")
	mixed_rock.set_meta("player_amount", 2.0)
	mixed_rock.set_meta("joe_amount", 4.0)
	game.playing = true
	game._save()
	var saved_data = JSON.parse_string(FileAccess.get_file_as_string(game.save_path))
	_check(typeof(saved_data) == TYPE_DICTIONARY and (saved_data.get("powder_field", []) as Array).size() == 1, "The save must contain one compact field row, not fifteen ball records.")
	var game_loaded := packed.instantiate()
	root.add_child(game_loaded)
	await process_frame
	await process_frame
	game_loaded.save_path = game.save_path
	game_loaded._load()
	_check(is_equal_approx(game_loaded.powder_field.amount("right"), 15.0) and is_equal_approx(game_loaded.powder_field.joe_amount("right"), 4.0), "Version-20 saves must restore exact continuous powder and its source (loaded %.1f / Joe %.1f)." % [game_loaded.powder_field.amount("right"), game_loaded.powder_field.joe_amount("right")])
	_check(game_loaded.loose_chunks.size() == 1, "Loading continuous powder must recreate only the one real compacted obstacle, never legacy grain balls.")
	if game_loaded.loose_chunks.size() == 1:
		var loaded_rock = game_loaded.loose_chunks[0]
		_check(is_equal_approx(float(loaded_rock.get_meta("player_amount", 0.0)), 2.0) and is_equal_approx(float(loaded_rock.get_meta("joe_amount", 0.0)), 4.0), "A mixed compacted rock must preserve its exact player/Joe composition through save and load.")

	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	game.queue_free()
	game_loaded.queue_free()
	await process_frame
	if failures.is_empty():
		print("POWDER UNIT FLOW SMOKE: PASS")
		quit(0)
	else:
		print("POWDER UNIT FLOW SMOKE: FAIL (%d)" % failures.size())
		quit(1)
