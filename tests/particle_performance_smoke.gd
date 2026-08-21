extends SceneTree

const UNIT_COUNT := 20000000
var failures: Array[String] = []

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_particle_performance_test.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.playing = false
	game.joe_dialog.hide()
	game.current_phase = 2
	game._clear_pile()
	seed(260807)

	# Twenty million units are represented by a few column totals and one surface,
	# not by twenty million nodes or logical ball objects.
	var spawn_started := Time.get_ticks_usec()
	for column in range(-5, 120):
		game.powder_field.add("right", column, float(UNIT_COUNT) / 125.0, "joe")
	game.powder_surface.refresh()
	var spawn_ms := float(Time.get_ticks_usec() - spawn_started) / 1000.0
	_check(game.loose_chunks.is_empty(), "Normal cocaine must allocate zero legacy PilePiece balls under stress.")
	_check(is_equal_approx(game._pile_load("right"), float(UNIT_COUNT)), "The sparse powder field must retain all twenty million units exactly.")
	_check(game.powder_field.mass_columns("right").size() == 125, "Twenty million units should require only the chosen 125 terrain columns.")
	_check(game.chunks.get_child_count() == 1 and game.chunks.get_child(0) == game.powder_surface, "The settled pile must remain one powder-surface node.")
	_check(game.pile_renderer.instance_count() == 0, "Continuous powder must create zero RenderingServer ball instances.")
	_check(spawn_ms < 1000.0, "Creating a twenty-million-unit field took too long: %.1f ms." % spawn_ms)

	var compact_started := Time.get_ticks_usec()
	var dense_column: int = game.powder_field.densest_column("right", float(game.COMPACTION_GRAINS))
	var compact_ms := float(Time.get_ticks_usec() - compact_started) / 1000.0
	_check(dense_column != 999, "Spatial compaction must find a six-unit source column in constant sparse data.")
	_check(compact_ms < 100.0, "Sparse compaction lookup must remain bounded: %.1f ms." % compact_ms)

	game.playing = true
	var save_started := Time.get_ticks_usec()
	game._save()
	var save_ms := float(Time.get_ticks_usec() - save_started) / 1000.0
	var save_bytes := FileAccess.get_file_as_bytes(game.save_path).size()
	_check(save_bytes < 100000, "Continuous-field serialization must keep twenty million units below 100 KB.")
	_check(save_ms < 1000.0, "Continuous save generation took too long: %.1f ms." % save_ms)

	game.levels.plant = 1
	game.cells = 0.0
	var claim_started := Time.get_ticks_usec()
	var train_cargo: Dictionary = game._claim_transport_cocaine("right", float(UNIT_COUNT), true)
	var claim_ms := float(Time.get_ticks_usec() - claim_started) / 1000.0
	var train := Node2D.new()
	train.set_meta("cargo", train_cargo)
	train.set_meta("side", "right")
	train.set_meta("transport_kind", "train")
	var delivery_started := Time.get_ticks_usec()
	game._deliver_transport_cargo(train, Vector2.ZERO)
	var delivery_ms := float(Time.get_ticks_usec() - delivery_started) / 1000.0
	train.free()
	_check(is_equal_approx(float(train_cargo.amount), float(UNIT_COUNT)) and is_zero_approx(game._pile_load("right")), "The train must claim twenty million divisible units without list removal.")
	_check(is_equal_approx(game.cells, float(UNIT_COUNT)), "Batched train delivery must preserve every cocaine unit.")
	_check(claim_ms < 1000.0 and delivery_ms < 1000.0, "Mass transport must stay bounded: claim %.1f ms, delivery %.1f ms." % [claim_ms, delivery_ms])

	# A payload larger than storage is split at the exact capacity instead of being
	# rejected because one old ball does not fit.
	game.levels.plant_capacity = 3
	game.cells = 0.0
	var final_payload := float(game.SUPERSAIYAN_DAMAGE[2])
	game.powder_field.add("right", 0, final_payload, "player")
	var final_cargo: Dictionary = game._claim_transport_cocaine("right", game._storage_claim_space(), true)
	var final_train := Node2D.new()
	final_train.set_meta("cargo", final_cargo)
	final_train.set_meta("side", "right")
	final_train.set_meta("transport_kind", "train")
	game._deliver_transport_cargo(final_train, Vector2.ZERO)
	final_train.free()
	_check(is_equal_approx(game.cells, game._storage_capacity()) and is_equal_approx(game._pile_load("right"), final_payload - game._storage_capacity()), "A huge payload must fill storage exactly and leave the exact remainder in the pile.")

	print("POWDER_PERFORMANCE  units=%d  build=%.1fms  lookup=%.1fms  save=%.1fms  claim=%.1fms  deliver=%.1fms  bytes=%d  powder_nodes=%d" % [UNIT_COUNT, spawn_ms, compact_ms, save_ms, claim_ms, delivery_ms, save_bytes, game.chunks.get_child_count()])
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if failures.is_empty():
		print("PARTICLE_PERFORMANCE_SMOKE_OK")
		quit(0)
	else:
		print("PARTICLE_PERFORMANCE_SMOKE_FAILED: %d" % failures.size())
		quit(1)
