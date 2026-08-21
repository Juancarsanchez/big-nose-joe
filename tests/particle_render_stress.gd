extends SceneTree

const GRAIN_COUNT := 20000
const MEASURED_FRAMES := 240

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	Engine.max_fps = 0
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_particle_render_stress.save"
	game._new_game()
	await process_frame
	game.phase_event_pending = false
	game.playing = false
	game.joe_dialog.hide()
	game.current_phase = 2
	game._clear_pile()
	seed(260808)
	for index in range(GRAIN_COUNT):
		game.powder_field.add("right", game._choose_landing_column("right"), 1.0, "joe")
	game.powder_surface.refresh()
	for warmup in range(30):
		await process_frame
	var fall_targets: Array[Vector2] = []
	for index in range(18):
		fall_targets.append(Vector2(720.0 + float(index) * 7.0, game._ground_y() - 3.0))
	var started := Time.get_ticks_usec()
	for frame in range(MEASURED_FRAMES):
		# Simula golpes y recogida simultáneos. Antes esto añadía decenas de nodos y
		# Tweens por fotograma; ahora debe quedarse en un solo lienzo acotado.
		if frame % 4 == 0:
			game.powder_effects.set_mass_volume("stress_stream", Vector2(890.0, game._ground_y() - 24.0), 120.0, game._fossa_visual_area_per_unit(), "stream")
			game.powder_effects.set_mass_volume("stress_fall", fall_targets[frame % fall_targets.size()], 80.0, game._fossa_visual_area_per_unit(), "fall")
		await process_frame
	var elapsed := float(Time.get_ticks_usec() - started) / 1000000.0
	var fps := float(MEASURED_FRAMES) / maxf(0.001, elapsed)
	print("PARTICLE_RENDER_STRESS  grains=%d  fps=%.1f  batches=%d  particle_nodes=%d  transient=%d" % [GRAIN_COUNT, fps, game.pile_renderer.batch_count(), game.chunks.get_child_count(), game.powder_effects.active_count()])
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	# El polvo continuo no necesita ya ningún lote de sprites: una sola superficie
	# procedural representa toda la masa, incluso bajo la carga de referencia.
	if fps >= 60.0 and game.pile_renderer.batch_count() == 0 and game.chunks.get_child_count() <= 1 and game.effects.get_child_count() < 8 and game.powder_effects.active_count() <= 2:
		print("PARTICLE_RENDER_STRESS_OK")
		quit(0)
	else:
		push_error("Twenty thousand grains failed the 60 FPS rendering target.")
		quit(1)
