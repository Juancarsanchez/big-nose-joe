extends Node2D

# Un solo lienzo dibuja todas las motas pasajeras. Así el polvo no crea cientos
# de nodos y animaciones independientes cuando varias unidades golpean a la vez.
const MAX_PARTICLES := 560

var particles: Array[Dictionary] = []

func _ready() -> void:
	set_process(false)

func active_count() -> int:
	return particles.size()

func clear() -> void:
	particles.clear()
	set_process(false)
	queue_redraw()

func spawn_arc(start: Vector2, target: Vector2, intensity: float = 1.0) -> void:
	var count := clampi(10 + roundi(intensity * 8.0), 12, 26)
	var base_control := (start + target) * 0.5 - Vector2(0.0, 35.0 + absf(target.x - start.x) * 0.045)
	for index in range(count):
		var soft := index % 4 == 0
		var color := Color(0.88, 0.96, 0.95, 0.38) if soft else Color(0.98, 0.99, 0.96, 0.9)
		particles.append({
			"kind":"arc", "elapsed":-float(index) / float(count) * 0.09,
			"duration":randf_range(0.28, 0.42),
			"start":start + Vector2(randf_range(-7.0, 7.0), randf_range(-5.0, 5.0)),
			"control":base_control + Vector2(randf_range(-16.0, 16.0), randf_range(-10.0, 10.0)),
			"target":target + Vector2(randf_range(-8.0, 8.0), randf_range(-5.0, 4.0)),
			"size":randf_range(0.75, 1.9) * (1.7 if soft else 1.0) * intensity,
			"color":color, "rotation":randf_range(-1.2, 1.2), "spin":randf_range(-2.2, 2.2),
		})
	_trim()
	set_process(true)
	queue_redraw()

func spawn_fall(origin: Vector2, targets: Array[Vector2], intensity: float = 1.0) -> void:
	for index in range(targets.size()):
		particles.append({
			"kind":"fall", "elapsed":-float(index % 5) * 0.018,
			"duration":randf_range(0.58, 0.86),
			"start":origin + Vector2(randf_range(-12.0, 12.0), randf_range(-8.0, 12.0)),
			"target":targets[index], "size":randf_range(2.4, 5.8) * intensity,
			"color":Color("fffdf2"), "rotation":randf_range(-0.8, 0.8), "spin":randf_range(-2.0, 2.0),
		})
	_trim()
	set_process(true)
	queue_redraw()

func _trim() -> void:
	if particles.size() > MAX_PARTICLES:
		particles = particles.slice(particles.size() - MAX_PARTICLES)

func _process(delta: float) -> void:
	for index in range(particles.size() - 1, -1, -1):
		particles[index].elapsed = float(particles[index].elapsed) + delta
		if float(particles[index].elapsed) >= float(particles[index].duration):
			particles.remove_at(index)
	if particles.is_empty():
		set_process(false)
	queue_redraw()

func _draw() -> void:
	for particle in particles:
		var elapsed := float(particle.elapsed)
		if elapsed < 0.0:
			continue
		var progress := clampf(elapsed / float(particle.duration), 0.0, 1.0)
		var position: Vector2
		if str(particle.kind) == "arc":
			# Bézier continuo: nunca existe una etapa que espere suspendida en el ápice.
			var inverse := 1.0 - progress
			position = Vector2(particle.start) * inverse * inverse + Vector2(particle.control) * 2.0 * inverse * progress + Vector2(particle.target) * progress * progress
		else:
			position = Vector2(particle.start).lerp(Vector2(particle.target), progress * progress)
		var color := Color(particle.color)
		color.a *= 1.0 - clampf((progress - 0.76) / 0.24, 0.0, 1.0)
		var size := float(particle.size)
		var rotation := float(particle.rotation) + float(particle.spin) * progress
		var axis := Vector2(cos(rotation), sin(rotation))
		var normal := Vector2(-axis.y, axis.x)
		var polygon := PackedVector2Array([
			position - axis * size + normal * size * 0.18,
			position - axis * size * 0.28 - normal * size * 0.72,
			position + axis * size * 0.82 - normal * size * 0.24,
			position + axis * size * 0.44 + normal * size * 0.66,
		])
		draw_colored_polygon(polygon, color)
