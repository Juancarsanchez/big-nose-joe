extends SceneTree

const GRAIN_COUNT := 20000
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

	var spawn_started := Time.get_ticks_usec()
	for index in range(GRAIN_COUNT):
		game._create_piece("grain", "right", 1.0, 0, game._choose_landing_column("right"), 0.072, "", "joe")
	var spawn_ms := float(Time.get_ticks_usec() - spawn_started) / 1000.0
	_check(game.loose_chunks.size() == GRAIN_COUNT, "The compact model must retain twenty thousand individually addressable grains.")
	_check(is_equal_approx(game._pile_load("right"), float(GRAIN_COUNT)), "Cached pile load must stay exact under a twenty-thousand-grain stress load.")
	_check(game.chunks.get_child_count() == 1 and game.chunks.get_child(0) == game.powder_surface, "The whole settled pile must use one powder surface and zero grain nodes.")
	_check(game.pile_renderer.instance_count() == 0, "Twenty thousand settled grains must collapse into the powder surface instead of twenty thousand rendered balls.")
	_check(spawn_ms < 15000.0, "Creating twenty thousand indexed grains took too long: %.0f ms." % spawn_ms)

	var compact_started := Time.get_ticks_usec()
	var cluster: Array = game._dense_grain_cluster("right")
	var compact_ms := float(Time.get_ticks_usec() - compact_started) / 1000.0
	_check(cluster.size() == game.COMPACTION_GRAINS, "Spatial compaction lookup must still find the exact six-grain cluster.")
	_check(compact_ms < 1000.0, "Local compaction lookup must remain linear under stress: %.0f ms." % compact_ms)

	game.playing = true
	var save_started := Time.get_ticks_usec()
	game._save()
	var save_ms := float(Time.get_ticks_usec() - save_started) / 1000.0
	var save_bytes := FileAccess.get_file_as_bytes(game.save_path).size()
	_check(save_bytes < 500000, "Run-length pile serialization must keep a twenty-thousand-grain save below 500 KB.")
	_check(save_ms < 3000.0, "Compact save generation took too long: %.0f ms." % save_ms)

	game.levels.plant = 1
	game.cells = 0.0
	var claim_started := Time.get_ticks_usec()
	var train_cargo: Array = game._claim_transport_cocaine("right", 500000.0, true)
	var claim_ms := float(Time.get_ticks_usec() - claim_started) / 1000.0
	var train := Node2D.new()
	train.set_meta("cargo", train_cargo)
	train.set_meta("side", "right")
	train.set_meta("transport_kind", "train")
	var delivery_started := Time.get_ticks_usec()
	game._deliver_transport_cargo(train, Vector2.ZERO)
	var delivery_ms := float(Time.get_ticks_usec() - delivery_started) / 1000.0
	train.free()
	_check(train_cargo.size() == GRAIN_COUNT and game.loose_chunks.is_empty(), "The train must claim and clear twenty thousand grains without quadratic list removal.")
	_check(is_equal_approx(game.cells, float(GRAIN_COUNT)), "Batched train delivery must preserve every individual grain's value.")
	_check(claim_ms < 3000.0 and delivery_ms < 3000.0, "Mass transport must stay bounded: claim %.0f ms, delivery %.0f ms." % [claim_ms, delivery_ms])

	game.levels.plant_capacity = 3
	game.cells = 0.0
	var final_payload_piece: float = float(game.SUPERSAIYAN_DAMAGE[2]) / 24.0
	game._create_piece("grain", "right", final_payload_piece, 0, 0, 0.072, "", "player")
	var final_cargo: Array = game._claim_transport_cocaine("right", game._storage_claim_space(), true)
	var final_train := Node2D.new()
	final_train.set_meta("cargo", final_cargo)
	final_train.set_meta("side", "right")
	final_train.set_meta("transport_kind", "train")
	game._deliver_transport_cargo(final_train, Vector2.ZERO)
	final_train.free()
	_check(final_cargo.size() == 1 and is_equal_approx(game.cells, final_payload_piece), "The Express and fifty-trillion fusion plant must accept one indivisible maxed Supersaiyan payload particle.")

	print("PARTICLE_PERFORMANCE  grains=%d  spawn=%.0fms  compaction=%.1fms  save=%.0fms  claim=%.0fms  deliver=%.0fms  bytes=%d  batches=%d  particle_nodes=%d" % [GRAIN_COUNT, spawn_ms, compact_ms, save_ms, claim_ms, delivery_ms, save_bytes, game.pile_renderer.batch_count(), game.chunks.get_child_count()])
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if failures.is_empty():
		print("PARTICLE_PERFORMANCE_SMOKE_OK")
		quit(0)
	else:
		print("PARTICLE_PERFORMANCE_SMOKE_FAILED: %d" % failures.size())
		quit(1)
