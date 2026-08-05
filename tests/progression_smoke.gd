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
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = true

	_check(float(game.PHASES[0].target) >= 1500.0 and float(game.PHASES[3].target) >= 80000.0, "Phase targets must leave substantially more time for each mechanic to develop.")
	_check(not game.levels.has("smart_clump"), "Normal-pawn smart clumping must be removed completely.")
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
	game._update_punchers(30.0)
	_check(is_equal_approx(float(blocking_chunk.get_meta("hp", 0.0)), block_hp_before_pawn) and is_zero_approx(game._auto_hit_rate()), "Pugilists must pause and leave the obstruction exclusively to the player.")
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
	game.right_hp = game.right_max * 0.501
	game._update_world()
	_check(not game.break_button.visible, "The nose tunneller must stay locked above fifty-percent wall health.")
	game.right_hp = game.right_max * 0.50
	game._update_world()
	_check(game.break_button.visible, "The nose tunneller must unlock exactly at fifty-percent right-wall health.")
	game._open_septum()
	_check(game.septum_open and game.active_side == "left", "The nose tunneller must open the second fossa for active play.")
	game.septum_open = false
	game.active_side = "right"
	game.right_hp = 1.0
	game.right_cleared = 0
	game._damage_wall(1.0, "right")
	_check(is_equal_approx(game.right_hp, 0.0) and is_equal_approx(game.right_visual.scale.x, 0.0), "An exhausted wall must disappear instead of resetting visually.")
	game._damage_wall(1.0, "right")
	_check(is_equal_approx(game.right_hp, 0.0), "Further damage must never regenerate an exhausted wall.")
	game.right_hp = game.right_max
	game.right_cleared = 0
	game._update_world()

	# Every transport pawn contributes exactly one basal scrape before collecting.
	var basal_pawn := game.pawns.get_child(0) as Sprite2D
	var wall_before_scrape: float = game.right_hp
	var pile_before_scrape: int = game.loose_chunks.size()
	basal_pawn.set_meta("state", "working")
	basal_pawn.set_meta("timer", 0.0)
	basal_pawn.set_meta("did_mine", false)
	game._update_pawns(0.01)
	_check(is_equal_approx(game.right_hp, wall_before_scrape - 1.0), "A transport pawn must scratch exactly one unit from the wall per trip.")
	_check(game.loose_chunks.size() == pile_before_scrape + 1, "The basal scrape must create one visible grain.")
	game._clear_pile()

	# The unavoidable two-minute line delivers exactly one percent of the initial wall.
	game._update_ui()
	_check(not (game.buttons.puncher as Button).visible, "The pugilist must not be available at the beginning.")
	game.another_line_clock = 0.0
	var high_before_line: float = game.joe_high
	game._update_another_line(0.01)
	var expected_flood: int = game.another_line_wave
	var safety := 100
	while game.another_line_wave > 0 and safety > 0:
		game._update_another_line(0.20)
		safety -= 1
	_check(is_equal_approx(game.ANOTHER_LINE_INTERVAL, 120.0) and expected_flood == game.ANOTHER_LINE_VISUALS and game.loose_chunks.size() == expected_flood, "Otra rayita must repeat every 120 seconds with a bounded visual particle count.")
	_check(is_equal_approx(game._pile_load("right"), game.FIRST_WALL_HP * 0.01), "Otra rayita must add exactly one percent of the initial wall as real cocaine units.")
	_check(game.joe_high > high_before_line, "Joe's extra line must visibly increase his high.")
	var wave_columns := {}
	for piece in game.loose_chunks:
		var column := int(piece.get_meta("column", 0))
		wave_columns[column] = int(wave_columns.get(column, 0)) + 1
	var tallest_wave_column := 0
	for count in wave_columns.values():
		tallest_wave_column = maxi(tallest_wave_column, int(count))
	_check(wave_columns.size() >= 8, "Otra rayita must create several connected hills instead of one vertical needle.")
	_check(wave_columns.size() <= 28 and tallest_wave_column >= 8, "Otra rayita must retain meaningful vertical relief instead of becoming a flat flood.")
	_check(game.puncher_unlocked and (game.buttons.puncher as Button).visible, "The first extra line must unlock the pugilist adaptation.")
	_check((game.buttons.puncher as Button).has_theme_stylebox_override("normal"), "The newly mandatory pugilist must receive the blue halo.")
	game._clear_pile()

	# Buying the first pugilist produces a twelve-grain debut; later rounds use normal upgrades.
	game.cells = 2000.0
	var clicks_before_debut: int = game.total_clicks
	game._buy("puncher")
	_check(game.puncher_debut_pending and game.punchers.get_child_count() == 1, "The first pugilist must visibly prepare its debut.")
	var debut_puncher := game.punchers.get_child(0) as Sprite2D
	var debut_home_x: float = debut_puncher.position.x
	game._update_punchers(1.40)
	_check(debut_puncher.get_meta("state", "") == "to_wall" and game.loose_chunks.is_empty(), "The debut must begin with a real walk toward the wall, not a remote hit.")
	game._update_punchers(0.10)
	_check(debut_puncher.position.x < debut_home_x, "A right-side pugilist must physically approach the cocaine wall.")
	var debut_safety := 80
	while game.loose_chunks.size() < 12 and debut_safety > 0:
		game._update_punchers(0.08)
		debut_safety -= 1
	_check(game.loose_chunks.size() == 12 and game.total_clicks == clicks_before_debut + 12, "The debut punch must create a spectacular twelve-grain burst.")
	_check(absf(debut_puncher.position.x - game._puncher_strike_position(debut_puncher).x) < 0.6, "The punch must resolve at the visible edge of the cocaine wall.")
	_check(game.punchers.get_child(0).get_node_or_null("BoxingGlove") != null, "Pugilists must be distinguished by a separate boxing-glove layer.")
	game._clear_pile()
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
	while game.loose_chunks.size() < chunks_before_round + 4 and round_safety > 0:
		game._update_punchers(0.08)
		round_safety -= 1
	_check(game.loose_chunks.size() == chunks_before_round + 4, "Two powered pugilists must throw four grains during a normal round.")
	var return_safety := 120
	while not game._punchers_idle() and return_safety > 0:
		game._update_punchers(0.08)
		return_safety -= 1
	_check(game._punchers_idle(), "Pugilists must return to their waiting positions after punching.")
	var mirrored_glove := (game.punchers.get_child(0) as Sprite2D).get_node("BoxingGlove") as Polygon2D
	(game.punchers.get_child(0) as Sprite2D).set_meta("side", "left")
	game._place_puncher(game.punchers.get_child(0) as Sprite2D)
	_check(mirrored_glove.scale.x < 0.0, "A left-side pugilist must mirror its separate glove layer toward the wall.")
	game._clear_pile()

	# Manual upgrades create a visible rhythmic burst without changing the click count.
	game.levels.click_burst = 2
	game.levels.click_rhythm = 0
	game.manual_clicks_since_burst = 9
	var clicks_before_burst: int = game.total_clicks
	var wall_before_burst: float = game.right_hp
	game._click_wall("right")
	_check(game.loose_chunks.size() == 7, "A level-two manual burst must add six grains to the normal clicked grain.")
	_check(game.total_clicks == clicks_before_burst + 1 and is_equal_approx(game.right_hp, wall_before_burst - game._click_power() - 6.0), "A burst must amplify one manual click without pretending to be several clicks.")
	game._clear_pile()

	# Phase 1 also requires visible logistics investment.
	game.levels.pawn = 1
	game.levels.shift = 1
	game.levels.box = 1
	game.phase_work = game._phase_target()
	game._check_phase_progress()
	_check(game.current_phase == 2, "The tutorial must wait for the flood, the pugilist and basic logistics before phase 2.")
	game._resume_after_joe()
	game._update_ui()
	_check((game.buttons.breaker as Button).text.contains("NECESARIA"), "A new phase must explain which adaptation is mandatory.")
	_check((game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The mandatory adaptation must receive a blue halo.")
	_check(not (game.buttons.coord as Button).visible, "Work in Chain must remain hidden before the septum is open.")
	game.septum_open = true
	game._update_ui()
	_check((game.buttons.coord as Button).visible, "Work in Chain may appear only after both fossae are unlocked.")
	game.septum_open = false

	# Pulmones de Drogata is inevitable; umbrellas reduce the real-number theft without cancelling it.
	game.cells = 10000.0
	game.joe_high = 40.0
	game.levels.umbrella = 0
	game.levels.umbrella_power = 0
	game.another_line_wave = 0
	game.another_line_clock = 17.0
	game._trigger_lungs()
	_check(is_equal_approx(game.cells, 8000.0) and is_equal_approx(game.joe_high, 60.0), "Unprotected lungs must steal 2,000 stored grains and add exactly twenty points of high.")
	_check(is_equal_approx(game.another_line_clock, 17.0), "Pulmones de Drogata must not postpone the independent 120-second line timer.")
	game.another_line_wave = 0
	game._clear_pile()
	game.cells = 10000.0
	game.joe_high = 40.0
	game.levels.umbrella = 3
	game.levels.umbrella_power = 5
	game._rebuild_adaptations()
	await process_frame
	game._trigger_lungs()
	_check(is_equal_approx(game._umbrella_reduction(), 0.90) and is_equal_approx(game.cells, 9800.0), "Three fully reinforced umbrellas must save 1,800 of a 2,000-grain theft, never all of it.")
	_check(game.adaptations.get_children().filter(func(node: Node) -> bool: return node.get_meta("adaptation_kind", "") == "umbrella").size() == 3, "Umbrella specialists must remain separate layered moving units.")
	game.another_line_wave = 0
	game._clear_pile()

	game.levels.breaker = 1
	game.rocks_opened = 6
	game._update_ui()
	_check(not (game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The halo must disappear after buying the mandatory adaptation.")
	game.phase_work = game._phase_target()
	game._check_phase_progress()
	_check(game.current_phase == 3, "The avalanche must require a blue helmet, an umbrella and six opened rocks.")
	game._resume_after_joe()

	# Phase 3 keeps its formulas hidden: players read the dirty box and slower animation.
	game.levels.detector = 0
	game.contamination = 0.0
	game._update_ui()
	_check((game.buttons.detector as Button).text.contains("NECESARIA"), "Phase 3 must point directly at the receptor adaptation.")
	var pawn := game.pawns.get_child(0) as Sprite2D
	var rubbish: Sprite2D = game._create_piece("impurity", "right", 1.0, 0, 0, 0.064, "serrín")
	rubbish.set_meta("carried", true)
	pawn.set_meta("cargo", [rubbish])
	var cells_before: float = game.cells
	game._finish_delivery(pawn)
	_check(is_equal_approx(game.cells, cells_before), "Undetected adulterants must waste a transport trip.")
	_check(game.contamination > 0.0 and game.contamination < 1.0, "One adulterant must contaminate the box gradually.")
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
	var blocked_grain: Sprite2D = game._create_piece("grain", "right", 1.0, 0, 0, 0.072)
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
	for child in game.pawns.get_children():
		var candidate := child as Sprite2D
		if candidate and bool(candidate.get_meta("detector", false)):
			pawn = candidate
			break
	var contamination_before_cleaning: float = game.contamination
	var sorted: Sprite2D = game._create_piece("impurity", "right", 1.0, 0, 0, 0.064, "yeso")
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
	game.levels.sponge = 2
	game.levels.sponge_power = 5
	game._rebuild_adaptations()
	await process_frame
	game.right_hp = game.right_max - 5000.0
	var wall_before_spray_line: float = game.right_hp
	game._trigger_spray()
	_check(game.spray_pending and game.joe_events.get_child_count() >= 20, "The spray must appear as a clearly visible blue rain thirty seconds before the line.")
	var spray_coats: Array = game.joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "spray_coat")
	_check(spray_coats.size() == 5 and spray_coats.all(func(node: Node) -> bool: return absf((node as Node2D).position.x - game._wall_center_x("right")) <= 40.0), "The blue spray coat must remain visibly attached to the cocaine wall during the warning.")
	game.spray_followup_clock = 0.0
	game._update_joe_events(0.01)
	_check(not game.spray_pending and is_equal_approx(game._sponge_reduction(), 0.90), "Two fully upgraded sponge macrophages must absorb ninety percent of the spray.")
	_check(is_equal_approx(game.right_hp - wall_before_spray_line, game.SPRAY_RECOAT_UNITS * 0.10), "The UI-reported absorbed amount and actual wall restoration must use the same real units.")

	game.phase_work = game._phase_target()
	game.contamination = 29.0
	game.impurities_cleaned = 10
	game._check_phase_progress()
	_check(game.current_phase == 4, "Phase 3 must require a detector, a sponge, ten filtered samples and a clean enough box.")
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
	_check(game.damage_meter.visible and game.blood_drops.get_child_count() > 0, "Phase 4 must show a damage meter and falling blood drops.")
	_check(game.get_node("World/JoeHigh").visible and game.joe_high_label.text.contains("COLOCÓN"), "The permanent Joe meter must be named and shown as his high, not as the removed prognosis.")
	_check(game.get_node_or_null("World/StageViewport/Stage/Layer46_Crisis/LeftWound") == null, "The old red wound domes must be removed.")
	game.tissue_damage = 10.0
	game.joe_high = 40.0
	game._trigger_scratch()
	var visible_wounds: Array = game.joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "wound")
	_check(is_equal_approx(game.tissue_damage, 10.0 + game.SCRATCH_DAMAGE) and is_equal_approx(game.joe_high, 40.0 + game.SCRATCH_HIGH_GAIN), "Joe's recurring scratch must add explicit tissue damage and high.")
	_check(visible_wounds.size() >= 3, "The scratch must create several grounded fissures instead of a red dome.")

	game.phase_work = game._phase_target()
	game.tissue_damage = 30.0
	game.tissue_repaired = 18.0
	game._check_phase_progress()
	_check(game.current_phase == 5, "The bleeding phase must require substantial visible tissue repair.")
	game._resume_after_joe()

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
		var loose_bacterium: Sprite2D = game._create_piece("bacteria", "right", 2.0, 0, 0, 0.08)
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
	_check(game.mucus_hp <= mucus_before_launch - 400.0, "A level-two catapult impact must visibly remove 400 real mucus resistance.")
	_check(game.adaptations.get_children().any(func(node: Node) -> bool: return node.get_meta("adaptation_kind", "") == "catapult"), "The catapult must exist in its own adaptation layer.")

	game.phase_work = 321.0
	game.contamination = 17.0
	game.another_line_clock = 77.0
	game.another_line_events = 4
	game.joe_high = 63.0
	game.lung_clock = 123.0
	game.spray_clock = 111.0
	game.rocks_opened = 9
	game.impurities_cleaned = 13
	game.tissue_repaired = 21.0
	game._spawn_fallen_wall_chunk("right", 3, 11.0, false)
	game.playing = true
	game._save()
	game.current_phase = 1
	game.phase_work = 0.0
	game.contamination = 0.0
	game.another_line_clock = 180.0
	game.another_line_events = 0
	game.joe_high = 0.0
	game._clear_fallen_wall_chunks()
	game._load()
	_check(game.current_phase == 5 and is_equal_approx(game.phase_work, 321.0), "Save version 10 must preserve Joe's crisis progression.")
	_check(is_equal_approx(game.contamination, 17.0) and is_equal_approx(game.another_line_clock, 77.0), "Save version 10 must preserve hidden contamination and Joe's line clock.")
	_check(game.another_line_events == 4 and is_equal_approx(game.joe_high, 63.0) and is_equal_approx(game.lung_clock, 123.0) and is_equal_approx(game.spray_clock, 111.0), "Save version 10 must preserve the high and every independent Joe timer.")
	_check(game.fallen_wall_chunks.size() == 1 and is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("hp", 0.0)), game.WALL_CHUNK_HEALTH) and is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("mass", 0.0)), 11.0), "Save version 10 must preserve wall-block health and mass independently.")
	_check(game.rocks_opened == 9 and game.impurities_cleaned == 13 and is_equal_approx(game.tissue_repaired, 21.0), "Save version 6 must preserve mechanical phase objectives.")

	var legacy := FileAccess.open(game.save_path, FileAccess.WRITE)
	legacy.store_string(JSON.stringify({"version":2, "cells":90.0, "levels":{"nails":1, "pawn":1, "breaker":1}, "compaction_announced":true}))
	legacy.close()
	game._load()
	_check(game.current_phase == 2, "Version 2 saves with compaction must migrate into the avalanche phase.")
	_check(game.levels.has("handlers") and int(game.levels.handlers) == 0, "Legacy saves must receive every new adaptation key.")
	_check(not game.levels.has("smart_clump"), "Legacy saves must discard the removed smart-clumping adaptation.")
	_check(game.levels.has("click_burst") and game.levels.has("click_rhythm"), "Legacy saves must receive the new manual-click adaptations.")
	_check(game.puncher_unlocked, "Legacy saves beyond phase 1 must keep the pugilist branch available.")

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
	if failures.is_empty():
		print("PROGRESSION_SMOKE_OK")
		quit(0)
	else:
		print("PROGRESSION_SMOKE_FAILED: %d" % failures.size())
		quit(1)
