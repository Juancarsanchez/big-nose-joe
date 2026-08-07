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
	await process_frame
	for index in range(180):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), 0.072)
	for attempt in range(12):
		game.compaction_steps.right = game.COMPACTION_INTERVAL_MAX
		game._maybe_compact("right")
	_check(game._rock_count("right") == game.COMPACTION_ROCK_LIMIT, "Compaction must stop at exactly eight simultaneous rocks per fossa.")

	# The seventy-percent high threshold unlocks compaction permanently; Joe rebounding must not disable it.
	game.current_phase = 1
	_check(not game._compaction_unlocked(), "Compaction must not burden the opening before Joe first reaches seventy percent high.")
	game.joe_high = 70.0
	game._check_phase_progress()
	_check(game.current_phase == 2 and game._compaction_unlocked(), "Crossing seventy percent high must permanently unlock compaction.")
	game.joe_high = 90.0
	_check(game._compaction_unlocked(), "Joe's high rebounding after Pulmones de Drogata must not disable compaction.")
	game.phase_event_pending = false
	game.playing = false
	await process_frame

	# Treated rocks remain exclusive to blue-helmet specialists.
	var pawn := game.pawns.get_child(0) as Sprite2D
	game._clear_pile()
	await process_frame
	var treated_rock = game._create_piece("rock", "right", 6.0, 0, 0, 0.18)
	_check(game._claim_top_pieces("right", 1, pawn).is_empty(), "A normal pawn must never carry a compacted rock.")
	pawn.set_meta("specialist", true)
	var rock_cargo: Array = game._claim_top_pieces("right", 1, pawn)
	_check(rock_cargo.size() == 1 and rock_cargo[0] == treated_rock, "Only a blue-helmet specialist may carry a treated rock.")
	game._finish_delivery(pawn)
	pawn.set_meta("specialist", false)

	# Normal pawns keep every carried grain separate; safe smart clumping no longer exists.
	game._clear_pile()
	await process_frame
	for index in range(6):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), 0.072)
	var cargo: Array = game._claim_top_pieces("right", 6, pawn)
	_check(cargo.size() == 6 and cargo.all(func(piece) -> bool: return piece.get_meta("kind", "") == "grain"), "Normal pawns must carry six separate grains without creating a safe clump.")
	_check(pawn.z_index >= 8 and cargo.all(func(piece) -> bool: return piece.render_key.ends_with(":cargo")), "Carriers must stay above every storage prop and carried grains must move to the foreground render batch.")
	pawn.set_meta("cargo", cargo)
	game._set_pawn_facing(pawn, true)
	game._update_carried_pieces(pawn)
	_check(cargo.all(func(piece) -> bool: return piece.position.x > pawn.position.x), "Every visible grain must remain in front of a right-facing carrier, never behind its body.")

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
