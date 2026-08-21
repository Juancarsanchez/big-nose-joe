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
	game.playing = false
	game.phase_event_pending = false
	game.current_phase = 2
	game.joe_dialog.hide()
	game._spawn_powder_stream(Vector2(700.0, game._ground_y() - 12.0), Vector2(1050.0, game._ground_y() - 24.0), 1.0)
	_check(game.effects.get_children().filter(func(node: Node) -> bool: return node is Line2D).is_empty(), "Manual collection must use atomized powder instead of a solid beam.")
	_check(game.powder_effects.active_count() >= 12, "The atomized collection arc must contain enough fine powder to remain readable.")
	_check(game.effects.get_child_count() < 8, "Transient powder must remain batched instead of creating one scene node per mote.")
	await create_timer(0.62).timeout
	_check(game.powder_effects.active_count() == 0, "An atomized arc must complete in one continuous flight and leave no delayed phantom powder.")

	# Las piezas lógicas no cambian de tamaño: el valor se representa como área
	# continua en la superficie (una unidad = un píxel de pantalla de masa).
	_check(is_equal_approx(game._grain_stack_height(1.0), game.GRAIN_HEIGHT), "A one-unit grain must retain the base logical height.")
	_check(is_equal_approx(game._grain_stack_height(1000000.0), game.GRAIN_HEIGHT), "Payload value must not create a taller logical sprite stack.")
	_check(is_equal_approx(game._fossa_capacity("right"), game.FOSSA_BASE_CAPACITY), "The initial fossa capacity must be explicit.")
	game.levels.fossa_depth = 1
	_check(is_equal_approx(game._fossa_capacity("right"), game.FOSSA_GALLERY_CAPACITY), "The gallery upgrade must expand the fossa capacity.")
	game._rebuild_adaptations()
	game.playing = true
	game._update_fossa_meter()
	_check(game.fossa_meter.visible and game.adaptations.get_children().any(func(node: Node) -> bool: return str(node.get_meta("adaptation_kind", "")) == "surveyor"), "Building the submucosal fossa must reveal its real-time meter and Leucotopographer together.")
	game.levels.fossa_depth = 0
	game._rebuild_adaptations()
	game._update_fossa_meter()
	_check(not game.fossa_meter.visible, "The fossa instrumentation must disappear when the fossa does not exist.")
	game.playing = false

	# Build deterministic overloaded piles without waiting for drop animations.
	seed(92741)
	for index in range(84):
		var column: int = game._choose_landing_column("right")
		game._create_piece("grain", "right", 1.0, 0, column, 0.072)
	for index in range(24):
		var column: int = game._choose_landing_column("left")
		game._create_piece("grain", "left", 1.0, 0, column, 0.072)

	_check(is_equal_approx(game._pile_load("right"), 84.0), "The pile must retain the complete resource value.")
	_check(game._top_pieces("right").size() > 2, "An irregular pile must expose several independent columns.")
	for piece in game.loose_chunks:
		var side: String = piece.get_meta("side", "right")
		var column: int = int(piece.get_meta("column", 0))
		_check(column >= game.RIGHT_WALL_COLUMN if side == "right" else column <= game.LEFT_WALL_COLUMN, "Loose powder must never cross the septum boundary.")

	# Every landed item must sit directly on the accumulated items below it.
	var columns := {}
	for piece in game.loose_chunks:
		var key := "%s:%d" % [piece.get_meta("side", "right"), int(piece.get_meta("column", 0))]
		if not columns.has(key):
			columns[key] = []
		(columns[key] as Array).append(piece)
	for key in columns:
		var pieces: Array = columns[key]
		pieces.sort_custom(func(a, b) -> bool: return a.position.y > b.position.y)
		var accumulated := 0.0
		for piece_value in pieces:
			var piece = piece_value
			var height: float = float(piece.get_meta("height", game.GRAIN_HEIGHT))
			var expected_y: float = game._ground_y() - 5.0 - accumulated - height * 0.5
			_check(absf(piece.position.y - expected_y) < 0.01, "A pile column contains a floating gap.")
			accumulated += height

	# Dense local groups compact often while preserving their total value.
	game.levels.puncher = 0
	game.levels.elephant = 0
	_check(game._compaction_interval() == game.COMPACTION_INTERVAL_MAX, "Low extraction must leave generous time between compacted rocks.")
	var now := Time.get_ticks_msec() * 0.001
	for index in range(25):
		game.manual_mining_click_times.append(now - float(24 - index) * 0.35)
	_check(game._compaction_interval() == 18, "Sustained manual mining above two clicks per second must accelerate compaction to eighteen landings.")
	game.manual_mining_click_times.clear()
	for index in range(45):
		game.manual_mining_click_times.append(now - float(44 - index) * 0.20)
	_check(game._compaction_interval() == 12, "Manual mining above four clicks per second must accelerate compaction to twelve landings.")
	game.manual_mining_click_times.clear()
	game.levels.puncher = 4
	game.levels.punch_power = 3
	_check(game._compaction_interval() == game.COMPACTION_INTERVAL_MIN, "Explosive extraction must compact powder at the minimum eight-landings cadence.")
	game.levels.puncher = 0
	game.compaction_steps.right = game.COMPACTION_INTERVAL_MAX
	var load_before: float = game._pile_load("right")
	game._maybe_compact("right")
	_check(is_equal_approx(game._pile_load("right"), load_before), "Compaction must preserve the value of all merged grains.")
	_check(game._untreated_rock_count("right") >= 1, "Overloaded powder must compact into a rock.")
	for attempt in range(4):
		game.compaction_steps.right = game.COMPACTION_INTERVAL_MAX
		game._maybe_compact("right")
	_check(game._rock_count("right") >= 4, "Dense powder must create compacted rocks frequently enough to matter.")
	await create_timer(0.30).timeout
	var grounded_rocks: Array = game.loose_chunks.filter(func(piece) -> bool: return piece.get_meta("kind", "grain") == "rock")
	for rock_value in grounded_rocks:
		var grounded_rock = rock_value
		var visible_bottom := maxf(4.0, float(game._texture_opaque_bottom(grounded_rock.texture)) * absf(grounded_rock.scale.y))
		_check(absf(grounded_rock.position.y + visible_bottom - game.powder_surface.surface_y_at("right", grounded_rock.position.x) - game.ROCK_SURFACE_INSET) < 1.5, "A compacted rock must rest slightly inside the current snow surface instead of floating.")
	grounded_rocks.sort_custom(func(a, b) -> bool: return a.position.x < b.position.x)
	for index in range(1, grounded_rocks.size()):
		_check(absf(grounded_rocks[index].position.x - grounded_rocks[index - 1].position.x) >= 20.0, "Compacted rocks must roll apart when the surface cannot support both in one place.")

	var rock = null
	for piece in game.loose_chunks:
		if piece.get_meta("kind", "grain") == "rock":
			rock = piece
			break
	_check(is_instance_valid(rock), "The compacted rock must exist as a visual piece.")
	if is_instance_valid(rock):
		var hardness_before := int(rock.get_meta("hardness", 0))
		game._chip_rock(rock)
		_check(int(rock.get_meta("hardness", 0)) == hardness_before - 1, "A specialist hit must visibly advance rock treatment.")
		while int(rock.get_meta("hardness", 0)) > 0:
			game._chip_rock(rock)
		_check(int(rock.get_meta("hardness", 0)) == 0, "A treated rock must become transportable.")

	game._clear_pile()
	var near_column: int = int(game.RIGHT_WALL_COLUMN)
	var far_column: int = mini(int(game._pile_radius_limit("right")), int(game.RIGHT_WALL_COLUMN) + 55)
	game._create_piece("grain", "right", 900.0, 0, near_column, 0.072)
	game._create_piece("grain", "right", 900.0, 0, far_column, 0.072)
	var near_x: float = float(game._pile_center("right")) + float(near_column) * float(game.GRAIN_SPACING)
	var far_x: float = float(game._pile_center("right")) + float(far_column) * float(game.GRAIN_SPACING)
	var near_surface: float = float(game.powder_surface.surface_y_at("right", near_x))
	var far_surface: float = float(game.powder_surface.surface_y_at("right", far_x))
	var valley_surface: float = float(game.powder_surface.surface_y_at("right", (near_x + far_x) * 0.5))
	_check(near_surface < game._ground_y() - 5.0 and far_surface < game._ground_y() - 5.0, "Powder must build visible volume beneath every actual landing zone.")
	_check(valley_surface > minf(near_surface, far_surface) + 5.0, "Separated landings must form distinct hills and a readable valley instead of one wall-bound mound.")
	game._clear_pile()
	# Una fosa llena debe bloquear solo la extracción; abrir la galería vuelve a
	# dejar espacio sin falsificar recursos ni borrar la montaña.
	game.playing = true
	game._create_piece("grain", "right", game.FOSSA_BASE_CAPACITY, 0, game.RIGHT_WALL_COLUMN, 0.072)
	var wall_before_full: float = game.right_hp
	game._click_wall("right")
	_check(is_equal_approx(game.right_hp, wall_before_full), "A saturated fossa must stop manual extraction.")
	game.levels.fossa_depth = 1
	game._click_wall("right")
	_check(game.right_hp < wall_before_full, "The gallery must restore extraction capacity immediately.")
	game._clear_pile()
	game.levels.fossa_depth = 0
	var wall_before_pause: float = game.right_hp
	game.user_paused = true
	game._click_wall("right")
	_check(is_equal_approx(game.right_hp, wall_before_pause) and is_zero_approx(game._pile_load("right")), "A paused run must reject direct wall-button clicks as well as viewport input.")
	game.user_paused = false
	game.playing = false
	await process_frame
	for index in range(180):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), 0.072)
	for attempt in range(12):
		game.compaction_steps.right = game.COMPACTION_INTERVAL_MAX
		game._maybe_compact("right")
	_check(game._rock_count("right") == game.COMPACTION_ROCK_LIMIT, "Compaction must stop at exactly eight simultaneous rocks per fossa.")

	# The seventy-percent high threshold unlocks compaction permanently; Joe rebounding must not disable it.
	game.current_phase = 1
	game.playing = true
	_check(not game._compaction_unlocked(), "Compaction must not burden the opening before Joe first reaches seventy percent high.")
	game.joe_high = 70.0
	game._check_phase_progress()
	_check(game.current_phase == 2 and game._compaction_unlocked(), "Crossing seventy percent high must permanently unlock compaction.")
	game.joe_high = 90.0
	_check(game._compaction_unlocked(), "Advancing Joe's high state must not disable compaction once it has appeared.")
	game.phase_event_pending = false
	game.playing = false
	await process_frame

	# Treated rocks remain exclusive to blue-helmet specialists.
	game.levels.pawn = 1
	game._rebuild_pawns()
	var pawn := game.pawns.get_child(0) as Sprite2D
	game._clear_pile()
	await process_frame
	var treated_rock = game._create_piece("rock", "right", 6.0, 0, 0, 0.18)
	_check(game._claim_top_pieces("right", 1, pawn).is_empty(), "A normal pawn must never carry a compacted rock.")
	pawn.set_meta("specialist", true)
	game._set_pawn_carrying(pawn, false)
	pawn.position.y = game._ground_y() - game.PAWN_FOOT_DEPTH
	var specialist_foot: float = pawn.position.y + (pawn.offset.y + float(game._texture_opaque_bottom(pawn.texture))) * pawn.scale.y
	_check(absf(specialist_foot - game._ground_y()) < 0.1, "The blue helmet's visible feet must touch the nasal floor despite transparent sprite padding.")
	var rock_cargo: Array = game._claim_top_pieces("right", 1, pawn)
	_check(rock_cargo.size() == 1 and rock_cargo[0] == treated_rock, "Only a blue-helmet specialist may carry a treated rock.")
	game._finish_delivery(pawn)
	var ordinary_snow = game._create_piece("grain", "right", 1.0, 0, 1, 0.072)
	_check(game._claim_top_pieces("right", 1, pawn).is_empty(), "A blue helmet must wait for compacted snow instead of carrying ordinary powder.")
	_check(not bool(ordinary_snow.get_meta("carried", false)), "A waiting blue helmet must leave normal snow untouched.")
	pawn.set_meta("specialist", false)

	# Without the voluntary technology, normal pawns still keep every carried grain separate.
	game._clear_pile()
	await process_frame
	for index in range(6):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), 0.072)
	var cargo: Array = game._claim_top_pieces("right", 6, pawn)
	_check(cargo.size() == 6 and cargo.all(func(piece) -> bool: return piece.get_meta("kind", "") == "grain"), "Normal pawns must carry six separate grains without creating a safe clump.")
	var powder_mound := pawn.get_node_or_null("PowderMound") as Node2D
	_check(pawn.z_index >= 8 and is_instance_valid(powder_mound) and powder_mound.visible and cargo.all(func(piece) -> bool: return not piece.visible), "Normal carriers must show one foreground mini-pile instead of separate visible balls.")
	pawn.set_meta("cargo", cargo)
	game._set_pawn_facing(pawn, true)
	game._update_carried_pieces(pawn)
	_check(powder_mound.position.x > 0.0, "The carried powder mound must remain in front of a right-facing carrier.")

	# Cargo becomes currency only after the physical deposit finishes.
	var cargo_value := 0.0
	for piece_value in cargo:
		cargo_value += float(piece_value.get_meta("value", 0.0))
	var cells_before_delivery: float = game.cells
	pawn.set_meta("cargo", cargo)
	pawn.set_meta("state", "to_box")
	pawn.set_meta("side", "right")
	pawn.position = Vector2(game._box_x() + float(pawn.get_meta("lane_x", 0.0)), game._ground_y() - 14.0)
	game._update_pawns(0.01)
	_check(pawn.get_meta("state", "") == "deposit", "A loaded pawn must begin a physical deposit at the box.")
	game._update_pawns(0.31)
	_check(is_equal_approx(game.cells, cells_before_delivery + cargo_value), "Cargo must become currency only after the deposit finishes.")
	_check(game.get_node_or_null("World/StageViewport/Stage/Layer45_Pressure") == null, "The obsolete pile-height shadow must not exist.")

	# The player can manually throw exposed powder to the box without bypassing specialist rules.
	game._clear_pile()
	await process_frame
	game.current_phase = 1
	game.contamination = 0.0
	game.cells = 0.0
	game.playing = true
	game.joe_high = 70.0
	game.joe_high_display = 70.0
	game._damage_wall(10.0, "right")
	var high_after_mining: float = game.joe_high
	_check(high_after_mining < 70.0 and game.joe_high_feedback.text.contains("-10"), "Wall mining must immediately lower Joe's high and show the exact extracted amount.")
	var manual_grain = game._create_piece("grain", "right", 1.0, 0, 0, 0.072)
	var manual_point := Vector2(manual_grain.position.x, game._ground_y() - 2.0)
	_check(game._manual_collect_at(manual_point), "Clicking the visible pile must start a manual collection.")
	_check(bool(manual_grain.get_meta("manual_flying", false)) and bool(manual_grain.get_meta("carried", false)), "A manually collected grain must leave the pile immediately.")
	await create_timer(0.85).timeout
	_check(is_equal_approx(game.cells, 1.0) and game.loose_chunks.is_empty(), "Manual cargo must become currency only after reaching the box.")
	_check(is_equal_approx(game.joe_high, high_after_mining), "Player-mined cocaine must not reduce Joe's high a second time when it reaches storage.")
	var deposit_labels: Array = game.effects.get_children().filter(func(node: Node) -> bool: return node is Label)
	_check(deposit_labels.any(func(node: Node) -> bool: return (node as Label).text == "+1") and not deposit_labels.any(func(node: Node) -> bool: return (node as Label).text.contains("ALMACÉN  +")), "A deposited grain must display only +1, without the redundant storage prefix.")
	var facing_probe := Sprite2D.new()
	facing_probe.position = Vector2(100.0, 100.0)
	game._move_pawn_toward(facing_probe, Vector2(0.0, 100.0), 10.0, 0.1)
	_check(not facing_probe.flip_h and game._cargo_position(facing_probe, 0, 3).x < facing_probe.position.x, "A left-moving carrier must use the native left-facing pose and hold cargo in front.")
	game._move_pawn_toward(facing_probe, Vector2(200.0, 100.0), 10.0, 0.1)
	_check(facing_probe.flip_h and game._cargo_position(facing_probe, 0, 3).x > facing_probe.position.x, "A right-moving carrier must mirror the native pose and keep cargo in front.")
	facing_probe.free()

	game.current_phase = 3
	var manual_impurity = game._create_piece("impurity", "right", 1.0, 0, 0, 0.064, "yeso")
	_check(game._manual_collect_at(Vector2(manual_impurity.position.x, game._ground_y() - 2.0)), "An exposed impurity may be sent manually.")
	await create_timer(0.85).timeout
	_check(game.contamination > 0.0, "Manually delivering an impurity must still contaminate the box.")

	var blocked_rock = game._create_piece("rock", "right", 6.0, 0, 0, 0.18)
	var cells_before_blocked_click: float = game.cells
	_check(game._manual_collect_at(Vector2(blocked_rock.position.x, game._ground_y() - 2.0)), "A compacted rock must visibly acknowledge a manual click.")
	_check(not bool(blocked_rock.get_meta("carried", false)) and is_equal_approx(game.cells, cells_before_blocked_click), "Manual collection must never bypass blue-helmet specialists.")
	game._clear_pile()
	await process_frame
	var blocked_bacterium = game._create_piece("bacteria", "right", 2.0, 0, 0, 0.08)
	_check(game._manual_collect_at(Vector2(blocked_bacterium.position.x, game._ground_y() - 2.0)), "A bacterium must visibly acknowledge a manual click.")
	_check(not bool(blocked_bacterium.get_meta("carried", false)), "Manual collection must never bypass bacteria handlers.")
	game._clear_pile()
	await process_frame
	var input_grain = game._create_piece("grain", "right", 1.0, 0, 0, 0.072)
	var input_world_point := Vector2(input_grain.position.x, game._ground_y() - 2.0)
	var manual_click := InputEventMouseButton.new()
	manual_click.button_index = MOUSE_BUTTON_LEFT
	manual_click.pressed = true
	manual_click.position = game.stage.get_global_transform_with_canvas() * input_world_point
	game.playing = true
	game._input(manual_click)
	game.playing = false
	_check(bool(input_grain.get_meta("manual_flying", false)), "A real viewport click on the pile silhouette must trigger manual collection.")
	game._clear_pile()
	await process_frame
	game.levels.continuous_sweep = 1
	game.continuous_sweep_held = true
	game._update_continuous_sweep(0.25)
	_check(not game.continuous_sweep_held, "Continuous collection must stop if the mouse-release event was lost outside the game window.")
	game.levels.continuous_sweep = 0

	# Save/load preserves the extended pile and adaptation state.
	game.levels = game._empty_levels()
	game.levels.merge({"nails":2, "pawn":1, "shift":1, "container":1, "cart":1, "coord":0, "breaker":1}, true)
	game.cells = 1234.0
	game.playing = true
	game._save()
	var saved_load: float = game._pile_load("right")
	game._clear_pile()
	game.cells = 0.0
	game._load()
	_check(is_equal_approx(game.cells, 1234.0), "Save/load must preserve the existing economy.")
	_check(is_equal_approx(game._pile_load("right"), saved_load), "Save/load must preserve loose grains and rocks.")
	_check(int(game.levels.breaker) == 1, "Save/load must preserve specialist upgrades.")
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))

	if failures.is_empty():
		print("DYNAMIC_PILE_SMOKE_OK")
		quit(0)
	else:
		print("DYNAMIC_PILE_SMOKE_FAILED: %d" % failures.size())
		quit(1)
