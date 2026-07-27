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

	# Phase pacing and autonomous punchers are independent of transport pawns.
	_check(float(game.PHASES[0].target) >= 800.0 and float(game.PHASES[3].target) >= 32000.0, "Phase targets must leave enough time for each mechanic to develop.")
	game.levels.puncher = 2
	game.levels.punch_power = 1
	game._rebuild_punchers()
	var chunks_before_punching: int = game.loose_chunks.size()
	var clicks_before_punching: int = game.total_clicks
	var wall_before_punching: float = game.right_hp
	game._update_punchers(game._punch_interval())
	_check(game.punchers.get_child_count() == 2, "The autoclicker upgrade must create independent visible punchers.")
	_check(game.loose_chunks.size() == chunks_before_punching + 4, "Two powered punchers must throw four visible grains per round.")
	_check(game.total_clicks == clicks_before_punching + 4 and is_equal_approx(game.right_hp, wall_before_punching - 4.0), "Automatic punches must damage the wall and count toward progression.")
	_check(game.punchers.get_child(0).get_node_or_null("BoxingGlove") != null, "Punchers must be visually distinguished by a boxing glove.")
	game._clear_pile()

	game.phase_work = game._phase_target()
	game._check_phase_progress()
	_check(game.current_phase == 2, "Completing the tutorial must trigger Joe's second disaster.")
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
	game._update_ui()
	_check(not (game.buttons.breaker as Button).has_theme_stylebox_override("normal"), "The halo must disappear after buying the mandatory adaptation.")
	game.phase_work = game._phase_target()
	game._check_phase_progress()
	_check(game.current_phase == 3, "The avalanche must remain until a blue-helmet specialist exists.")
	game._resume_after_joe()

	# Phase 3: adulterants dirty the box, slow unloading and reduce the yield.
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
	_check(game.contamination > 0.0 and game.contamination < 1.0, "One adulterant must contaminate the box gradually, not in large jumps.")
	_check(game._deposit_duration() > 0.30 and game._box_yield_multiplier() < 1.0, "Contamination must slow deposits and reduce recovered cells.")
	game._update_crisis_visuals()
	game._update_pressure_visuals()
	_check(game.contamination_meter.visible and game.contamination_progress.value > 0.0, "Phase 3 must show its contamination meter.")
	_check(game.box.modulate != Color.WHITE, "The box itself must visibly become dirty.")
	_check(game.contamination_label.text.contains("CÉLULAS -") and game.pressure_label.text.contains("DESCARGA"), "The contamination UI must state both penalties explicitly.")

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
	_check(contamination_before_cleaning - game.contamination < 1.0, "A detector must clean the box gradually rather than erasing the crisis at once.")

	game.phase_work = game._phase_target()
	game.contamination = 29.0
	game._check_phase_progress()
	_check(game.current_phase == 4, "Adulterants must remain until detector adaptations are active and the box is clean.")
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
	game._check_phase_progress()
	_check(game.current_phase == 5, "The bleeding phase must resolve only after platelets stabilize the tissue.")
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
	game.playing = true
	game._save()
	game.current_phase = 1
	game.phase_work = 0.0
	game.contamination = 0.0
	game._load()
	_check(game.current_phase == 5 and is_equal_approx(game.phase_work, 321.0), "Save version 5 must preserve Joe's crisis progression.")
	_check(is_equal_approx(game.contamination, 17.0), "Save version 5 must preserve box contamination.")

	var legacy := FileAccess.open(game.save_path, FileAccess.WRITE)
	legacy.store_string(JSON.stringify({"version":2, "cells":90.0, "levels":{"nails":1, "pawn":1, "breaker":1}, "compaction_announced":true}))
	legacy.close()
	game._load()
	_check(game.current_phase == 2, "Version 2 saves with compaction must migrate into the avalanche phase.")
	_check(game.levels.has("handlers") and int(game.levels.handlers) == 0, "Legacy saves must receive every new adaptation key.")
	_check(game.levels.has("smart_clump") and int(game.levels.smart_clump) == 0, "Legacy saves must receive the smart-clumping adaptation.")
	_check(game.levels.has("puncher") and int(game.levels.puncher) == 0, "Legacy saves must receive the autonomous puncher upgrades.")

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
