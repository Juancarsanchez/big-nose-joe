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
		["cart_reinforced", 25000.0], ["warehouse", 25000.0], ["cart_upgrade", 100000.0], ["cart_speed", 2000000.0],
		["silo", 100000.0], ["cart_freight", 2000000.0], ["cart_bulk", 2000000.0], ["ox_convoy", 2000000.0],
		["bronchial_rage", 100000.0], ["punch_reserves", 100000.0], ["punch_combo", 2000000.0],
		["uranium_wraps", 2000000.0], ["punch_collective", 2000000.0], ["ram", 2000000.0],
		["ram_power", 10000000.0], ["ram_speed", 10000000.0],
		["silo_capacity", 2000000.0], ["cart_tanker", 10000000.0], ["ox_capacity", 2000000.0], ["ox_speed", 2000000.0], ["ox_heavy_capacity", 10000000.0], ["vault", 10000000.0],
		["detector", 10000000.0], ["sorting", 10000000.0], ["wall_scan", 10000000.0], ["ox_vault_capacity", 100000000.0], ["vault_capacity", 100000000.0],
		["elephant", 100000000.0], ["elephant_power", 100000000.0], ["vault_reserve", 1000000000.0], ["plant", 3000000000.0],
		["sponge", 3000000000.0], ["catapult", 3000000000.0], ["hammer", 10000000000.0], ["hammer_power", 10000000000.0], ["plant_buffer", 10000000000.0], ["ox_plasma_capacity", 10000000000.0],
		["plasma_cannon", 150000000000.0], ["plasma_power", 150000000000.0], ["meteor", 150000000000.0], ["meteor_power", 150000000000.0], ["platelets", 150000000000.0], ["handlers", 150000000000.0], ["train", 150000000000.0],
		["plant_capacity", 150000000000.0], ["supersaiyan", 5000000000000.0], ["supersaiyan_power", 5000000000000.0], ["train_speed", 5000000000000.0]
	]
	for checkpoint in affordability:
		var upgrade: Dictionary = game._upgrade(str(checkpoint[0]))
		_check(float(upgrade.base) <= float(checkpoint[1]), "%s must be affordable inside the storage tier that precedes it." % str(upgrade.name))
	_check(ceil(float(game._upgrade("ox_heavy_capacity").base) * float(game._upgrade("ox_heavy_capacity").growth)) <= 10000000.0, "The last Mugidophile upgrade must also fit inside the ten-million-unit silo.")
	_check(ceil(12000000.0 * pow(3.0, 3)) <= 1000000000.0, "Every phase-three Mugidophile step must fit before the final vault reserve.")
	_check(ceil(45000000.0 * pow(2.6, 3)) <= 1000000000.0, "Every Leukophant memory must fit inside the one-billion vault that precedes the final reserve.")
	_check(ceil(15000000000.0 * pow(4.0, 1)) <= 150000000000.0 and ceil(15000000000.0 * pow(4.0, 2)) > 150000000000.0 and ceil(15000000000.0 * pow(4.0, 2)) <= 500000000000.0, "The third plasma coil must be naturally delayed until the first phase-five fusion expansion.")
	_check(ceil(4000000000000.0 * 7.5) <= 50000000000000.0, "The final Kamehameha upgrade must fit inside the completed fifty-trillion plant.")

	_set_levels(game, {"silo":1, "puncher":1, "punch_union":1, "punch_training":1, "bronchial_rage":1})
	game.current_phase = 2
	_check(not game._upgrade_available(game._upgrade("ram")), "The Leucoram must remain locked while the medium Pugilist ladder still has room to grow.")
	game.levels.punch_reserves = 1
	game.levels.punch_combo = 1
	game.levels.uranium_wraps = 1
	_check(game._upgrade_available(game._upgrade("ram")), "The silo and uranium wraps must reveal the Leucoram before the Pugilist collective is exhausted.")
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
	game.levels.ox_heavy_capacity = 2
	_check(is_equal_approx(game._storage_capacity(), 100000000.0), "The phase-three pressurized vault must hold one hundred million units.")
	_check(game._upgrade_available(game._upgrade("ox_vault_capacity")), "The completed phase-two Mugidophile and vault must reveal its granular phase-three load ladder.")
	_check(game._upgrade_available(game._upgrade("vault_capacity")), "The hundred-million vault must reveal its one-billion intermediate expansion.")
	game.levels.ox_vault_capacity = 3
	_check(is_equal_approx(game._ox_capacity(), 500000000.0), "Phase-three logistics must pass through a five-hundred-million load before its final jump.")
	_check(game._upgrade_available(game._upgrade("elephant")), "The phase-three vault and completed Leucoram must reveal the Leukophant.")
	game.levels.vault_capacity = 1
	_check(game._upgrade_available(game._upgrade("vault_reserve")), "The one-billion vault and third phase-three convoy step must reveal the final reserve.")
	game.levels.vault_reserve = 1
	game.levels.ox_vault_capacity = 4
	_check(is_equal_approx(game._storage_capacity(), 3000000000.0) and is_equal_approx(game._ox_capacity(), 2000000000.0), "Phase three must finish with a three-billion reserve and two-billion Mugidophile trip.")
	game.current_phase = 4
	game.levels.elephant = 1
	game.levels.elephant_power = 3
	game.septum_open = true
	game.levels.vault_reserve = 0
	_check(not game._upgrade_available(game._upgrade("plant")), "The industrial plant must not skip the three-billion phase-three reserve.")
	game.levels.vault_reserve = 1
	_check(game._upgrade_available(game._upgrade("plant")), "The final vault reserve must finance the industrial plant once the septum is open.")
	game.levels.plant = 1
	_check(is_equal_approx(game._storage_capacity(), 10000000000.0), "The phase-four industrial plant must hold ten billion units.")
	_check(not game._upgrade_available(game._upgrade("plasma_cannon")), "Plasma must wait until all four Leukophant memories and its logistics are complete.")
	game.levels.elephant_power = 4
	_check(game._upgrade_available(game._upgrade("hammer")), "A completed Leukophant and the industrial plant must reveal Leucomartillo as the phase-four rhythm bridge.")
	_check(game._upgrade_available(game._upgrade("ox_plasma_capacity")), "The industrial plant must reveal the phase-four Mugidophile ladder before plasma arrives.")
	_check(not game._upgrade_available(game._upgrade("plasma_cannon")), "A maxed Leukophant must still wait for logistics capable of moving its successor's payload.")
	game.levels.ox_plasma_capacity = 3
	game.levels.plant_buffer = 2
	_check(is_equal_approx(game._ox_capacity(), 80000000000.0) and is_equal_approx(game._storage_capacity(), 150000000000.0), "Phase four must finish its logistics at eighty billion per trip backed by a 150-billion plant.")
	_check(game._upgrade_available(game._upgrade("plasma_cannon")), "Maxed Leukophant, buffered plant and completed plasma logistics must reveal the Plasma Cannon.")
	game.current_phase = 5
	game.levels.plasma_cannon = 1
	game.levels.plasma_power = 2
	game.levels.plant_capacity = 1
	_check(is_equal_approx(game._storage_capacity(), 500000000000.0), "The first fusion expansion must hold five hundred billion units.")
	_check(game._upgrade_available(game._upgrade("meteor")), "The second plasma coil must reveal Neutrophil Meteor before the long final fusion climb.")
	_check(not game._upgrade_available(game._upgrade("supersaiyan")), "The final Supersaiyan must remain locked behind the final plasma coil and second fusion expansion.")
	game.levels.plasma_power = 3
	game.levels.plant_capacity = 2
	_check(game._upgrade_available(game._upgrade("supersaiyan")), "Maxed plasma and the five-trillion plant must reveal the final Supersaiyan.")
	game.levels.plant_capacity = 3
	_check(is_equal_approx(game._storage_capacity(), 50000000000000.0), "The completed fusion plant must hold fifty trillion units.")
	_check(game.STORAGE_CAPACITIES.slice(6) == [100000000.0, 1000000000.0, 3000000000.0, 10000000000.0, 50000000000.0, 150000000000.0, 500000000000.0, 5000000000000.0, 50000000000000.0], "Late storage must expose every deliberate phase-three to phase-five economic tier.")
	game.levels.smart_clump = 5
	game.levels.cart_tanker = 1
	game.levels.punch_collective = 1
	game.levels.punch_power = 3
	_check(game._upgrade_available(game._upgrade("pawn_renaissance")) and game._upgrade_available(game._upgrade("cart_renaissance")) and game._upgrade_available(game._upgrade("punch_renaissance")), "Phase five must expose three separate renaissance branches once their original families are complete.")
	game.levels.pawn_renaissance = 1
	game.levels.cart_renaissance = 1
	game.levels.punch_renaissance = 1
	_check(game._smart_clump_size() == 55 and is_equal_approx(game._cart_capacity(), 500000000.0) and game._punch_output() >= 100 * int(game.PUGILIST_DAMAGE[3]), "The first renaissance tier must visibly revive pawns, the classic cart and the old Pugilist squad independently.")
	game._select_technology_unit("pawn")
	game._update_ui()
	_check((game.buttons.pawn_renaissance as Button).text.contains("55 → 144"), "The pawn page must expose the exact next renaissance payload.")
	game._select_technology_unit("cart")
	game._update_ui()
	_check((game.buttons.cart_renaissance as Button).text.contains("500.0M → 5.0B"), "The cart page must expose its independent industrial payload jump.")
	game._select_technology_unit("pugilist")
	game._update_ui()
	_check((game.buttons.punch_renaissance as Button).text.contains("×100 → ×1000"), "The Pugilist page must expose its independent late-game multiplier without hiding it in a combined purchase.")
	var elephant_payload_piece: float = float(game.ELEPHANT_DAMAGE[4]) / 24.0
	var plasma_payload_piece: float = float(game.PLASMA_DAMAGE[3]) / 24.0
	var supersaiyan_payload_piece: float = float(game.SUPERSAIYAN_DAMAGE[2]) / 24.0
	_check(elephant_payload_piece <= 2000000000.0 and elephant_payload_piece <= 3000000000.0, "Every maxed Leukophant particle must fit in its completed phase-three transport and reserve.")
	_check(plasma_payload_piece <= 80000000000.0 and plasma_payload_piece <= 150000000000.0, "Every maxed plasma particle must fit in its phase-four transport and plant.")
	_check(supersaiyan_payload_piece <= 50000000000000.0, "Every maxed Supersaiyan particle must fit whole inside the final fusion plant.")
	_check(game.RAM_DAMAGE.back() < game.ELEPHANT_DAMAGE[0] and game.ELEPHANT_DAMAGE.back() < game.PLASMA_DAMAGE[0] and game.METEOR_DAMAGE.back() < game.PLASMA_DAMAGE.back() and game.PLASMA_DAMAGE.back() < game.SUPERSAIYAN_DAMAGE[0], "The large-impact ladder must keep Leucoram, Leukophant, late plasma, Meteor and final Supersaiyan in a readable order.")
	_check(game.ELEPHANT_DAMAGE.back() / game.ELEPHANT_INTERVAL < game.HAMMER_DAMAGE[0] / game.HAMMER_INTERVAL and game.HAMMER_DAMAGE.back() / game.HAMMER_INTERVAL < game.PLASMA_DAMAGE[0] / game.CANNON_INTERVAL, "Leucomartillo must fill the phase-four DPS gap between a completed Leukophant and the first Plasma Cannon.")

	_set_levels(game, {"hammer":1, "hammer_power":1, "meteor":1, "meteor_power":1})
	game.current_phase = 5
	game.right_hp = game.FIRST_WALL_HP
	game.active_side = "right"
	game._rebuild_punchers()
	var bridge_actors: Array = game.punchers.get_children().filter(func(node: Node) -> bool: return str(node.get_meta("extraction_kind", "")) in ["hammer", "meteor"])
	_check(bridge_actors.size() == 2, "Both bridge purchases must create their own separately animated world unit.")
	for tick in range(70):
		game._update_special_extractors(0.1)
	_check(game.right_hp <= game.FIRST_WALL_HP - game.HAMMER_DAMAGE[1] - game.METEOR_DAMAGE[1], "Leucomartillo and Neutrophil Meteor must both complete a real attack cycle instead of remaining decorative actors.")
	for actor in bridge_actors:
		var sprite := actor.get_node("Sprite") as Sprite2D
		_check(is_equal_approx(actor.position.y, game._ground_y()) and sprite.position.y < 0.0, "%s must be anchored to the nasal floor instead of floating." % actor.name)

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

	_set_levels(game, {"nails":6, "pawn":6, "pawn_capacity":5, "smart_clump":4, "container":1, "cart":1, "container_capacity":1, "cart_reinforced":1, "warehouse":1, "cart_upgrade":1, "cart_speed":2, "cart_freight":1, "cart_bulk":1, "puncher":4, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":1, "bronchial_rage":1, "punch_reserves":1, "punch_combo":1, "uranium_wraps":1, "punch_collective":1, "ram":1, "ram_power":2, "ram_speed":1, "shift":1, "silo":1, "ox_convoy":1})
	game.current_phase = 2
	var phase_two_auto: float = game._auto_hit_rate()
	var phase_two_logistics: float = game._rate()
	_check(is_equal_approx(phase_two_auto, 64000.0) and is_equal_approx(game._special_extraction_rate(true), 2500000.0 / 6.0), "The complete phase-two bridge must combine 64,000 maximum Pugilist damage with a fully upgraded Leucoram.")
	_check(is_equal_approx(game._storage_capacity(), 2000000.0) and is_equal_approx(game._cart_capacity(), 6000.0) and is_equal_approx(game._ox_capacity(), 40000.0), "Early phase-two freight must keep the cart relevant beside the forty-thousand-unit Mugidophile.")
	_check(phase_two_logistics > phase_one_logistics * 8.0, "The first industrial logistics package must create another unmistakable scale jump.")
	game.levels.silo_capacity = 1
	game.levels.ox_capacity = 2
	game.levels.ox_heavy_capacity = 2
	game.levels.ox_speed = 2
	game.levels.cart_tanker = 1
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
	_check(is_equal_approx(transition_efficiency, float(game.PHASE_CLEANING_EFFICIENCY[1]) * float(game.PHASE_TRANSITION_MULTIPLIERS[1])), "Phase two must begin with a temporary cleaning bridge instead of a 1,200-fold efficiency cliff.")
	_check(game._auto_hit_rate() * transition_efficiency > transition_pressure, "The first phase-two Pugilist evolution and rage upgrade must beat one normal four-thousand-grain Joe wave.")
	game.joe_high = 52.0
	_check(is_equal_approx(game._cleaning_efficiency(), float(game.PHASE_CLEANING_EFFICIENCY[1])), "The phase-two transition bridge must disappear completely at the next high threshold.")

	# Every later phase repeats the same flow curve: granular extraction, matching
	# logistics and storage bought before the next spectacular actor.
	var phase_three_entry_cleaning: float = phase_two_total_extraction * float(game.PHASE_CLEANING_EFFICIENCY[2]) * float(game.PHASE_TRANSITION_MULTIPLIERS[2])
	_check(phase_three_entry_cleaning > 0.025, "The completed phase-two build must beat one saturated Joe pile while phase three introduces its first adaptation.")
	_set_levels(game, {"pawn":6, "pawn_capacity":5, "smart_clump":4, "shift":1, "cart":1, "cart_tanker":1, "cart_speed":2, "puncher":4, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":2, "bronchial_rage":1, "punch_reserves":1, "punch_combo":1, "uranium_wraps":1, "punch_collective":1, "ram":1, "ram_power":2, "ram_speed":1, "silo":1, "silo_capacity":1, "vault":1, "vault_capacity":1, "vault_reserve":1, "ox_convoy":1, "ox_capacity":2, "ox_heavy_capacity":2, "ox_vault_capacity":4, "ox_speed":2, "elephant":1, "elephant_power":4})
	game.current_phase = 3
	var phase_three_extraction: float = game._auto_hit_rate() + game._special_extraction_rate(true)
	var phase_three_logistics: float = game._rate()
	_check(phase_three_logistics >= phase_three_extraction * 0.85 and phase_three_logistics <= phase_three_extraction * 1.35, "Completed phase-three logistics must stay close to the maxed Leukophant chain.")
	_check(phase_three_extraction * float(game.PHASE_CLEANING_EFFICIENCY[3]) * float(game.PHASE_TRANSITION_MULTIPLIERS[3]) > 0.025, "The completed phase-three build must survive the opening pressure of phase four.")
	game.joe_high = 34.0
	_check(phase_three_extraction * game._cleaning_efficiency() > 0.10, "A completed phase-three build must visibly move Joe through the final part of adulteration.")

	_set_levels(game, {"pawn":6, "pawn_capacity":5, "smart_clump":4, "shift":1, "cart":1, "cart_tanker":1, "cart_speed":2, "puncher":4, "punch_union":1, "punch_training":1, "punch_speed":1, "punch_power":3, "bronchial_rage":1, "punch_reserves":1, "punch_combo":1, "uranium_wraps":1, "punch_collective":1, "ram":1, "ram_power":2, "ram_speed":1, "silo":1, "silo_capacity":1, "vault":1, "vault_capacity":1, "vault_reserve":1, "plant":1, "plant_buffer":2, "ox_convoy":1, "ox_capacity":2, "ox_heavy_capacity":2, "ox_vault_capacity":4, "ox_plasma_capacity":3, "ox_speed":2, "elephant":1, "elephant_power":4, "plasma_cannon":1, "plasma_power":2})
	game.current_phase = 4
	var phase_four_extraction: float = game._auto_hit_rate() + game._special_extraction_rate(true)
	var phase_four_logistics: float = game._rate()
	_check(phase_four_logistics >= phase_four_extraction * 0.85 and phase_four_logistics <= phase_four_extraction * 1.20, "Completed phase-four logistics must stay close to the maxed pre-crisis plasma chain.")
	game.joe_high = 18.0
	_check(phase_four_extraction * game._cleaning_efficiency() > 0.15, "A completed phase-four build must visibly break through the final threshold.")

	game.current_phase = 5
	game.levels.plasma_power = 3
	game.levels.plant_capacity = 3
	game.levels.supersaiyan = 1
	game.levels.supersaiyan_power = 2
	game.levels.train = 1
	game.levels.train_speed = 2
	game.septum_open = true
	game._rebuild_infrastructure()
	game._rebuild_transporters()
	game._select_technology_unit("train")
	_check(game._storage_tier() == 14 and is_equal_approx(game._train_speed(), 825.0), "The final storage and Express levels must rebuild their visuals without overrunning the old tier arrays.")
	_check((game.buttons.train_speed as Button).visible, "The Express page must expose its two numerical speed upgrades in the technology laboratory.")
	var phase_five_extraction: float = game._auto_hit_rate() + game._special_extraction_rate(true)
	var train_surface_distance: float = (absf(game.PLANT_X + 165.0 - game.LEFT_TUNNEL_X) + absf(game.RIGHT_TUNNEL_X - game._pile_center("right") - 106.0)) * 2.0
	var phase_five_train_rate: float = game._storage_capacity() / (train_surface_distance / game._train_speed() + game.TRAIN_TUNNEL_TIME * 2.0 + 1.2)
	var phase_five_logistics: float = game._rate() + phase_five_train_rate
	_check(phase_five_logistics >= phase_five_extraction * 0.95, "The completed Express and fusion plant must be able to clear the final absurd extraction scale.")
	_check(phase_five_extraction * game._cleaning_efficiency() > 0.50, "The final Supersaiyan ladder must produce the intended end-game power fantasy.")
	game.current_phase = 2
	game.joe_high = 50.0
	game.joe_high_display = 50.0
	game.joe_grain_load_cache = {"left":0.0, "right":9900.0}
	game._update_joe_high(10.0)
	_check(is_equal_approx(game.joe_high, 50.25), "A saturated Joe-made pile must add exactly 0.025 high points per second after phase one.")

	print("FULL_BALANCE  phase2=%.0f/%.0f  phase3=%.0f/%.0f  phase4=%.0f/%.0f  phase5=%.0f/%.0f" % [phase_two_total_extraction, phase_two_late_logistics, phase_three_extraction, phase_three_logistics, phase_four_extraction, phase_four_logistics, phase_five_extraction, phase_five_logistics])
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
