class_name PowderSurface
extends Node2D

const POWDER := Color("f2eedc")
const POWDER_SHADE := Color("d9d2c3")
const JOE_POWDER := Color("e4e7e1")
const OUTLINE := Color("302838")
const IMPURITY_COLORS := {
	"serrín": Color("a9682f"),
	"yeso": Color("7890a8"),
	"tiza": Color("c5ad36")
}

var source: Node
var redraw_clock := 0.0
var visual_heights := {"left":{}, "right":{}}
var surface_profiles := {"left":{}, "right":{}}

func setup(game: Node) -> void:
	source = game
	set_process(true)
	queue_redraw()

func refresh() -> void:
	queue_redraw()

func _process(delta: float) -> void:
	redraw_clock -= delta
	if redraw_clock <= 0.0:
		redraw_clock = 0.06
		queue_redraw()

func _draw() -> void:
	if not is_instance_valid(source):
		return
	_draw_side("left")
	_draw_side("right")

func _draw_side(side: String) -> void:
	var profile := _calculate_profile(side)
	if profile.is_empty():
		surface_profiles[side] = {}
		return
	var mass := float(profile.mass)
	var columns: Dictionary = source.pile_columns[side]
	var ground := float(source._ground_y()) - 3.0
	var desired_width := float(profile.width)
	var spacing := float(profile.spacing)
	var start_x := float(profile.start)
	var heights: PackedFloat32Array = profile.heights
	surface_profiles[side] = profile
	var joe_ratio := clampf(float(source.joe_grain_load_cache.get(side, 0.0)) / mass, 0.0, 1.0)
	var joe_heights := PackedFloat32Array()
	for height in heights:
		joe_heights.append(clampf(height * joe_ratio, 0.0, 22.0))
	var surface := PackedVector2Array()
	var fill := PackedVector2Array([Vector2(start_x - spacing * 0.6, ground)])
	for index in range(heights.size()):
		var point := Vector2(start_x + float(index) * spacing, ground - heights[index])
		surface.append(point)
		fill.append(point)
	fill.append(Vector2(start_x + desired_width + spacing * 0.6, ground))
	draw_colored_polygon(fill, POWDER)
	_draw_lower_shade(fill, ground)
	_draw_joe_layer(surface, joe_heights)
	if surface.size() >= 2:
		draw_polyline(surface, OUTLINE, 2.2, true)
	_draw_powder_noise(side, 0, heights, start_x, spacing, ground)
	_draw_impurity_stains(columns, start_x, heights, spacing, ground)

