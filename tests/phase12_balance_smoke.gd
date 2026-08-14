extends SceneTree

var failures: Array[String] = []

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _set_levels(game: Control, values: Dictionary) -> void:
	game.levels = game._empty_levels()
	for id in values:
		game.levels[id] = values[id]

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_phase12_balance_test.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false

	_check(game.CLICK_POWER_TIERS == [1.0, 3.0, 10.0, 30.0, 100.0, 300.0, 1000.0, 3000.0, 10000.0], "Manual mining must use unmistakable scale jumps instead of a nearly linear curve.")
	_check(game.STORAGE_CAPACITIES.slice(0, 6) == [1000.0, 5000.0, 25000.0, 100000.0, 2000000.0, 10000000.0], "Phase-one and phase-two storage must expose six deliberate economic tiers.")
	var affordability := [
		["container", 1000.0], ["cart", 5000.0], ["container_capacity", 5000.0],
		["cart_reinforced", 25000.0], ["warehouse", 25000.0], ["cart_upgrade", 100000.0],
		["silo", 100000.0], ["cart_freight", 2000000.0], ["ox_convoy", 2000000.0],
		["silo_capacity", 2000000.0], ["ox_capacity", 10000000.0], ["plant", 10000000.0]
	]
	for checkpoint in affordability:
		var upgrade: Dictionary = game._upgrade(str(checkpoint[0]))
		_check(float(upgrade.base) <= float(checkpoint[1]), "%s must be affordable inside the storage tier that precedes it." % str(upgrade.name))
	_check(ceil(float(game._upgrade("ox_capacity").base) * float(game._upgrade("ox_capacity").growth)) <= 10000000.0, "The last Mugidophile upgrade must also fit inside the ten-million-unit silo.")

	_set_levels(game, {"nails":3, "container":1, "cart":1, "puncher":1})
	game.current_phase = 1
	var early_click: float = game._click_power()
	var early_auto: float = game._auto_hit_rate()
	var early_logistics: float = game._rate()
	_check(is_equal_approx(early_click, 30.0) and is_equal_approx(early_auto, 12.5), "The first two exciting unlocks must already create a thirty-point click and a visible 12.5/s Pugilist baseline.")

	_set_levels(game, {"nails":4, "pawn":3, "pawn_capacity":2, "smart_clump":2, "container":1, "cart":1, "container_capacity":1, "cart_reinforced":1, "warehouse":1, "cart_upgrade":1, "puncher":1, "punch_union":1, "punch_training":1, "punch_speed":1, "shift":1})
	game.current_phase = 1
	var phase_one_click: float = game._click_power()
	var phase_one_auto: float = game._auto_hit_rate()
	var phase_one_logistics: float = game._rate()
	_check(is_equal_approx(phase_one_click, 100.0) and is_equal_approx(phase_one_auto, 180.0), "Late phase one must feel radically stronger: one-hundred-point clicks and 180 automatic damage per second.")
	_check(is_equal_approx(game._storage_capacity(), 100000.0) and is_equal_approx(game._cart_capacity(), 300.0), "The late phase-one cart may only coexist with the one-hundred-thousand-unit warehouse.")
	_check(phase_one_logistics > early_logistics * 10.0, "Phase-one logistics investment must create an order-of-magnitude improvement over the first cart.")

	_set_levels(game, {"nails":6, "pawn":6, "pawn_capacity":5, "smart_clump":4, "container":1, "cart":1, "container_capacity":1, "cart_reinforced":1, "warehouse":1, "cart_upgrade":1, "cart_freight":1, "puncher":1, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":1, "punch_collective":1, "shift":1, "silo":1, "ox_convoy":1})
	game.current_phase = 2
	var phase_two_auto: float = game._auto_hit_rate()
	var phase_two_logistics: float = game._rate()
	_check(is_equal_approx(phase_two_auto, 6750.0), "The first phase-two breakthrough must reach 6,750 automatic damage per second.")
	_check(is_equal_approx(game._storage_capacity(), 2000000.0) and is_equal_approx(game._cart_capacity(), 1500.0) and is_equal_approx(game._ox_capacity(), 10000.0), "Phase-two freight must be backed by a two-million-unit silo before the ten-thousand-unit Mugidophile arrives.")
	_check(phase_two_logistics > phase_one_logistics * 8.0, "The first industrial logistics package must create another unmistakable scale jump.")
	game.levels.silo_capacity = 1
	game.levels.ox_capacity = 2
	var phase_two_late_logistics: float = game._rate()
	_check(is_equal_approx(game._storage_capacity(), 10000000.0), "The final phase-two logistics surge must be backed by the ten-million-unit silo.")
	_check(phase_two_late_logistics >= phase_two_auto * 1.10 and phase_two_late_logistics <= phase_two_auto * 1.55, "Completed phase-two logistics must briefly overtake extraction without missing its required storage tier.")

	var phase_one_net_high: float = phase_one_auto * float(game.PHASE_CLEANING_EFFICIENCY[0])
	var phase_two_net_high: float = phase_two_auto * float(game.PHASE_CLEANING_EFFICIENCY[1]) - game.LUNG_HIGH_GAIN / game.LUNG_INTERVAL
	_check(phase_one_net_high > 0.04, "A completed phase-one extraction path must move Joe's high visibly every second.")
	_check(phase_two_net_high > 0.07, "A completed phase-two extraction path must beat the average recurring Pulmones de Drogata pressure by a clear margin.")

	print("PHASE12_BALANCE  early(click/auto/logistics)=%.1f/%.1f/%.1f  phase1=%.1f/%.1f/%.1f  phase2_auto/logistics=%.1f/%.1f→%.1f" % [early_click, early_auto, early_logistics, phase_one_click, phase_one_auto, phase_one_logistics, phase_two_auto, phase_two_logistics, phase_two_late_logistics])
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if failures.is_empty():
		print("PHASE12_BALANCE_SMOKE_OK")
		quit(0)
	else:
		print("PHASE12_BALANCE_SMOKE_FAILED: %d" % failures.size())
		quit(1)

func _init() -> void:
	call_deferred("_run")
