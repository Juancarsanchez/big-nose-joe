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
		["bronchial_rage", 100000.0], ["punch_reserves", 100000.0], ["punch_combo", 2000000.0],
		["uranium_wraps", 2000000.0], ["punch_collective", 2000000.0], ["ram", 2000000.0],
		["ram_power", 10000000.0], ["ram_speed", 10000000.0],
		["silo_capacity", 2000000.0], ["ox_capacity", 10000000.0], ["vault", 10000000.0],
		["ox_vault_capacity", 100000000.0], ["vault_capacity", 100000000.0], ["elephant", 100000000.0], ["elephant_power", 100000000.0], ["plant", 1000000000.0],
		["ox_plasma_capacity", 10000000000.0], ["plasma_cannon", 10000000000.0], ["plasma_power", 10000000000.0], ["plant_capacity", 10000000000.0],
		["supersaiyan", 100000000000.0], ["supersaiyan_power", 100000000000.0]
	]
	for checkpoint in affordability:
		var upgrade: Dictionary = game._upgrade(str(checkpoint[0]))
		_check(float(upgrade.base) <= float(checkpoint[1]), "%s must be affordable inside the storage tier that precedes it." % str(upgrade.name))
	_check(ceil(float(game._upgrade("ox_capacity").base) * float(game._upgrade("ox_capacity").growth)) <= 10000000.0, "The last Mugidophile upgrade must also fit inside the ten-million-unit silo.")

	_set_levels(game, {"silo":1})
	game.current_phase = 2
	_check(not game._upgrade_available(game._upgrade("ram")), "The Leucoram must remain locked while the Pugilist collective still has room to grow.")
	game.levels.punch_collective = 1
	_check(game._upgrade_available(game._upgrade("ram")), "Completing the Pugilist collective and silo must reveal the Leucoram objective.")
	game.levels.ram = 1
	game.levels.silo_capacity = 1
	game.levels.ram_power = 1
	_check(not game._upgrade_available(game._upgrade("ram_speed")), "Competitive hooves must wait until both ballistic-horn levels are complete.")
	game.levels.ram_power = 2
	_check(game._upgrade_available(game._upgrade("ram_speed")), "A fully reinforced Leucoram must unlock its final speed upgrade.")
	game.current_phase = 3
	game.levels.ram_speed = 1
	game.levels.vault = 1
	game.levels.ox_convoy = 1
	game.levels.ox_capacity = 2
	_check(is_equal_approx(game._storage_capacity(), 100000000.0), "The phase-three pressurized vault must hold one hundred million units.")
	_check(game._upgrade_available(game._upgrade("ox_vault_capacity")), "The completed phase-two Mugidophile and vault must reveal its one-hundred-million load upgrade.")
	_check(game._upgrade_available(game._upgrade("vault_capacity")), "The hundred-million vault must reveal its one-billion intermediate expansion.")
	game.levels.ox_vault_capacity = 1
	_check(is_equal_approx(game._ox_capacity(), 100000000.0), "Phase-three logistics must raise the same Mugidophile to one hundred million units per trip.")
	_check(game._upgrade_available(game._upgrade("elephant")), "The phase-three vault and completed Leucoram must reveal the Leukophant.")
	game.levels.vault_capacity = 1
	_check(is_equal_approx(game._storage_capacity(), 1000000000.0), "The intermediate hyperbaric vault must hold one billion units before the industrial plant.")
	game.current_phase = 4
	game.levels.elephant = 1
	game.levels.elephant_power = 2
	game.septum_open = true
	game.levels.vault_capacity = 0
	_check(not game._upgrade_available(game._upgrade("plant")), "The industrial plant must not skip the one-billion intermediate vault.")
	game.levels.vault_capacity = 1
	_check(game._upgrade_available(game._upgrade("plant")), "The one-billion vault must finance the industrial plant once the septum is open.")
	game.levels.plant = 1
	_check(is_equal_approx(game._storage_capacity(), 10000000000.0), "The phase-four industrial plant must hold ten billion units.")
	_check(not game._upgrade_available(game._upgrade("plasma_cannon")), "Plasma must wait until all three Leukophant memories are researched.")
	game.levels.elephant_power = 3
	_check(game._upgrade_available(game._upgrade("ox_plasma_capacity")), "The industrial plant must reveal the ten-billion Mugidophile upgrade before plasma arrives.")
	_check(not game._upgrade_available(game._upgrade("plasma_cannon")), "A maxed Leukophant must still wait for logistics capable of moving its successor's payload.")
	game.levels.ox_plasma_capacity = 1
	_check(is_equal_approx(game._ox_capacity(), 10000000000.0), "Phase-four logistics must raise the same Mugidophile to ten billion units per trip.")
	_check(game._upgrade_available(game._upgrade("plasma_cannon")), "Maxed Leukophant, industrial plant and plasma logistics must reveal the Plasma Cannon.")
	game.current_phase = 5
	game.levels.plasma_cannon = 1
	game.levels.plasma_power = 1
	game.levels.plant_capacity = 1
	_check(is_equal_approx(game._storage_capacity(), 100000000000.0), "The phase-five fusion plant must hold one hundred billion units.")
	_check(not game._upgrade_available(game._upgrade("supersaiyan")), "The final Supersaiyan must remain hidden behind both plasma-coil levels.")
	game.levels.plasma_power = 2
	_check(game._upgrade_available(game._upgrade("supersaiyan")), "Maxed plasma and the hundred-billion plant must reveal the final Supersaiyan.")
	_check(game.STORAGE_CAPACITIES.slice(6) == [100000000.0, 1000000000.0, 10000000000.0, 100000000000.0], "Late storage must climb through one hundred million, one billion, ten billion and one hundred billion.")
	var elephant_payload_piece: float = float(game.ELEPHANT_BASE_DAMAGE) * pow(5.0, 3) / 24.0
	var plasma_payload_piece: float = float(game.CANNON_BASE_DAMAGE) * pow(6.0, 2) / 24.0
	var supersaiyan_payload_piece: float = float(game.SUPERSAIYAN_BASE_DAMAGE) * pow(10.0, 2) / 24.0
	_check(elephant_payload_piece <= game.OX_CAPACITIES[3] and elephant_payload_piece <= game.STORAGE_CAPACITIES[6], "Every maxed Leukophant particle must fit in its phase-three transport and vault.")
	_check(plasma_payload_piece <= game.OX_CAPACITIES[4] and plasma_payload_piece <= game.STORAGE_CAPACITIES[8], "Every maxed plasma particle must fit in its phase-four transport and plant.")
	_check(supersaiyan_payload_piece <= game.STORAGE_CAPACITIES[9], "Every maxed Supersaiyan particle must fit whole inside the final plant for Express delivery.")
	_check(game.RAM_DAMAGE == [500000.0, 1000000.0, 2500000.0] and is_equal_approx(game.ELEPHANT_BASE_DAMAGE, 15000000.0) and is_equal_approx(game.CANNON_BASE_DAMAGE, 5000000000.0) and is_equal_approx(game.SUPERSAIYAN_BASE_DAMAGE, 15000000000.0), "Every new extraction actor must deliver a visibly larger individual impact than the previous one.")

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

	_set_levels(game, {"nails":6, "pawn":6, "pawn_capacity":5, "smart_clump":4, "container":1, "cart":1, "container_capacity":1, "cart_reinforced":1, "warehouse":1, "cart_upgrade":1, "cart_freight":1, "puncher":4, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":1, "bronchial_rage":1, "punch_reserves":1, "punch_combo":1, "uranium_wraps":1, "punch_collective":1, "ram":1, "ram_power":2, "ram_speed":1, "shift":1, "silo":1, "ox_convoy":1})
	game.current_phase = 2
	var phase_two_auto: float = game._auto_hit_rate()
	var phase_two_logistics: float = game._rate()
	_check(is_equal_approx(phase_two_auto, 54000.0) and is_equal_approx(game._special_extraction_rate(true), 2500000.0 / 6.0), "The complete phase-two bridge must combine 54,000 maximum Pugilist damage with a fully upgraded Leucoram.")
	_check(is_equal_approx(game._storage_capacity(), 2000000.0) and is_equal_approx(game._cart_capacity(), 1500.0) and is_equal_approx(game._ox_capacity(), 10000.0), "Phase-two freight must be backed by a two-million-unit silo before the ten-thousand-unit Mugidophile arrives.")
	_check(phase_two_logistics > phase_one_logistics * 8.0, "The first industrial logistics package must create another unmistakable scale jump.")
	game.levels.silo_capacity = 1
	game.levels.ox_capacity = 2
	var phase_two_late_logistics: float = game._rate()
	_check(is_equal_approx(game._storage_capacity(), 10000000.0), "The final phase-two logistics surge must be backed by the ten-million-unit silo.")
	var phase_two_total_extraction: float = phase_two_auto + game._special_extraction_rate(true)
	_check(is_equal_approx(game._ox_capacity(), 6500000.0), "Completed phase-two logistics must culminate in a six-and-a-half-million-unit Mugidophile trip.")
	_check(phase_two_late_logistics >= phase_two_total_extraction * 0.98 and phase_two_late_logistics <= phase_two_total_extraction * 1.08, "Completed phase-two logistics must catch the Pugilist and Leucoram output without missing its required storage tier.")

	var phase_one_net_high: float = phase_one_auto * float(game.PHASE_CLEANING_EFFICIENCY[0])
	game.joe_high = 52.0
	var phase_two_net_high: float = phase_two_total_extraction * game._cleaning_efficiency() - 0.025
	_check(phase_one_net_high > 0.04, "A completed phase-one extraction path must move Joe's high visibly every second.")
	_check(phase_two_net_high > 0.02, "A completed phase-two extraction path must beat the maximum loose-powder pressure without collapsing the phase immediately.")
	_set_levels(game, {"puncher":1, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":1, "bronchial_rage":1})
	game.current_phase = 2
	game.joe_high = 70.0
	game.joe_grain_load_cache = {"left":0.0, "right":4000.0}
	var transition_efficiency: float = game._cleaning_efficiency()
	var transition_pressure: float = game._joe_powder_pressure()
	_check(is_equal_approx(transition_efficiency, float(game.PHASE_CLEANING_EFFICIENCY[1]) * game.PHASE2_TRANSITION_MULTIPLIER), "Phase two must begin with a temporary cleaning bridge instead of a 1,200-fold efficiency cliff.")
	_check(game._auto_hit_rate() * transition_efficiency > transition_pressure, "The first phase-two Pugilist evolution and rage upgrade must beat one normal four-thousand-grain Joe wave.")
	game.joe_high = 52.0
	_check(is_equal_approx(game._cleaning_efficiency(), float(game.PHASE_CLEANING_EFFICIENCY[1])), "The phase-two transition bridge must disappear completely at the next high threshold.")
	game.current_phase = 2
	game.joe_high = 50.0
	game.joe_high_display = 50.0
	game.joe_grain_load_cache = {"left":0.0, "right":9900.0}
	game._update_joe_high(10.0)
	_check(is_equal_approx(game.joe_high, 50.25), "A saturated Joe-made pile must add exactly 0.025 high points per second after phase one.")

	print("PHASE12_BALANCE  early(click/auto/logistics)=%.1f/%.1f/%.1f  phase1=%.1f/%.1f/%.1f  phase2_pugilists+ram/logistics=%.1f+%.1f/%.1f→%.1f" % [early_click, early_auto, early_logistics, phase_one_click, phase_one_auto, phase_one_logistics, phase_two_auto, game._special_extraction_rate(true), phase_two_logistics, phase_two_late_logistics])
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