func _calculate_profile(side: String) -> Dictionary:
	var mass := float(source._pile_load(side))
	if mass <= 0.001:
		return {}
	var ground := float(source._ground_y()) - 3.0
	var center := float(source._pile_center(side))
	var area_per_unit := float(source._fossa_visual_area_per_unit())
	var area := mass * area_per_unit
	var bounds: Vector2i = source._column_bounds(side, source._pile_radius_limit(side))
	var physical_min := center + float(bounds.x) * float(source.GRAIN_SPACING)
	var physical_max := center + float(bounds.y) * float(source.GRAIN_SPACING)
	var physical_width := maxf(16.0, physical_max - physical_min)
	var deposits: Array[Dictionary] = []
	var start_x := physical_max
	var end_x := physical_min
	var mass_columns: Dictionary = source.pile_mass_columns.get(side, {})
	for column_value in mass_columns:
		var column := int(column_value)
		var column_mass := float(mass_columns[column_value])
		if column_mass <= 0.001:
			continue
		var deposit_x := center + float(column) * float(source.GRAIN_SPACING)
		var deposit_area := column_mass * area_per_unit
		var spread := clampf(12.0 + sqrt(deposit_area) * 0.92, 14.0, physical_width * 0.72)
		deposits.append({"x":deposit_x, "area":deposit_area, "spread":spread})
		start_x = minf(start_x, deposit_x - spread)
		end_x = maxf(end_x, deposit_x + spread)
	if deposits.is_empty():
		# Protección para estados incompletos creados por herramientas de prueba.
		var fallback_x := center + float(source.RIGHT_WALL_COLUMN if side == "right" else source.LEFT_WALL_COLUMN) * float(source.GRAIN_SPACING)
		var fallback_spread := clampf(12.0 + sqrt(area) * 0.92, 14.0, physical_width * 0.72)
		deposits.append({"x":fallback_x, "area":area, "spread":fallback_spread})
		start_x = fallback_x - fallback_spread
		end_x = fallback_x + fallback_spread
	start_x = clampf(start_x, physical_min, physical_max - 8.0)
	end_x = clampf(end_x, start_x + 8.0, physical_max)
	var desired_width := end_x - start_x
	var samples := clampi(ceili(desired_width / 8.0) + 1, 3, 220)
	var spacing := desired_width / float(samples - 1)
	var raw_heights := PackedFloat32Array()
	raw_heights.resize(samples)
	for deposit in deposits:
		var weights := PackedFloat32Array()
		weights.resize(samples)
		var weight_sum := 0.0
		var spread := float(deposit.spread)
		for index in range(samples):
			var distance := absf(start_x + float(index) * spacing - float(deposit.x))
			if distance > spread:
				continue
			# Una campana ancha produce lomas de polvo; varias caídas cercanas se
			# funden y las lejanas conservan sus propios valles.
			var normalized := distance / maxf(1.0, spread)
			var weight := pow(maxf(0.0, 1.0 - normalized * normalized), 1.35)
			weights[index] = weight
			weight_sum += weight
		for index in range(samples):
			raw_heights[index] += float(deposit.area) * weights[index] / maxf(0.001, weight_sum * spacing)
	var heights := _smooth(raw_heights)
	# Un pequeño grano determinista evita un borde matemáticamente perfecto sin
	# desplazar el volumen fuera de la zona en la que cayó.
	for index in range(heights.size()):
		var ripple := 1.0 + sin(float(index) * 1.71 + (0.4 if side == "right" else 1.3)) * 0.035
		heights[index] *= ripple
	_normalize_area(heights, area, spacing)
	_limit_height(heights, maxf(260.0, ground - 265.0), spacing)
	_normalize_area(heights, area, spacing)
	return {"mass":mass, "revision":int(source.pile_revision.get(side, 0)), "start":start_x, "spacing":spacing, "width":desired_width, "heights":heights}

func surface_y_at(side: String, x: float) -> float:
	var profile: Dictionary = surface_profiles.get(side, {})
	if profile.is_empty() or not is_equal_approx(float(profile.get("mass", -1.0)), float(source._pile_load(side))) or int(profile.get("revision", -1)) != int(source.pile_revision.get(side, 0)):
		profile = _calculate_profile(side)
		surface_profiles[side] = profile
	var heights: PackedFloat32Array = profile.get("heights", PackedFloat32Array())
	if heights.is_empty():
		return float(source._ground_y())
	var spacing := float(profile.get("spacing", 1.0))
	var start := float(profile.get("start", 0.0))
	var end := start + spacing * float(heights.size() - 1)
	if x < start - 1.0 or x > end + 1.0:
		return float(source._ground_y())
	var progress := clampf((x - start) / maxf(0.001, spacing), 0.0, float(heights.size() - 1))
	var low := floori(progress)
	var high := mini(low + 1, heights.size() - 1)
	var height := lerpf(heights[low], heights[high], progress - float(low))
	return float(source._ground_y()) - 3.0 - height

func _smooth(values: PackedFloat32Array) -> PackedFloat32Array:
	var result := values.duplicate()
	for pass_index in range(2):
		var previous := result.duplicate()
		for index in range(1, result.size() - 1):
			result[index] = previous[index] * 0.58 + (previous[index - 1] + previous[index + 1]) * 0.21
	return result

func _normalize_area(heights: PackedFloat32Array, target_area: float, spacing: float) -> void:
	var current_area := 0.0
	for height in heights:
		current_area += height * spacing
	var correction := target_area / maxf(0.001, current_area)
	for index in range(heights.size()):
		heights[index] *= correction

func _limit_height(heights: PackedFloat32Array, maximum: float, spacing: float) -> void:
	# Al saturarse una zona, el exceso se desparrama por los valles disponibles.
	# Se conserva el área total y se evita que una descarga enorme forme una torre.
	for pass_index in range(6):
		var excess_area := 0.0
		var receivers := 0
		for index in range(heights.size()):
			if heights[index] > maximum:
				excess_area += (heights[index] - maximum) * spacing
				heights[index] = maximum
			elif heights[index] < maximum - 0.01:
				receivers += 1
		if excess_area <= 0.01 or receivers == 0:
			return
		var addition := excess_area / (float(receivers) * spacing)
		for index in range(heights.size()):
			if heights[index] < maximum - 0.01:
				heights[index] += addition

