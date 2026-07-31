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

	_check(float(game.PHASES[0].target) >= 800.0 and float(game.PHASES[3].target) >= 32000.0, "Phase targets must leave enough time for each mechanic to develop.")
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
	_check(is_equal_approx(game.right_hp, game.right_max * 0.90 - float(game.WALL_CHUNK_HP)), "A detached block must reserve real wall mass instead of duplicating cocaine.")
	var fallen := game.fallen_wall_chunks[0] as Sprite2D
	game._land_fallen_wall_chunk(fallen)
	var detached_hp := float(fallen.get_meta("hp", 0.0))
	var loose_before_block: int = game.loose_chunks.size()
	game._mine_fallen_wall_chunk(fallen, 1.0)
	_check(is_equal_approx(float(fallen.get_meta("hp", 0.0)), detached_hp - 1.0) and game.loose_chunks.size() == loose_before_block + 1, "Mining a fallen wall block must visibly release its stored powder.")
	game._clear_fallen_wall_chunks()
	game._clear_pile()
	game._spawn_fallen_wall_chunk("right", 2, 2.0, false)
	var basic_block_pawn := game.pawns.get_child(0) as Sprite2D
	basic_block_pawn.set_meta("side", "right")
	basic_block_pawn.set_meta("state", "working")
	basic_block_pawn.set_meta("timer", 0.0)
	basic_block_pawn.set_meta("did_mine", false)
	var wall_before_block_scrape: float = game.right_hp
	game._update_pawns(0.01)
	_check(is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("hp", 0.0)), 1.0) and is_equal_approx(game.right_hp, wall_before_block_scrape), "Basic pawns must scrape fallen blocks before returning to the main wall.")
	game._clear_fallen_wall_chunks()
	game._clear_pile()
	game.right_hp = game.right_max
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

	# The first three-minute event floods the pile and unlocks the hidden pugilist branch.
	game._update_ui()
	_check(not (game.buttons.puncher as Button).visible, "The pugilist must not be available at the beginning.")
	game.another_line_clock = 0.0
	var joe_before_line: float = game.joe_health
	game._update_another_line(0.01)
	var expected_flood: int = game.another_line_wave
	var safety := 100
	while game.another_line_wave > 0 and safety > 0:
		game._update_another_line(0.20)
		safety -= 1
	_check(expected_flood == 140 and game.loose_chunks.size() == expected_flood, "Otra rayita must throw a large phase-scaled cocaine wave onto the pile.")
	_check(game.joe_health < joe_before_line, "Joe's extra line must visibly worsen his overall prognosis.")
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

	game.levels.breaker = 1
	game.rocks_opened = 6
	game._update_ui()
	_check(not (game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The halo must disappear after buying the mandatory adaptation.")
	game.phase_work = game._phase_target()
	game._check_phase_progress()
	_check(game.current_phase == 3, "The avalanche must require a blue helmet and six opened rocks.")
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

	game.levels.detector = 1
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

	game.phase_work = game._phase_target()
	game.contamination = 29.0
	game.impurities_cleaned = 10
	game._check_phase_progress()
	_check(game.current_phase == 4, "Phase 3 must require ten filtered samples and a clean enough box.")
	game._resume_after_joe()

	game.levels.platelets = 2
	game.levels.repair = 2
	game.tissue_damage = 50.0
	game._rebuild_platelets()
	game._update_crisis(1.0)
	_check(game.tissue_damage < 50.0, "Enough platelets must reduce tissue damage while cleaning continues.")
	_check(game.platelets.get_child_count() == 4, "Platelet upgrades must create visible layered workers.")
	_check(game.damage_meter.visible and game.blood_drops.get_child_count() > 0, "Phase 4 must show a damage meter and falling blood drops.")
	_check(game.get_node_or_null("World/StageViewport/Stage/Layer46_Crisis/LeftWound") == null, "The old red wound domes must be removed.")

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

	game.phase_work = 321.0
	game.contamination = 17.0
	game.another_line_clock = 77.0
	game.another_line_events = 4
	game.joe_health = 63.0
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
	game.joe_health = 0.0
	game._clear_fallen_wall_chunks()
	game._load()
	_check(game.current_phase == 5 and is_equal_approx(game.phase_work, 321.0), "Save version 8 must preserve Joe's crisis progression.")
	_check(is_equal_approx(game.contamination, 17.0) and is_equal_approx(game.another_line_clock, 77.0), "Save version 8 must preserve hidden contamination and Joe's event clock.")
	_check(game.another_line_events == 4 and is_equal_approx(game.joe_health, 63.0), "Save version 8 must preserve both the evolving drop pattern and Joe's prognosis.")
	_check(game.fallen_wall_chunks.size() == 1 and is_equal_approx(float(game.fallen_wall_chunks[0].get_meta("hp", 0.0)), 11.0), "Save version 8 must preserve detached wall blocks without regenerating their mass.")
	_check(game.rocks_opened == 9 and game.impurities_cleaned == 13 and is_equal_approx(game.tissue_repaired, 21.0), "Save version 6 must preserve mechanical phase objectives.")

	var legacy := FileAccess.open(game.save_path, FileAccess.WRITE)
	legacy.store_string(JSON.stringify({"version":2, "cells":90.0, "levels":{"nails":1, "pawn":1, "breaker":1}, "compaction_announced":true}))
	legacy.close()
	game._load()
	_check(game.current_phase == 2, "Version 2 saves with compaction must migrate into the avalanche phase.")
	_check(game.levels.has("handlers") and int(game.levels.handlers) == 0, "Legacy saves must receive every new adaptation key.")
	_check(game.levels.has("smart_clump") and int(game.levels.smart_clump) == 0, "Legacy saves must receive the smart-clumping adaptation.")
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
