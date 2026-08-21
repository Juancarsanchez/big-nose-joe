extends SceneTree

var failures: Array[String] = []

func _init() -> void:
	call_deferred("_run")

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_dynamic_pile_test.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false
	game.current_phase = 2
	game._clear_pile()

	_check(is_equal_approx(game._fossa_capacity("right"), game.FOSSA_BASE_CAPACITY), "The initial powder field must retain its explicit capacity.")
	game.levels.fossa_depth = 1
	_check(is_equal_approx(game._fossa_capacity("right"), game.FOSSA_GALLERY_CAPACITY), "The gallery upgrade must expand the field capacity.")
	game._rebuild_adaptations()
	game.playing = true
	game._update_fossa_meter()
	_check(game.fossa_meter.visible and game.adaptations.get_children().any(func(node: Node) -> bool: return str(node.get_meta("adaptation_kind", "")) == "surveyor"), "Building the fossa must reveal its real-time Leucotopographer meter.")
	game.playing = false
	game.levels.fossa_depth = 0

	for column in range(game.RIGHT_WALL_COLUMN, game.RIGHT_WALL_COLUMN + 24):
		game.powder_field.add("right", column, float((column - game.RIGHT_WALL_COLUMN) % 7 + 1), "player")
	game.powder_field.add("right", game.RIGHT_WALL_COLUMN + 7, 13.0, "joe")
	game.powder_surface.refresh()
	var load: float = game._pile_load("right")
	var screen_area: float = game.powder_surface.represented_world_area("right") * game.WORLD_SCALE * game.WORLD_SCALE
	_check(is_equal_approx(screen_area, load), "Hills and valleys must still contain one screen pixel per cocaine unit.")
	_check(game.powder_field.mass_columns("right").size() == 24, "Continuous powder must retain its landing distribution without one node per unit.")
	_check(game.loose_chunks.is_empty(), "The normal-powder field must not populate the legacy loose-piece array.")

	game._clear_pile()
	game._spawn_powder_drop(Vector2(4100.0, 300.0), 200.0, "right", 0, "player")
	_check(is_equal_approx(game._incoming_powder("right"), 200.0) and is_equal_approx(game._fossa_free_space("right"), game.FOSSA_BASE_CAPACITY - 200.0), "Falling powder must reserve its exact fossa area.")
	game._update_particle_motions(2.0)
	var landed_state: Dictionary = game._powder_units_by_state()
	_check(is_equal_approx(float(landed_state.total), 200.0) and is_zero_approx(game._incoming_powder("right")), "Landing and possible compaction must move, not duplicate, the incoming mass.")

	game._clear_pile()
	game.levels.breaker = 1
	game.another_line_events = 1
	game.powder_field.add("right", 0, 30.0, "player")
	game.compaction_steps.right = game._compaction_interval()
	game._maybe_compact("right")
	var rocks: Array = game.loose_chunks.filter(func(piece) -> bool: return str(piece.get_meta("kind", "")) == "rock")
	_check(rocks.size() == 1 and is_equal_approx(game.powder_field.amount("right"), 24.0) and is_equal_approx(game._pile_load("right"), 30.0), "Compaction must move exactly six units into the rock while preserving all thirty pile units.")
	if not rocks.is_empty():
		var rock = rocks[0]
		var base_scale := float(rock.get_meta("base_scale", 0.0))
		var opaque_screen_area: float = game._texture_opaque_area(rock.texture) * base_scale * base_scale * game.WORLD_SCALE * game.WORLD_SCALE
		_check(float(rock.get_meta("value", 0.0)) == 6.0 and base_scale >= 0.16 and opaque_screen_area > 6.0, "A compacted rock must keep six logical units but recover its readable obstacle-sized sprite.")
		var expected_y: float = game.powder_surface.surface_y_at("right", rock.position.x) - maxf(4.0, game._texture_opaque_bottom(rock.texture) * base_scale) + game.ROCK_SURFACE_INSET
		_check(is_equal_approx(rock.position.y, expected_y), "Compacted cocaine must rest on the current powder surface.")

	var helmet := Sprite2D.new()
	helmet.set_meta("cargo", [])
	helmet.set_meta("specialist", true)
	helmet.set_meta("detector", false)
	helmet.set_meta("handler", false)
	if not rocks.is_empty():
		game._chip_rock(rocks[0], 99)
	_check(game._claim_pawn_load("right", helmet), "A blue helmet must prioritize the compacted rock.")
	_check((helmet.get_meta("cargo", []) as Array).size() == 1 and is_zero_approx(float(helmet.get_meta("powder_amount", 0.0))), "A blue helmet must never replace its rock task with ordinary powder.")

	var pawn := Sprite2D.new()
	pawn.set_meta("cargo", [])
	pawn.set_meta("specialist", false)
	pawn.set_meta("detector", false)
	pawn.set_meta("handler", false)
	_check(game._claim_pawn_load("right", pawn) and float(pawn.get_meta("powder_amount", 0.0)) > 0.0, "An ordinary pawn must claim real powder mass rather than a ball object.")
	game._release_pawn_powder(pawn)
	pawn.free()
	for piece in helmet.get_meta("cargo", []):
		if is_instance_valid(piece):
			game._set_piece_carried(piece, false)
			piece.visible = true
			game._index_add_piece(piece)
	helmet.free()

	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	game.queue_free()
	await process_frame
	if failures.is_empty():
		print("DYNAMIC_PILE_SMOKE_OK")
		quit(0)
	else:
		print("DYNAMIC_PILE_SMOKE_FAILED: %d" % failures.size())
		quit(1)