func _draw_lower_shade(fill: PackedVector2Array, ground: float) -> void:
	if fill.size() < 4:
		return
	var shade := PackedVector2Array()
	shade.append(fill[0])
	for index in range(1, fill.size() - 1):
		var point := fill[index]
		shade.append(Vector2(point.x, lerpf(point.y, ground, 0.72)))
	shade.append(fill[fill.size() - 1])
	draw_colored_polygon(shade, POWDER_SHADE)

func _draw_joe_layer(surface: PackedVector2Array, joe_heights: PackedFloat32Array) -> void:
	var run_top := PackedVector2Array()
	var run_bottom := PackedVector2Array()
	for index in range(surface.size()):
		var thickness := float(joe_heights[index])
		if thickness <= 0.1:
			_flush_joe_run(run_top, run_bottom)
			run_top = PackedVector2Array()
			run_bottom = PackedVector2Array()
			continue
		run_top.append(surface[index])
		run_bottom.append(surface[index] + Vector2(0.0, clampf(thickness, 6.0, 22.0)))
	if not run_top.is_empty():
		_flush_joe_run(run_top, run_bottom)

func _flush_joe_run(top: PackedVector2Array, bottom: PackedVector2Array) -> void:
	if top.size() < 2:
		return
	var band := PackedVector2Array()
	for point in top:
		band.append(point)
	for index in range(bottom.size() - 1, -1, -1):
		band.append(bottom[index])
	draw_colored_polygon(band, JOE_POWDER)
	draw_polyline(top, Color("7a8490"), 1.35, true)

func _draw_powder_noise(side: String, first: int, heights: PackedFloat32Array, center: float, spacing: float, ground: float) -> void:
	# Un ruido escaso rompe la mancha plana, pero nunca recupera el aspecto de
	# cientos de canicas individuales.
	var salt := 17 if side == "left" else 41
	var budget := mini(150, heights.size() * 3)
	for index in range(budget):
		var column_index := (index * 37 + salt) % maxi(1, heights.size())
		var height := float(heights[column_index])
		if height < 7.0:
			continue
		var hash_value := float((index * 71 + column_index * 19 + salt) % 997) / 997.0
		var x := center + float(first + column_index) * spacing + (hash_value - 0.5) * spacing
		var y := ground - height * (0.18 + fmod(hash_value * 5.73, 0.68))
		var color := Color("bbb6ab") if index % 3 else Color("ffffff")
		draw_line(Vector2(x - 1.2, y), Vector2(x + 1.2, y + 0.4), color, 1.1, true)

func _draw_impurity_stains(columns: Dictionary, start_x: float, heights: PackedFloat32Array, spacing: float, ground: float) -> void:
	var stains: Array = []
	for stack_value in columns.values():
		for piece in stack_value:
			if str(piece.get_meta("kind", "grain")) == "impurity":
				stains.append(piece)
	if stains.is_empty():
		return
	var stride := maxi(1, ceili(float(stains.size()) / 120.0))
	for index in range(0, stains.size(), stride):
		var piece = stains[index]
		var pos: Vector2 = piece.position
		var surface_index := clampi(roundi((piece.position.x - start_x) / maxf(0.001, spacing)), 0, heights.size() - 1)
		var surface_y := ground - float(heights[surface_index])
		pos.x = start_x + float(surface_index) * spacing + clampf(pos.x - (start_x + float(surface_index) * spacing), -spacing * 0.35, spacing * 0.35)
		pos.y = clampf(pos.y, surface_y + 6.0, ground - 5.0)
		var color: Color = IMPURITY_COLORS.get(str(piece.get_meta("material", "")), Color("a58b53"))
		var size := 5.0 + float((index * 13) % 5)
		var patch := PackedVector2Array([
			pos + Vector2(-size, 0.5), pos + Vector2(-size * 0.35, -size * 0.45),
			pos + Vector2(size, -0.2), pos + Vector2(size * 0.25, size * 0.42)
		])
		draw_colored_polygon(patch, color)
