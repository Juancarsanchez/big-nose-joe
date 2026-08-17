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
	game.save_path = "user://big_nose_joe_progression_test.save"
	game.settings_path = "user://big_nose_joe_settings_test.cfg"
	game._new_game()
	await process_frame
	_check(is_instance_valid(game.music_player) and game.music_player.stream != null, "The game must start the original musical loop instead of relying on placeholder beeps.")
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = true
	_check(game.get_node_or_null("PhaseLab") == null and is_equal_approx((game.get_node("World") as Control).anchor_right, 1.0), "The obsolete phase-selector bar must be removed and the playable viewport must use the freed right edge.")
	game._open_technology_lab()
	_check(game.technology_lab.visible and game.technology_lab.cards.size() == game.UNIT_CATALOG.size(), "The technology laboratory must expose one persistent card for every unit, vehicle and infrastructure family.")
	_check(game.technology_lab.cards.has("ram") and game.technology_lab.cards.has("leukophant") and game.technology_lab.cards.has("plasma_cannon") and game.technology_lab.cards.has("supersaiyan"), "Ram, Leukophant, Plasma Cannon and Supersaiyan must be independent technology pages.")
	_check((game.technology_lab.cards.ram as Button).icon == game.RAM_TEXTURE and (game.technology_lab.cards.plasma_cannon as Button).icon == game.PLASMA_CANNON_TEXTURE and (game.technology_lab.cards.supersaiyan as Button).icon == game.SUPERSAIYAN_TEXTURE, "Technology cards must reuse the real in-game unit sprites.")
	var plasma_card_data: Dictionary = game.UNIT_CATALOG.filter(func(unit: Dictionary) -> bool: return str(unit.id) == "plasma_cannon")[0]
	var supersaiyan_card_data: Dictionary = game.UNIT_CATALOG.filter(func(unit: Dictionary) -> bool: return str(unit.id) == "supersaiyan")[0]
	_check(int(plasma_card_data.phase) == 4 and int(supersaiyan_card_data.phase) == 5, "The Plasma Cannon must precede the final Supersaiyan in the technology catalogue.")
	game._close_technology_lab()
	game._update_ui()
	_check(not game.phase_label.visible and not game.pressure_label.visible and not game.wall_label.visible and not game.click_counter.visible, "The top HUD must remove phase, pressure, wall and tunneller legacy readouts.")
	_check(game.rate_label.text.contains("/ CLIC") and game.rate_label.text.contains("AUTO") and not game.rate_label.text.begins_with("+"), "The top HUD must retain only click and automatic extraction beside stored cocaine.")
	_check(game.joe_high_label.text.contains("/ 100") and not game.joe_high_label.text.contains("VIENDO"), "Joe's central meter must explain its number without an unrelated mood label.")
	_check(not (game.quick_buttons.nails as Button).visible, "A repeatable technology must not enter quick access before its first laboratory purchase.")
	game.levels.nails = 1
	game.cells = 1000.0
	game._update_ui()
	_check((game.quick_buttons.nails as Button).visible and (game.quick_buttons.nails as Button).text.contains("CLIC 3 → 10"), "An already discovered critical technology must receive a compact numerical quick-access button.")
	(game.quick_buttons.nails as Button).pressed.emit()
	_check(int(game.levels.nails) == 2, "Quick access must buy the next real level without reopening the laboratory.")
	game.levels.nails = 0
	game.cells = 0.0
	game._update_ui()
	var paused_line_clock: float = game.another_line_clock
	game._toggle_pause()
	game._process(2.0)
	_check(game.user_paused and game.pause_overlay.visible and game.pause_button.text.contains("REANUDAR") and is_equal_approx(game.another_line_clock, paused_line_clock), "Medical pause must stop the simulation while keeping its menu controls available.")
	game._toggle_pause()
	_check(not game.user_paused and not game.pause_overlay.visible, "Resuming must restore the simulation and remove the pause overlay.")
	var save_button := game.get_node("OptionsMenu/Margin/Content/SaveButton") as Button
	var save_exit_button := game.get_node("OptionsMenu/Margin/Content/SaveExitButton") as Button
	game._open_options_menu()
	_check(game.options_menu.visible and not game.shop.visible and is_instance_valid(save_exit_button), "The left menu must replace the laboratory and expose both save actions.")
	game.music_slider.value = 31.0
	game.sfx_slider.value = 64.0
	_check(is_equal_approx(game.music_volume, 0.31) and is_equal_approx(game.sfx_volume, 0.64) and game.music_label.text.contains("31%") and game.sfx_label.text.contains("64%"), "Music and effects sliders must regulate and label their buses independently.")
	_check(FileAccess.file_exists(game.settings_path), "Audio settings must persist outside the run save.")
	game._close_options_menu()
	_check(not game.options_menu.visible and game.shop.visible, "The close button must return to the laboratory sidebar.")
	game._manual_save()
	_check(is_instance_valid(save_button) and FileAccess.file_exists(game.save_path) and game.toast.text.contains("PARTIDA GUARDADA"), "The sidebar must expose a separate manual-save button with visible confirmation.")
	_check(is_equal_approx(game._storage_capacity(), 1000.0), "A new run must begin with a real 1,000-unit box limit.")
	_check(is_equal_approx(game._store_cocaine(1200.0), 1000.0) and is_equal_approx(game.cells, 1000.0), "The initial box must reject cocaine beyond its visible capacity.")
	_check(is_zero_approx(game._store_cocaine(1.0)), "A full store must stop every additional clean delivery.")
	game.cells = 0.0
	game._clear_pile()
	game.levels.container = 1
	game.cells = 1000.0
	var reserved_by_workers = game._create_piece("grain", "right", 4000.0, 0, 0, 0.072)
	reserved_by_workers.set_meta("carried", true)
	var manual_priority_piece = game._create_piece("grain", "right", 1000.0, 0, 1, 0.072)
	_check(is_zero_approx(game._storage_claim_space()), "Worker cargo may reserve all newly unlocked storage while it is in transit.")
	_check(game._manual_collect_at(manual_priority_piece.position) and bool(manual_priority_piece.get_meta("manual_flying", false)), "A manual click must ignore worker reservations when the upgraded store has real free space.")
	_check(is_zero_approx(game._store_automatic_cocaine(4000.0)), "Automatic deliveries must preserve the space reserved by a manual flight.")
	_check(is_equal_approx(game._store_cocaine(1000.0), 1000.0), "The reserved manual cargo must still fit when it reaches the upgraded store.")
	manual_priority_piece.set_meta("manual_flying", false)
	manual_priority_piece.set_meta("carried", false)
	game._release_manual_reservation(manual_priority_piece)
	game.loose_chunks.erase(manual_priority_piece)
	manual_priority_piece.queue_free()
	_check(is_equal_approx(game.cells, 2000.0) and is_equal_approx(game._store_automatic_cocaine(3000.0), 3000.0), "Manual cargo must arrive first without losing later automatic deliveries that still fit.")
	game._clear_pile()
	game.cells = 0.0
	var buried_grain = game._create_piece("grain", "right", 1.0, 0, 0, 0.072)
	game._create_piece("rock", "right", 6.0, 4, 0, 0.18)
	_check(game._manual_collect_at(buried_grain.position) and bool(buried_grain.get_meta("manual_flying", false)), "A precise click on a visible grain below a clump must select the grain instead of the clump's broad hit area.")
	game._clear_pile()
	game.levels.container = 0
	game.cells = 457.0
	var aggregated_grain = game._create_piece("grain", "right", 1000.0, 0, 0, 0.072)
	_check(game._manual_collect_at(aggregated_grain.position) and not bool(aggregated_grain.get_meta("carried", false)), "An indivisible grain that does not fit must report full storage and remain in the pile.")
	_check(is_equal_approx(float(aggregated_grain.get_meta("value", 0.0)), 1000.0) and is_equal_approx(game._pile_load("right"), 1000.0), "Storage pressure must never split a valuable grain into fractions.")
	game._clear_pile()
	var worker_aggregate = game._create_piece("grain", "right", 1000.0, 0, 0, 0.072)
	var test_collector := Sprite2D.new()
	var split_cargo: Array = game._claim_top_pieces("right", 1, test_collector)
	_check(split_cargo.is_empty() and is_equal_approx(float(worker_aggregate.get_meta("value", 0.0)), 1000.0), "Automatic collectors must also leave an indivisible grain untouched when it does not fit.")
	test_collector.free()
	game._clear_pile()
	game.cells = 0.0

	_check(game.PHASE_HIGH_THRESHOLDS == [90.0, 70.0, 52.0, 34.0, 18.0] and not game.PHASES[0].has("survive"), "Phases must unlock when Joe's high crosses its descending thresholds, never through timers or delivery targets.")
	_check(is_equal_approx(game.FIRST_WALL_HP, 1000000000000.0) and is_equal_approx(game.FIRST_LEFT_WALL_HP, 1000000000000.0), "Both fossae must begin with one trillion resistance for the expanded extraction ladder.")
	_check(is_equal_approx(game.joe_high, 90.0), "Joe must begin dangerously high at ninety percent.")
	game._improve_joe(90000.0)
	_check(game.joe_high <= 68.5, "The phase-one coefficient must turn roughly ninety thousand extracted units into the first twenty-point high threshold.")
	game.current_phase = 2
	game.joe_high = 90.0
	game._improve_joe(10000000.0)
	_check(is_equal_approx(game.joe_high, 88.0), "Phase two must use its own resistance coefficient instead of sharing one global late-game value.")
	game.current_phase = 1
	game.joe_high = 90.0
	game.joe_high_display = 90.0
	game._update_ui()
	_check(game.phase_hint.text.contains("COLOCADO") and not game.phase_hint.text.contains("%"), "Joe's next move must be communicated as a vague mood, never as a numeric pressure formula.")
	game.joe_high = 80.0
	game._update_ui()
	_check(game.phase_hint.text.contains("INQUIETO"), "The vague phase hint must warn that Joe is becoming restless.")
	game.joe_high = 71.0
	game._update_ui()
	_check(game.phase_hint.text.contains("A PUNTO"), "The phase hint must clearly become urgent just before Joe's next madness.")
	game.joe_high = 90.0
	game.joe_high_display = 90.0
	game.levels.continuous_sweep = 1
	_check(is_equal_approx(game._continuous_sweep_interval(), 0.22) and game._continuous_sweep_interval_for(3) < 0.10, "Continuous Sweep must unlock early, feel faster than repeated clicking, and support visible speed upgrades.")
	game.levels.continuous_sweep = 0
	var initial_pile_limit: int = game._pile_radius_limit("right")
	game.levels.container = 1
	_check(game._pile_radius_limit("right") > initial_pile_limit, "The pile boundary must expand naturally toward a farther storage building instead of ending at a fixed invisible wall.")
	game.levels.container_capacity = 1
	_check(is_equal_approx(game._storage_capacity(), 25000.0), "The numerical container expansion must provide a useful twenty-five-thousand-unit step before the next logistics jump.")
	game.levels.container_capacity = 0
	game.levels.container = 0
	game.levels.pawn_capacity = 2
	_check(game._transport_capacity() == 5, "Basic-pawn capacity training must keep every existing and future pawn relevant without creating a new unit.")
	game.levels.pawn_capacity = 0
	_check(game.levels.has("smart_clump"), "Smart clumping must exist as a voluntary logistics technology, separate from hostile rocks.")
	game.levels.cart = 1
	game.levels.breaker = 0
	_check(not game._upgrade_available(game._upgrade("smart_clump")), "Smart Clumping must require at least one blue helmet before normal pawns may learn it.")
	game.compaction_announced = true
	game._select_technology_unit("breaker")
	_check((game.buttons.breaker as Button).visible and (game.buttons.breaker_power as Button).visible, "The blue-helmet page must always show both quantity and strength upgrade branches once discovered.")
	game.puncher_unlocked = false
	game._finish_another_line()
	_check(game.toast.text.contains("CASCO AZUL") and not game.toast.text.contains("PÚGIL"), "The first clumping warning must point to blue helmets, never to pugilists.")
	game.puncher_unlocked = false
	game.levels.breaker = 1
	_check(game._upgrade_available(game._upgrade("smart_clump")), "Smart Clumping must unlock after cart logistics and the first blue helmet exist.")
	game.levels.smart_clump = 1
	var smart_collector := Sprite2D.new()
	for index in range(9):
		game._create_piece("grain", "right", 1.0, 0, index, 0.072)
	var smart_cargo: Array = game._claim_top_pieces("right", game._pawn_claim_capacity(smart_collector), smart_collector)
	_check(smart_cargo.size() == 9 and smart_cargo.filter(func(piece) -> bool: return piece.visible).size() == 3, "Level-one Smart Clumping must turn three base slots into three visible bundles containing nine real grains.")
	await create_timer(0.25).timeout
	var helmet_probe := Sprite2D.new()
	helmet_probe.set_meta("specialist", true)
	_check(game._pawn_claim_capacity(helmet_probe) == 3, "Blue helmets must keep their rock-handling capacity instead of receiving the normal-pawn bundle multiplier.")
	smart_collector.free()
	helmet_probe.free()
	game._clear_pile()
	game.levels.smart_clump = 0
	game.levels.breaker = 0
	game.compaction_announced = false
	game.levels.cart = 0
	game.another_line_events = 1
	_check(game._compaction_unlocked() and game._compaction_rock_limit() == 2, "The first Joe rain must introduce up to two clumps before phase two.")
	game.current_phase = 2
	_check(game._compaction_rock_limit() == 8, "After the introduction, clumping pressure must scale to eight simultaneous obstacles.")
	game.current_phase = 1
	game.another_line_events = 0
	_check(game.wall_label.text.contains("???") and not game.wall_label.text.contains("10.0B"), "Wall resistance must remain unknown during the opening.")
	game.joe_high = 80.0
	game._create_piece("grain", "right", 10000.0, 0, 0, 0.072, "", "player")
	game._update_joe_high(10.0)
	_check(is_equal_approx(game.joe_high, 80.0), "Player-mined powder on the opening pile must not cancel the high reduction it already produced.")
	game._create_piece("grain", "right", 6240.0, 0, 1, 0.072, "", "joe")
	game._update_joe_high(1.0)
	_check(is_equal_approx(game.joe_high, 80.006), "Only Joe's loose opening nuisance must add a tightly capped amount of high.")
	game._clear_pile()
	game.current_phase = 2
	game.joe_high = 80.0
	game.joe_high_display = 80.0
	game.right_hp = game.right_max
	var high_before_phase_two_click: float = game.joe_high
	game._click_wall("right")
	_check(game.joe_high < high_before_phase_two_click and is_equal_approx(game.joe_high_display, game.joe_high), "A phase-two wall click must lower both the real and visible high immediately.")
	var high_after_phase_two_click: float = game.joe_high
	game._update_joe_high(5.0)
	_check(is_equal_approx(game.joe_high, high_after_phase_two_click), "Player-mined phase-two powder must never make Joe's high rise again while it waits for transport.")
	game._clear_pile()
	game.current_phase = 1
	game.joe_high = 90.0
	game.right_hp = game.right_max * 0.01
	game._update_world()
	_check(is_equal_approx(game.right_visual.scale.x, 0.05), "A nearly exhausted cocaine wall must remain as a five-percent sliver.")
	var wall_material := game.right_visual.material as ShaderMaterial
	_check(is_equal_approx(float(wall_material.get_shader_parameter("health_ratio")), 0.01), "The detached wall-damage layer must follow the exact resistance ratio.")
	game.right_hp = game.right_max
	var effects_before_dent: int = game.effects.get_child_count()
	game._damage_wall(game.right_max * 0.01)
	_check(game.effects.get_child_count() >= effects_before_dent + 3, "Crossing each resistance percentage must visibly shed wall fragments.")
	game.right_hp = game.right_max
	game._clear_fallen_wall_chunks()
	game._damage_wall(game.right_max * 0.10)
	_check(game.fallen_wall_chunks.size() == 1, "Every ten resistance points must detach one large, separately layered wall block.")
	_check(float(game.WALL_CHUNK_SCALE) <= 0.12, "Detached blocks must remain substantially smaller than the wall section they visibly remove.")
	_check(is_equal_approx(game.right_hp, game.right_max * 0.90 - game.WALL_CHUNK_MASS), "A detached block must reserve real wall mass instead of duplicating cocaine.")
	_check(game.joe_high < 90.0 and game.joe_high_feedback.text.contains("COCAÍNA"), "Damage to the wall must immediately move and annotate Joe's central high meter.")
	game.joe_high = 90.0
	game.joe_high_display = 90.0
	var fallen := game.fallen_wall_chunks[0] as Sprite2D
	game._land_fallen_wall_chunk(fallen)
	var detached_hp := float(fallen.get_meta("hp", 0.0))
	_check(detached_hp >= 20.0 and fallen.get_node_or_null("HealthFill") == null and fallen.get_node_or_null("HealthBack") == null, "A fallen wall block must keep substantial health without the stray horizontal bar.")
	var loose_before_block: int = game.loose_chunks.size()
	game._mine_fallen_wall_chunk(fallen, 1.0)
	_check(is_instance_valid(fallen) and is_equal_approx(float(fallen.get_meta("hp", 0.0)), detached_hp - 1.0) and game.loose_chunks.size() == loose_before_block + 1, "A wall block must survive one hit and visibly release part of its stored powder.")
	game.levels.nails = 100
	var hp_before_power_click := float(fallen.get_meta("hp", 0.0))
	game._manual_mine_fallen_wall_chunk(fallen.position)
	_check(is_instance_valid(fallen) and is_equal_approx(float(fallen.get_meta("hp", 0.0)), hp_before_power_click - game.WALL_CHUNK_MAX_CLICK_DAMAGE), "Even extreme click upgrades must require several hits to break a fallen wall block.")
	game.levels.nails = 0
	game._clear_fallen_wall_chunks()
	game._clear_pile()
	game._spawn_fallen_wall_chunk("right", 2, 2.0, false)
	var blocking_chunk := game.fallen_wall_chunks[0] as Sprite2D
	var basic_block_pawn := game.pawns.get_child(0) as Sprite2D
	basic_block_pawn.set_meta("side", "right")
	basic_block_pawn.set_meta("state", "to_pile")
	basic_block_pawn.position = Vector2(game._box_x(), game._ground_y() - 14.0)
	var wall_before_block_scrape: float = game.right_hp
	var block_hp_before_pawn: float = float(blocking_chunk.get_meta("hp", 0.0))
	game._update_pawns(30.0)
	_check(is_equal_approx(float(blocking_chunk.get_meta("hp", 0.0)), block_hp_before_pawn) and is_equal_approx(game.right_hp, wall_before_block_scrape), "Only the player may damage a fallen wall block.")
	_check(basic_block_pawn.position.x >= blocking_chunk.position.x + 42.0 and basic_block_pawn.get_meta("state", "") == "to_pile", "An empty pawn must wait on the box side of a fallen wall block.")
	_check(blocking_chunk.get_parent() == game.wall_chunks_layer and game.wall_chunks_layer.get_index() > game.chunks.get_index(), "Fallen wall blocks must stay in a foreground layer above loose powder.")
	game.levels.puncher = 1
	game._rebuild_punchers()
	var recalled_puncher := game.punchers.get_child(0) as Sprite2D
	recalled_puncher.set_meta("state", "to_wall")
	recalled_puncher.position.x -= 36.0
	game._update_punchers(30.0)
	_check(is_equal_approx(float(blocking_chunk.get_meta("hp", 0.0)), block_hp_before_pawn) and is_zero_approx(game._auto_hit_rate()), "Pugilists must leave the obstruction exclusively to the player.")
	_check(recalled_puncher.get_meta("state", "") == "idle", "A blocked pugilist must return home instead of freezing halfway through its route.")
	game.levels.puncher = 0
	game._rebuild_punchers()
	await process_frame
	var block_click_position := blocking_chunk.position
	var block_clicks := 0
	while not game.fallen_wall_chunks.is_empty() and block_clicks < 30:
		game._manual_mine_fallen_wall_chunk(block_click_position)
		block_clicks += 1
	_check(game.fallen_wall_chunks.is_empty() and block_clicks == int(game.WALL_CHUNK_HEALTH), "A fresh block must require its full resistance in manual clicks before the route opens.")
	var blocked_x := basic_block_pawn.position.x
	game._update_pawns(0.5)
	_check(basic_block_pawn.position.x < blocked_x, "Workers must resume their route as soon as the player clears the block.")
	game._clear_fallen_wall_chunks()
	game._clear_pile()
	game.right_hp = game.right_max
	game._update_world()
	_check(not game.break_button.visible, "The nose tunneller must stay locked before its technology phase regardless of wall health.")
	game.current_phase = game.TUNNEL_UNLOCK_PHASE
	game._update_world()
	_check(game.break_button.visible, "The nose tunneller must unlock with spray-era technology even while both walls remain intact.")
	game._open_septum()
	_check(game.septum_open and game.active_side == "left", "The nose tunneller must open the second fossa for active play.")
	game.septum_open = false
	game.active_side = "right"
	game.current_phase = 1
	game.right_hp = 1.0
	game.right_cleared = 0
	game._damage_wall(1.0, "right")
	_check(is_equal_approx(game.right_hp, 0.0) and is_equal_approx(game.right_visual.scale.x, 0.0), "An exhausted wall must disappear instead of resetting visually.")
	game._damage_wall(1.0, "right")
	_check(is_equal_approx(game.right_hp, 0.0), "Further damage must never regenerate an exhausted wall.")
	game.right_hp = game.right_max
	game.right_cleared = 0
	game._update_world()

	# Transport pawns only collect: wall extraction belongs to the player and pugilists.
	var basal_pawn := game.pawns.get_child(0) as Sprite2D
	var wall_before_scrape: float = game.right_hp
	var pile_before_scrape: int = game.loose_chunks.size()
	basal_pawn.set_meta("state", "working")
	basal_pawn.set_meta("timer", 0.0)
	game._update_pawns(0.01)
	_check(is_equal_approx(game.right_hp, wall_before_scrape), "A transport pawn must never mine the cocaine wall.")
	_check(game.loose_chunks.size() == pile_before_scrape, "A transport pawn must not create grains while collecting.")
	game._clear_pile()

	# The unavoidable two-minute line is low-value logistical sabotage scaled from recent mining.
	game._update_ui()
	_check(not (game.buttons.puncher as Button).visible, "The pugilist must not be available at the beginning.")
	game.mined_since_line = 500.0
	game.another_line_clock = 0.0
	var high_before_line: float = game.joe_high
	game._update_another_line(0.01)
	var expected_flood: int = game.another_line_wave
	var safety := 500
	while game.another_line_wave > 0 and safety > 0:
		game._update_another_line(0.20)
		safety -= 1
	_check(is_equal_approx(game.ANOTHER_LINE_INTERVAL, 120.0) and expected_flood == 240 and game.loose_chunks.size() == expected_flood, "The first Otra rayita must be a clearly visible rain of 240 real grains.")
	_check(is_equal_approx(game._pile_load("right"), 240.0) and game.loose_chunks.all(func(piece) -> bool: return is_equal_approx(float(piece.get_meta("value", 0.0)), 1.0) and piece.get_meta("source", "") == "joe"), "Every Joe grain must remain an indivisible one-unit nuisance rather than an aggregated transport shortcut.")
	_check(game._another_line_grain_count(100000.0) == 1600 and game._another_line_grain_count(2000000.0) == 4000, "Joe's line must scale into a real logistical storm at industrial extraction levels.")
	_check(game.joe_high > high_before_line, "Joe's extra line must visibly increase his high.")
	var wave_columns := {}
	for piece in game.loose_chunks:
		var column := int(piece.get_meta("column", 0))
		wave_columns[column] = int(wave_columns.get(column, 0)) + 1
	var tallest_wave_column := 0
	for count in wave_columns.values():
		tallest_wave_column = maxi(tallest_wave_column, int(count))
	_check(wave_columns.size() >= 8, "Otra rayita must create several connected hills instead of one vertical needle.")
	_check(wave_columns.size() <= 44 and tallest_wave_column >= 5, "Otra rayita must retain meaningful vertical relief instead of becoming a flat flood.")
	game._select_technology_unit("pugilist")
	_check(game.puncher_unlocked and (game.buttons.puncher as Button).visible, "The first extra line must unlock the pugilist adaptation on its own page.")
	_check((game.buttons.puncher as Button).has_theme_stylebox_override("normal"), "The newly mandatory pugilist must receive the blue halo.")
	game._clear_pile()
	var outlined_player_grain = game._create_piece("grain", "right", 4.0, 0, 0, 0.072)
	_check(outlined_player_grain.material == game.PLAYER_GRAIN_MATERIAL, "Player-mined grains must differ from Joe's only through the dedicated pronounced outline layer.")
	game._clear_pile()

	# Pugilists keep their visible run while their numerical damage escalates hard.
	game.cells = 2000.0
	var clicks_before_debut: int = game.total_clicks
	game._buy("puncher")
	_check(game.puncher_debut_pending and game.punchers.get_child_count() == 1, "The first pugilist must visibly prepare its debut.")
	game._buy("punch_power")
	_check(int(game.levels.punch_power) == 0, "The first pugilist evolution must stay locked throughout phase one.")
	var debut_puncher := game.punchers.get_child(0) as Sprite2D
	var debut_home_x: float = debut_puncher.position.x
	game._update_punchers(1.40)
	_check(debut_puncher.get_meta("state", "") == "to_wall" and game.loose_chunks.is_empty(), "The debut must begin with a real walk toward the wall, not a remote hit.")
	game._update_punchers(0.10)
	_check(debut_puncher.position.x < debut_home_x, "A right-side pugilist must physically approach the cocaine wall.")
	_check(not debut_puncher.flip_h, "A right-side pugilist walking left toward the wall must visibly face left.")
	var debut_safety := 80
	while game.loose_chunks.size() < game.PUGILIST_GRAINS_PER_HIT and debut_safety > 0:
		game._update_punchers(0.08)
		debut_safety -= 1
	_check(game.loose_chunks.size() == 10 and game.total_clicks == clicks_before_debut + 50, "The first pugilist rank must deal fifty units as exactly ten rendered grains.")
	_check(game.loose_chunks.all(func(piece) -> bool: return is_equal_approx(float(piece.get_meta("value", 0.0)), 5.0)), "Every opening pugilist grain must be worth five: ten times five equals the displayed fifty damage.")
	var punch_labels: Array = game.effects.get_children().filter(func(node: Node) -> bool: return node is Label and (node as Label).text.contains("PUM"))
	_check(not punch_labels.is_empty() and (punch_labels.back() as Label).text.contains("-50") and not (punch_labels.back() as Label).text.contains("BOLAS"), "The impact feedback must show only total damage, never the internal ten-ball formula.")
	_check(absf(debut_puncher.position.x - game._puncher_strike_position(debut_puncher).x) < 0.6, "The punch must resolve at the visible edge of the cocaine wall.")
	_check(game.punchers.get_child(0).get_node_or_null("BoxingGlove") != null, "Pugilists must be distinguished by a separate boxing-glove layer.")
	game._clear_pile()

	# Extraction, logistics and storage advance as an interlocked sequence instead of isolated tiny percentages.
	game.levels.container = 1
	game.levels.cart = 1
	game.levels.container_capacity = 1
	_check(game._upgrade_available(game._upgrade("cart_reinforced")) and game._upgrade_available(game._upgrade("punch_union")), "The cart jump must wait for the 25K store while the Punch Union remains a parallel extraction choice.")
	game._select_technology_unit("cart")
	_check((game.buttons.cart_reinforced as Button).visible, "The cart capacity upgrade must appear inside the cart page.")
	_check((game.buttons.cart_upgrade as Button).visible and (game.buttons.cart_upgrade as Button).disabled, "The 300-unit cart tier must stay visible but locked until the modular warehouse.")
	_check((game.buttons.shift as Button).visible and (game.buttons.shift as Button).disabled, "The motorway must stay visible but locked until the player buys one of the two tier upgrades.")
	game.cells = 200000.0
	game._buy("cart_reinforced")
	game._buy("warehouse")
	game._buy("cart_upgrade")
	await process_frame
	game._select_technology_unit("cart")
	var upgraded_cart := game.transporters.get_children().filter(func(node: Node) -> bool: return node.get_meta("transport_kind", "") == "cart").front() as Node2D
	_check(is_equal_approx(float(upgraded_cart.get_meta("capacity", 0.0)), 300.0) and upgraded_cart.get_node_or_null("Trailer") == null, "Cart upgrades must create a real 300-unit logistics jump without spawning another unit or wagon.")
	_check(is_equal_approx(game._storage_capacity(), 100000.0), "The 300-unit cart may only arrive after storage has expanded to one hundred thousand.")
	_check((game.buttons.shift as Button).visible, "Buying either tier upgrade must reveal the late phase-one speed jump.")
	game._select_technology_unit("pugilist")
	game._buy("punch_union")
	game._buy("punch_training")
	game._buy("punch_speed")
	await process_frame
	_check(game._puncher_count() == 3 and game.punchers.get_child_count() == 3, "The Punch Union must add exactly two basic pugilists without advancing their rank.")
	_check(game._punch_output() == 150 and is_equal_approx(game._punch_interval(), 2.5), "Phase-one Pugilist training must triple damage and visibly cut the four-second rest to two and a half seconds.")
	_check(game.punchers.get_child(0).get_node_or_null("ProteinWrap") != null, "The large numerical Pugilist training must receive a small layered wrist-wrap variation.")
	game._buy("shift")
	await process_frame
	_check(is_equal_approx(game._pawn_speed(), game.BASE_PAWN_SPEED * 1.60), "The Lymphatic Motorway must increase pawn movement by sixty percent.")
	var motorway_cart := game.transporters.get_children().filter(func(node: Node) -> bool: return node.get_meta("transport_kind", "") == "cart").back() as Node2D
	_check(is_equal_approx(float(motorway_cart.get_meta("speed", 0.0)), game.CART_SPEED * 2.0), "The Lymphatic Motorway must double ground-transport speed.")
	_check(is_equal_approx(game._ox_capacity(), 10000.0) and is_equal_approx(game._ox_capacity(2), 6500000.0), "The Mugidophile must begin with its ten-thousand to six-and-a-half-million phase-two curve.")
	game.levels.cart_upgrade = 0
	game.levels.cart_reinforced = 0
	game.levels.warehouse = 0
	game.levels.container_capacity = 0
	game.levels.punch_union = 0
	game.levels.punch_training = 0
	game.levels.punch_speed = 0
	game.levels.shift = 0
	game._rebuild_transporters()
	game._rebuild_punchers()

	game.levels.puncher = 2
	game.levels.punch_power = 1
	game.puncher_debut_pending = false
	game.playing = false
	game._rebuild_punchers()
	await process_frame
	game.playing = true
	game.punch_clock = 0.0
	var chunks_before_round: int = game.loose_chunks.size()
	game._update_punchers(game._punch_interval())
	_check(not game._punchers_idle() and game.loose_chunks.size() == chunks_before_round, "A regular automatic round must also travel before dealing damage.")
	var round_safety := 120
	while game.loose_chunks.size() < chunks_before_round + 20 and round_safety > 0:
		game._update_punchers(0.08)
		round_safety -= 1
	_check(game.loose_chunks.size() == chunks_before_round + 20, "Two federated pugilists must each create the same readable ten-particle impact.")
	_check(game.loose_chunks.all(func(piece) -> bool: return is_equal_approx(float(piece.get_meta("value", 0.0)), 50.0)), "Federated pugilists must release ten grains of fifty units each.")
	var return_safety := 120
	var saw_puncher_facing_home := false
	while not game._punchers_idle() and return_safety > 0:
		game._update_punchers(0.08)
		var returning_puncher := game.punchers.get_child(0) as Sprite2D
		if returning_puncher.get_meta("state", "") == "returning" and returning_puncher.flip_h:
			saw_puncher_facing_home = true
		return_safety -= 1
	_check(game._punchers_idle(), "Pugilists must return to their waiting positions after punching.")
	_check(saw_puncher_facing_home, "A right-side pugilist must turn right before walking back home.")
	var mirrored_glove := (game.punchers.get_child(0) as Sprite2D).get_node("BoxingGlove") as Polygon2D
	(game.punchers.get_child(0) as Sprite2D).set_meta("side", "left")
	game._place_puncher(game.punchers.get_child(0) as Sprite2D)
	_check(mirrored_glove.scale.x < 0.0, "A left-side pugilist must mirror its separate glove layer toward the wall.")
	game._clear_pile()

	# Each phase adds a separate readable extraction actor with deliberately absurd numbers.
	game.active_side = "right"
	game.levels.ram = 1
	game.levels.elephant = 1
	game.levels.plasma_cannon = 1
	game.levels.supersaiyan = 1
	game._rebuild_punchers()
	await process_frame
	var special_extractors: Array = game.punchers.get_children().filter(func(node: Node) -> bool: return not str(node.get_meta("extraction_kind", "")).is_empty())
	_check(special_extractors.size() == 4, "Ram, elephant, plasma cannon and Supersaiyan must each exist as their own layered actor.")
	for extractor in special_extractors:
		var kind := str(extractor.get_meta("extraction_kind", ""))
		var sprite := extractor.get_node("Sprite") as Sprite2D
		var visual_foot := (extractor as Node2D).position.y + sprite.position.y + float(game.SPECIAL_SPRITE_FOOT_PIXELS[kind]) * sprite.scale.y
		_check(absf(visual_foot - game._ground_y()) < 0.1, "%s must be anchored by its last opaque pixel instead of sinking below the floor." % kind)
	_check(is_equal_approx(game._special_extractor_damage("ram"), 500000.0) and is_equal_approx(game._special_extractor_damage("elephant"), 15000000.0) and is_equal_approx(game._special_extractor_damage("plasma"), 5000000000.0) and is_equal_approx(game._special_extractor_damage("supersaiyan"), 15000000000.0), "The extraction ladder must rise from a five-hundred-thousand ram charge to a fifteen-billion final Kamehameha.")
	game.right_hp = game.right_max
	var ram := special_extractors.filter(func(node: Node) -> bool: return node.get_meta("extraction_kind", "") == "ram")[0] as Node2D
	var ram_home_x := ram.position.x
	ram.set_meta("state", "idle")
	ram.set_meta("timer", 0.0)
	game._update_special_extractors(0.01)
	game._update_special_extractors(0.70)
	_check(ram.get_meta("state", "") == "to_wall" and ram.position.x > ram_home_x, "The Leucoram must visibly back away before beginning its charge.")
	var wall_before_ram: float = game.right_hp
	ram.set_meta("state", "to_wall")
	ram.position = Vector2(game._wall_free_x("right") + 52.0, game._ground_y())
	game._update_special_extractors(0.02)
	_check(is_equal_approx(game.right_hp, wall_before_ram - 500000.0), "The Leucoram must deal its own five-hundred-thousand impact only after reaching the wall.")
	ram.set_meta("state", "idle")
	ram.set_meta("timer", 100.0)
	game._clear_pile()
	game.right_hp = game.right_max
	var wall_before_elephant: float = game.right_hp
	var elephant := special_extractors.filter(func(node: Node) -> bool: return node.get_meta("extraction_kind", "") == "elephant")[0] as Node2D
	elephant.set_meta("state", "to_wall")
	elephant.position = Vector2(game._wall_free_x("right") + 76.0, game._ground_y())
	game._update_special_extractors(0.02)
	_check(is_equal_approx(game.right_hp, wall_before_elephant - 15000000.0), "The elephant must deal its fifteen-million headbutt only after physically reaching the wall.")
	game._update_special_extractors(0.60)
	game._update_special_extractors(0.02)
	_check((elephant.get_node("Sprite") as Sprite2D).flip_h, "The elephant must turn around before walking back from the right-side wall.")
	game._clear_pile()
	game.right_hp = game.right_max
	var wall_before_cannon: float = game.right_hp
	elephant.set_meta("state", "idle")
	elephant.set_meta("timer", 100.0)
	var cannon := special_extractors.filter(func(node: Node) -> bool: return node.get_meta("extraction_kind", "") == "plasma")[0] as Node2D
	cannon.set_meta("timer", 0.0)
	var waiting_supersaiyan := special_extractors.filter(func(node: Node) -> bool: return node.get_meta("extraction_kind", "") == "supersaiyan")[0] as Node2D
	waiting_supersaiyan.set_meta("timer", 100.0)
	game._update_special_extractors(0.01)
	_check(game.effects.get_node_or_null("PlasmaOrb") != null and game.effects.get_node("PlasmaOrb").get_node_or_null("Core") != null, "The plasma cannon must launch an energy orb instead of firing another Pugilist.")
	await create_timer(0.6).timeout
	_check(is_equal_approx(game.right_hp, wall_before_cannon - 5000000000.0), "The phase-four plasma cannon must apply its five-billion hit only after the visible orb reaches the wall.")
	game._clear_pile()
	game.right_hp = game.right_max
	var wall_before_supersaiyan: float = game.right_hp
	var supersaiyan := waiting_supersaiyan
	supersaiyan.set_meta("timer", 0.0)
	game._update_special_extractors(0.01)
	_check(is_equal_approx(game.right_hp, wall_before_supersaiyan - 15000000000.0), "The final Supersaiyan must resolve into a fifteen-billion Kamehameha without erasing a trillion-point wall.")
	game._clear_pile()
	game.levels.ram = 0
	game.levels.elephant = 0
	game.levels.plasma_cannon = 0
	game.levels.supersaiyan = 0
	game._rebuild_punchers()
	game.right_hp = game.right_max

	# Manual upgrades create a visible rhythmic burst without changing the click count.
	game.levels.click_burst = 2
	game.levels.click_rhythm = 0
	game.manual_clicks_since_burst = 9
	var clicks_before_burst: int = game.total_clicks
	var wall_before_burst: float = game.right_hp
	game._click_wall("right")
	_check(game.loose_chunks.size() == 3, "A level-two manual burst must add two full-power grains to the normal clicked grain.")
	_check(game.loose_chunks.all(func(piece) -> bool: return is_equal_approx(float(piece.get_meta("value", 0.0)), game._click_power())), "Every keratin burst grain must carry the player's complete current click power.")
	_check(game.total_clicks == clicks_before_burst + 1 and is_equal_approx(game.right_hp, wall_before_burst - game._click_power() * 3.0), "A burst must amplify one manual click without pretending to be several clicks.")
	game._clear_pile()

	# Phase 1 also requires visible logistics investment.
	game.levels.pawn = 1
	game.levels.shift = 1
	game.levels.container = 1
	game.levels.cart = 1
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	_check(is_equal_approx(game._storage_capacity(), 5000.0), "The emergency container must raise storage from 1,000 to 5,000 real units.")
	_check(game.transporters.get_children().any(func(node: Node) -> bool: return node.get_meta("transport_kind", "") == "cart"), "Buying the container and cart must create a separate visible transporter.")
	var storage_readouts: Array = game.infrastructure.get_children().filter(func(node: Node) -> bool: return bool(node.get_meta("storage_readout", false)) and not node.is_queued_for_deletion())
	var storage_readout: Node = storage_readouts.back() if not storage_readouts.is_empty() else null
	_check(storage_readout != null and (storage_readout.get_node("Value") as Label).text.contains("/ 5.0K"), "Every storage evolution must retain a local exact fill readout.")
	_check(storage_readout.get_node_or_null("Fill") == null and storage_readout.get_node_or_null("Background") == null, "The redundant local storage bar must be removed while preserving the exact number.")
	var cart: Node = game.transporters.get_children().filter(func(node: Node) -> bool: return node.get_meta("transport_kind", "") == "cart")[0]
	_check(cart.get_node_or_null("LoadReadout") != null and (cart.get_node("LoadReadout") as Label).text.contains("0 / 12"), "The cart must visibly identify its own load and capacity.")
	_check(not (cart.get_node("Puller") as Sprite2D).flip_h, "The cart puller must retain the native left-facing pose inside the left-authored composition.")
	game._update_ui()
	var upgrade_lines := (game.buttons.nails as Button).text.split("\n")
	_check(upgrade_lines.size() >= 2 and upgrade_lines[1].begins_with("◆ COSTE"), "Every purchasable upgrade must place its prominent price on the same fixed second line.")
	game.current_phase = 1
	game.phase_event_pending = false
	game.pending_phase_debut = 0
	game.joe_high = 70.0
	game._check_phase_progress()
	_check(game.current_phase == 2, "Phase two must unlock exactly when Joe falls to seventy percent high.")
	_check(game.playing and not game.joe_dialog.visible, "A high threshold must never stop play with a phase modal.")
	game._resume_after_joe()
	_check(is_equal_approx(game.joe_high, 70.0), "Entering phase two must never steal storage or erase high progress with an automatic rebound.")
	_check(game._upgrade("umbrella").is_empty() and game.UNIT_CATALOG.all(func(unit: Dictionary) -> bool: return str(unit.id) != "umbrella"), "The umbrella unit and all of its technologies must be absent from the game catalogue.")
	game._select_technology_unit("breaker")
	_check((game.buttons.breaker as Button).text.contains("NECESARIA"), "A new phase must explain which adaptation is mandatory.")
	_check((game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The mandatory adaptation must receive a blue halo.")
	game.levels.punch_training = 1
	game.cells = 100000.0
	game._buy("punch_power")
	_check(int(game.levels.punch_power) == 1, "Phase two must unlock exactly the federated pugilist evolution.")
	_check((game.punchers.get_child(0) as Sprite2D).get_node_or_null("RankBelt") != null, "A pugilist evolution must change separate visible equipment layers, not only its numbers.")
	game._buy("punch_power")
	_check(int(game.levels.punch_power) == 1, "Phase two must not allow buying the phase-three pugilist evolution early.")
	game.cells = 20000000.0
	var pre_phase_two_bridge_damage: int = game._punch_output()
	game._buy("bronchial_rage")
	await process_frame
	_check(game._punch_output() == pre_phase_two_bridge_damage * 2, "Double-Shift Rage must be the first phase-two extraction jump and double the whole squad.")
	_check((game.punchers.get_child(0) as Sprite2D).get_node_or_null("BronchialPatch") != null, "Double-Shift Rage must retain its separate visual equipment layer on existing Pugilists.")
	game.levels.warehouse = 1
	var pre_reserve_count: int = game._puncher_count()
	game._buy("punch_reserves")
	_check(game._puncher_count() == mini(8, pre_reserve_count + 2), "Split-Shift Interns must add two existing-style Pugilists instead of a new creature type.")
	game.levels.cart_upgrade = 1
	game.cells = 20000000.0
	game._buy("silo")
	_check(is_equal_approx(game._storage_capacity(), 2000000.0), "Phase two must open a two-million-unit silo before its first freight-scale transport purchase.")
	game._buy("punch_combo")
	game.punch_round_count = 4
	game._perform_punch_round(false)
	_check(bool((game.punchers.get_child(0) as Sprite2D).get_meta("combo_round", false)), "Combo de Bar must mark every fifth squad round as a double hit.")
	var pre_wrap_interval: float = game._punch_interval()
	game._buy("uranium_wraps")
	await process_frame
	_check(is_equal_approx(game._punch_interval(), pre_wrap_interval * 0.8), "Uranium wraps must visibly cut another twenty percent from Pugilist rest time.")
	_check((game.punchers.get_child(0) as Sprite2D).get_node_or_null("UraniumWrap") != null, "Uranium wraps must remain an independent editable art layer.")
	game._buy("cart_freight")
	_check(is_equal_approx(game._cart_capacity(), 1500.0), "Palletized freight must raise the existing cart to 1,500 units without adding another vehicle.")
	game._buy("ox_convoy")
	game._buy("silo_capacity")
	_check(is_equal_approx(game._storage_capacity(), 10000000.0), "The heavy convoy upgrade path must expand storage to ten million before improving the Mugidophile.")
	game._buy("ox_capacity")
	game._buy("ox_capacity")
	_check(is_equal_approx(game._ox_capacity(), 6500000.0), "Two heavy-load upgrades must produce a visible 10K to 150K to 6.5M Mugidophile curve.")
	game.current_phase = 3
	game.levels.vault = 1
	game.cells = 50000000.0
	game._buy("ox_vault_capacity")
	_check(is_equal_approx(game._ox_capacity(), 100000000.0), "Vault Ruminating must raise the existing Mugidophile to one hundred million without spawning a second unit.")
	game.cells = 75000000.0
	game._buy("vault_capacity")
	_check(is_equal_approx(game._storage_capacity(), 1000000000.0), "The same vault must gain a one-billion intermediate storage tier before the plant.")
	game.current_phase = 4
	game.septum_open = true
	game.levels.plant = 1
	game.cells = 400000000.0
	game._buy("ox_plasma_capacity")
	_check(is_equal_approx(game._ox_capacity(), 10000000000.0), "Plasma Logistics must raise the existing Mugidophile to ten billion without spawning a second unit.")
	game.current_phase = 2
	game.septum_open = false
	game._select_technology_unit("pawn")
	_check((game.buttons.coord as Button).visible and (game.buttons.coord as Button).disabled, "Work in Chain must be visible but locked before the septum is open.")
	game.septum_open = true
	game._update_ui()
	_check((game.buttons.coord as Button).visible, "Work in Chain may appear only after both fossae are unlocked.")
	game.septum_open = false

	game.levels.breaker = 1
	game._rebuild_pawns()
	game.rocks_opened = 12
	game._update_ui()
	_check(not (game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The halo must disappear after buying the mandatory adaptation.")
	game.joe_high = 52.0
	game._check_phase_progress()
	_check(game.current_phase == 3, "Adulterated cocaine must unlock when Joe falls to fifty-two percent high.")
	game._resume_after_joe()

	# Phase 3 keeps its formulas hidden: players read the dirty box and slower animation.
	game.levels.detector = 0
	game.contamination = 0.0
	game._select_technology_unit("detector")
	_check((game.buttons.detector as Button).text.contains("NECESARIA"), "Phase 3 must point directly at the receptor adaptation.")
	_check((game.buttons.wall_scan as Button).visible and (game.buttons.wall_scan as Button).disabled and game.wall_label.text.contains("???"), "Exact wall resistance must remain visible but unavailable until the adulterant detector exists.")
	game.levels.detector = 1
	game.cells = 10000.0
	game._update_ui()
	_check((game.buttons.wall_scan as Button).visible, "The wall scan may appear only after the phase-three adulterant analysis.")
	game._buy("wall_scan")
	game._update_ui()
	_check(game.wall_label.text.contains(game._number(game.right_hp)) and not game.wall_label.text.contains("???"), "Buying the nasal radiograph must reveal the exact remaining wall resistance.")
	game.levels.detector = 0
	var pawn := game.pawns.get_child(0) as Sprite2D
	var rubbish = game._create_piece("impurity", "right", 1.0, 0, 0, 0.064, "serrín")
	rubbish.set_meta("carried", true)
	pawn.set_meta("cargo", [rubbish])
	var cells_before: float = game.cells
	game._finish_delivery(pawn)
	_check(is_equal_approx(game.cells, cells_before), "Undetected adulterants must waste a transport trip.")
	_check(game.contamination > 0.0 and game.contamination < 1.0, "One adulterant must contaminate the box gradually.")
	_check(is_equal_approx(game._impurity_contamination("serrín", 1000.0), 0.35) and is_equal_approx(game._impurity_contamination("yeso", 1000.0), 0.55), "Contamination must scale by collected dirty pieces, not explode with their late-game economic value.")
	_check(game._deposit_duration() > 0.30 and game._box_yield_multiplier() < 1.0, "Contamination must still have a meaningful hidden mechanical penalty.")
	game._update_crisis_visuals()
	game._update_pressure_visuals()
	_check(not game.contamination_meter.visible, "Exact contamination metrics must stay hidden from the player.")
	_check(game.box.modulate != Color.WHITE, "The box itself must visibly become dirty.")
	_check(not game.pressure_label.text.contains("%") and not game.pressure_label.text.contains("CÉLULAS"), "The normal UI must describe the box qualitatively without exposing its formula.")
	game.contamination = 100.0
	game.box_jammed = false
	game._update_box_jam(0.0)
	var frozen_position := pawn.position
	game._update_pawns(1.0)
	_check(game.box_jammed and pawn.position == frozen_position and is_zero_approx(game._rate()) and is_zero_approx(game._auto_hit_rate()), "A fully contaminated box must visibly stop every worker and all automatic production.")
	game.joe_high = 99.9
	game.playing = true
	game._update_joe_high(2.0)
	_check(game.overdose_active and not game.playing and game.overdose_dialog.visible, "A jammed run must be able to end in a visible overdose at one hundred percent high.")
	_check(game.overdose_dialog.dialog_text.contains("muerto por gilipollas") and game.overdose_dialog.ok_button_text.contains("CARGAR") and game.overdose_dialog.cancel_button_text.contains("MENÚ"), "The death dialog must explicitly ask whether to load instead of doing it automatically.")
	game._return_to_menu_after_overdose()
	_check(game.start_screen.visible and not game.playing, "Refusing to load after an overdose must return safely to the main menu.")
	game.start_screen.hide()
	game.joe_high = 70.0
	game.joe_high_display = 70.0
	game.playing = true
	var blocked_grain = game._create_piece("grain", "right", 1.0, 0, 0, 0.072)
	_check(game._manual_collect_at(blocked_grain.position) and not bool(blocked_grain.get_meta("carried", false)), "A jammed box must reject manual deliveries too.")
	game.levels.detector = 1
	game.levels.sponge = 1
	game._update_box_jam(4.0)
	_check(game.box_jammed and game.contamination < 100.0, "Quimioreceptors must clean a jammed box slowly while visible workers remain stopped.")
	game.contamination = 85.0
	game._update_box_jam(0.0)
	_check(not game.box_jammed, "Workers must resume only after the emergency cleaning threshold is reached.")
	game._clear_pile()

	game._rebuild_pawns()
	var ordinary_pawn: Sprite2D = null
	for child in game.pawns.get_children():
		var candidate := child as Sprite2D
		if candidate and bool(candidate.get_meta("detector", false)):
			pawn = candidate
		elif candidate and not bool(candidate.get_meta("handler", false)):
			ordinary_pawn = candidate
	game._create_piece("impurity", "right", 10.0, 0, 0, 0.064, "yeso")
	var ordinary_cargo: Array = game._claim_top_pieces("right", 3, ordinary_pawn)
	_check(ordinary_cargo.is_empty(), "Once receptors exist, ordinary and blue-helmet cells must refuse every detected adulterant.")
	game._clear_pile()
	var contamination_before_cleaning: float = game.contamination
	var sorted = game._create_piece("impurity", "right", 1.0, 0, 0, 0.064, "yeso")
	sorted.set_meta("carried", true)
	pawn.set_meta("cargo", [sorted])
	game._finish_delivery(pawn)
	_check(game.cells > cells_before, "Quimioreceptors must recover some value from separated impurities.")
	_check(game.contamination < contamination_before_cleaning, "Quimioreceptors must clean existing box contamination.")
	_check(contamination_before_cleaning - game.contamination < 1.0, "A detector must clean the box gradually.")

	game._clear_pile()
	game._trigger_chalk()
	_check(is_equal_approx(game._pile_load("right"), game.CHALK_UNITS) and game._kind_count("impurity") == 60, "The independent chalk event must add 600 real units every cycle.")
	game._clear_pile()
	game.joe_high = 34.0
	game._check_phase_progress()
	_check(game.current_phase == 4, "Spray and mucus must unlock when Joe falls to thirty-four percent high.")
	game._resume_after_joe()
	_check(game.spray_pending and game.mucus_clock <= 60.0, "The spray phase must debut with spray and schedule its first mucus blockage shortly afterwards.")
	game.levels.sponge = 2
	game.levels.sponge_power = 5
	game._rebuild_adaptations()
	await process_frame
	game.right_hp = game.right_max - 5000.0
	var wall_before_spray_line: float = game.right_hp
	game.spray_film_hp = 0.0
	game.spray_film_max = 0.0
	game.playing = false
	game._trigger_spray()
	await process_frame
	_check(game.spray_pending and game.joe_events.get_child_count() >= 20, "The spray must appear as a clearly visible blue rain thirty seconds before the line.")
	var spray_coats: Array = game.joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "spray_coat")
	_check(spray_coats.size() == 7 and spray_coats.all(func(node: Node) -> bool: return absf((node as Node2D).position.x - game._wall_center_x("right")) <= 40.0), "The blue spray coat must form a clearly readable curtain attached to the cocaine wall.")
	_check(is_equal_approx(game.spray_film_hp, game.SPRAY_FILM_UNITS), "Spray must create a persistent film measured in real units.")
	game.playing = true
	game._click_wall("right")
	_check(is_equal_approx(game.right_hp, wall_before_spray_line), "Neither the player nor automatic miners may mine through the spray film.")
	var sponge_rate: float = game._sponge_absorb_rate()
	game._update_joe_events(1.0)
	_check(is_equal_approx(game.spray_film_hp, maxf(0.0, game.SPRAY_FILM_UNITS - sponge_rate)), "Sponge upgrades must remove the exact number of spray units shown in the shop.")
	game._update_joe_events(1.0)
	_check(is_zero_approx(game.spray_film_hp), "Two fully upgraded sponge macrophages must visibly clear the film instead of supplying an abstract percentage.")

	game.joe_high = 18.0
	game._check_phase_progress()
	_check(game.current_phase == 5, "Hemorrhage and infection must unlock when Joe falls to eighteen percent high.")
	game._resume_after_joe()

	game.levels.platelets = 2
	game.levels.repair = 2
	game.tissue_damage = 50.0
	game._rebuild_platelets()
	game._update_crisis(1.0)
	_check(game.tissue_damage < 50.0, "Enough platelets must reduce tissue damage while cleaning continues.")
	_check(game.platelets.get_child_count() == 4, "Platelet upgrades must create visible layered workers.")
	game.box_jammed = true
	var damage_before_jammed_repair: float = game.tissue_damage
	game._update_crisis(1.0)
	_check(game.tissue_damage > damage_before_jammed_repair, "A full-box jam must stop platelet repair as well as transport and punching.")
	game.box_jammed = false
	_check(game.damage_meter.visible and game.blood_drops.get_child_count() > 0, "Phase 5 must show a damage meter and falling blood drops.")
	_check(game.get_node("World/JoeHigh").visible and game.joe_high_label.text.contains("COLOCÓN"), "The permanent Joe meter must be named and shown as his high, not as the removed prognosis.")
	_check(game.get_node_or_null("World/StageViewport/Stage/Layer46_Crisis/LeftWound") == null, "The old red wound domes must be removed.")
	game.tissue_damage = 10.0
	game.joe_high = 40.0
	game._trigger_scratch()
	var visible_wounds: Array = game.joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "wound")
	_check(is_equal_approx(game.tissue_damage, 10.0 + game.SCRATCH_DAMAGE) and is_equal_approx(game.joe_high, 40.0 + game.SCRATCH_HIGH_GAIN), "Joe's recurring scratch must add explicit tissue damage and high.")
	_check(visible_wounds.size() >= 3, "The scratch must create several grounded fissures instead of a red dome.")

	game.levels.handlers = 1
	game._rebuild_pawns()
	var handler: Sprite2D = null
	for child in game.pawns.get_children():
		var candidate := child as Sprite2D
		if candidate and bool(candidate.get_meta("handler", false)):
			handler = candidate
			break
	_check(is_instance_valid(handler), "The glove adaptation must create a visible bacteria handler.")
	if is_instance_valid(handler):
		game._clear_pile()
		var loose_bacterium = game._create_piece("bacteria", "right", 2.0, 0, 0, 0.08)
		var normal: Sprite2D = null
		for child in game.pawns.get_children():
			var candidate := child as Sprite2D
			if candidate and not bool(candidate.get_meta("handler", false)):
				normal = candidate
				break
		_check(is_instance_valid(normal) and game._claim_top_pieces("right", 1, normal).is_empty(), "Normal white cells must never claim bacteria.")
		_check(not normal.has_meta("bitten_until"), "Bacteria must not apply the removed bite slowdown.")
		game.infection = 50.0
		loose_bacterium.set_meta("carried", true)
		handler.set_meta("cargo", [loose_bacterium])
		game._finish_delivery(handler)
		_check(game.infection < 50.0, "Handlers must contain infection without a combat system.")

	game.levels.catapult = 1
	game.levels.catapult_power = 2
	game._rebuild_adaptations()
	await process_frame
	game.mucus_hp = 0.0
	game.mucus_max_hp = 0.0
	game._trigger_mucus()
	var mucus_patches: Array = game.joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "mucus")
	_check(mucus_patches.size() >= 5 and mucus_patches.all(func(node: Node) -> bool: return absf((node as Node2D).position.x - game._wall_center_x("right")) <= 40.0), "Mucus must visibly coat the wall instead of floating beside it.")
	var wall_before_mucus_click: float = game.right_hp
	var mucus_before_click: float = game.mucus_hp
	game._click_wall("right")
	_check(game.mucus_hp < mucus_before_click and is_equal_approx(game.right_hp, wall_before_mucus_click), "Mucus must block wall mining and receive the manual click instead.")
	var mucus_before_launch: float = game.mucus_hp
	game._launch_catapults()
	await create_timer(0.9).timeout
	_check(game.mucus_hp <= mucus_before_launch - 2400.0, "A level-two catapult impact must visibly remove 2,400 real mucus resistance.")
	_check(game.adaptations.get_children().any(func(node: Node) -> bool: return node.get_meta("adaptation_kind", "") == "catapult"), "The catapult must exist in its own adaptation layer.")

	game.phase_work = 321.0
	game.phase_events = {"line":3, "chalk":4, "spray":1, "scratch":2, "mucus":1}
	game.contamination = 17.0
	game.another_line_clock = 77.0
	game.another_line_events = 4
	game.mined_since_line = 123456.0
	game.pending_line_grains = 800
	game.last_line_grains = 400
	game.joe_high = 63.0
	game.spray_clock = 111.0
	game.spray_film_hp = 500.0
	game.spray_film_max = 2400.0
	game.rocks_opened = 9
	game.impurities_cleaned = 13
	game.tissue_repaired = 21.0
	game.levels.vault_capacity = 1
	game.levels.ox_vault_capacity = 1
	game.levels.ox_plasma_capacity = 1
	game._spawn_fallen_wall_chunk("right", 3, 11.0, false)
	game.playing = true
	game._save()
	game.current_phase = 1
	game.phase_work = 0.0
	game.phase_events = {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
	game.contamination = 0.0
	game.another_line_clock = 180.0
	game.another_line_events = 0
	game.joe_high = 0.0
	game.levels.vault_capacity = 0
	game.levels.ox_vault_capacity = 0
	game.levels.ox_plasma_capacity = 0
	game._clear_fallen_wall_chunks()
	game._load()
	_check(game.current_phase == 5 and is_equal_approx(game.phase_work, 321.0), "Save version 18 must preserve Joe's crisis progression.")
	_check(int(game.phase_events.line) == 3 and int(game.phase_events.scratch) == 2, "Save version 18 must preserve the crises survived in the current phase.")
	_check(is_equal_approx(game.contamination, 17.0) and is_equal_approx(game.another_line_clock, 77.0), "Save version 18 must preserve hidden contamination and Joe's line clock.")
	_check(game.another_line_events == 4 and is_equal_approx(game.joe_high, 63.0) and is_equal_approx(game.spray_clock, 111.0), "Save version 18 must preserve the high and every remaining independent Joe timer.")
	_check(is_equal_approx(game.mined_since_line, 123456.0) and game.pending_line_grains == 800 and game.last_line_grains == 400, "Save version 18 must preserve the adaptive line tier and its recent-mining sample.")
	_check(is_equal_approx(game.spray_film_hp, 500.0) and is_equal_approx(game.spray_film_max, 2400.0), "Save version 18 must preserve the persistent spray film.")
	_check(game.fallen_wall_chunks.size() == 1 and is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("hp", 0.0)), game.WALL_CHUNK_HEALTH) and is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("mass", 0.0)), 11.0), "Save version 18 must preserve wall-block health and mass independently.")
	_check(game.rocks_opened == 9 and game.impurities_cleaned == 13 and is_equal_approx(game.tissue_repaired, 21.0), "Save version 6 must preserve mechanical phase objectives.")
	_check(int(game.levels.vault_capacity) == 1 and int(game.levels.ox_vault_capacity) == 1 and int(game.levels.ox_plasma_capacity) == 1 and is_equal_approx(game._ox_capacity(), 10000000000.0), "Save version 18 must preserve the intermediate vault and both late numerical Mugidophile upgrades.")

	var obsolete := FileAccess.open(game.save_path, FileAccess.WRITE)
	obsolete.store_string(JSON.stringify({"version":17, "cells":999999.0}))
	obsolete.close()
	game._load()
	_check(not FileAccess.file_exists(game.save_path), "Every pre-optimization run must be deleted instead of migrated into the new architecture.")
	game.septum_open = true
	game.levels.ox_convoy = 1
	game.levels.plant = 1
	game.levels.train = 1
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	var trains: Array = game.transporters.get_children().filter(func(node: Node) -> bool: return node.get_meta("transport_kind", "") == "train")
	_check(trains.size() == 1, "The late processing plant must create one separately layered Leukocyte Express.")
	_check(game.infrastructure.get_children().filter(func(node: Node) -> bool: return bool(node.get_meta("train_tunnel", false))).size() == 2, "The Express must use two edge tunnels without drawing rails over the septum.")
	var express := trains[0] as Node2D
	express.visible = false
	express.set_meta("state", "loaded_tunnel")
	express.set_meta("timer", 0.01)
	game._update_train(express, 0.02)
	_check(express.visible and is_equal_approx(express.position.x, game.LEFT_TUNNEL_X) and express.get_meta("state", "") == "to_plant", "A loaded train must disappear on the right and reappear from the left tunnel.")
	var wall_before_transport: float = game.right_hp
	game._update_transporters(1.0)
	_check(is_equal_approx(game.right_hp, wall_before_transport), "Carts, oxen and the Express must transport only and never mine the cocaine wall.")

	var nails_before := int(game.levels.nails)
	game._debug_set_phase(5)
	game._update_crisis(0.01)
	_check(game.current_phase == 5 and game.infection > 0.0 and game.tissue_damage > 0.0, "The phase bar must activate the complete zoo crisis immediately.")
	_check(game._kind_count("bacteria") > 0, "Selecting phase 5 must start opportunistic bacteria spawning.")
	game._debug_set_phase(1)
	_check(game.current_phase == 1 and game._kind_count("bacteria") == 0, "Returning to phase 1 must remove future-phase crisis pieces.")
	_check(is_equal_approx(game.contamination, 0.0), "Returning to phase 1 must clear future box contamination.")
	_check(int(game.levels.nails) == nails_before, "The phase bar must preserve purchased adaptations.")

	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if FileAccess.file_exists(game.settings_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.settings_path))
	if failures.is_empty():
		print("PROGRESSION_SMOKE_OK")
		quit(0)
	else:
		print("PROGRESSION_SMOKE_FAILED: %d" % failures.size())
		quit(1)
