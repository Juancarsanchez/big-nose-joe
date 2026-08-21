extends Node2D

# Un solo lienzo dibuja todas las masas pasajeras. Las cargas pequeñas son motas
# cuadradas de polvo y las grandes, nubes dentadas: nunca canicas o elipses lisas.
var mass_volumes := {}

func _ready() -> void:
	set_process(false)

func active_count() -> int:
	return mass_volumes.size()

func clear() -> void:
	mass_volumes.clear()
	queue_redraw()

func set_mass_volume(id: Variant, position: Vector2, amount: float, area_per_unit: float, shape: String = "heap", direction: float = 1.0) -> void:
	if amount <= 0.0001:
		remove_mass_volume(id)
		return
	var previous: Dictionary = mass_volumes.get(id, {})
	var trail := PackedVector2Array()
	if shape == "stream":
		if str(previous.get("shape", "")) == "stream":
			trail = (previous.get("trail", PackedVector2Array()) as PackedVector2Array).duplicate()
		if trail.is_empty() or trail[trail.size() - 1].distance_to(position) >= 2.0:
			trail.append(position)
		while trail.size() > 64:
			trail.remove_at(0)
	mass_volumes[id] = {"position": position, "amount": amount, "area_per_unit": area_per_unit, "shape": shape, "direction": direction, "seed":absi(hash(id)), "trail":trail}
	queue_redraw()

func remove_mass_volume(id: Variant) -> void:
	if mass_volumes.erase(id):
		queue_redraw()

func mass_volume_amount(id: Variant) -> float:
	return float((mass_volumes.get(id, {}) as Dictionary).get("amount", 0.0))

func mass_volume_world_area(id: Variant) -> float:
	var volume: Dictionary = mass_volumes.get(id, {})
	return _visual_units(float(volume.get("amount", 0.0))) * float(volume.get("area_per_unit", 0.0))

func _draw() -> void:
	for volume in mass_volumes.values():
		_draw_mass_volume(volume)

func _draw_mass_volume(volume: Dictionary) -> void:
	var visual_units := _visual_units(float(volume.amount))
	var target_area := maxf(0.0, visual_units * float(volume.area_per_unit))
	if target_area <= 0.0001:
		return
	var shape := str(volume.shape)
	if shape == "stream":
		_draw_stream_powder(volume, visual_units, target_area)
		return
	if shape == "fall":
		_draw_falling_powder(volume, visual_units, target_area)
		return
	if visual_units <= 64.0:
		_draw_dust_pixels(volume, visual_units)
		return
	_draw_dust_cloud(volume, target_area)

func _visual_units(amount: float) -> float:
	if amount > 0.0001 and amount < 5.0:
		return 4.0
	return maxf(0.0, amount)

func _draw_dust_pixels(volume: Dictionary, visual_units: float) -> void:
	var unit_area := float(volume.area_per_unit)
	var unit_side := sqrt(unit_area)
	var count := ceili(visual_units)
	var shape := str(volume.shape)
	var center := Vector2(volume.position)
	var direction := float(volume.direction)
	var seed_value := int(volume.seed)
	for index in range(count):
		var represented := minf(1.0, visual_units - float(index))
		if represented <= 0.0:
			break
		var size := Vector2(unit_side, unit_side * represented)
		var local := _dust_pixel_offset(index, count, shape, unit_side, seed_value)
		local.x *= direction
		var color := Color("fffdf2") if index % 3 == 0 else Color("e8e4d5")
		draw_rect(Rect2(center + local - size * 0.5, size), color, true)

func _draw_stream_powder(volume: Dictionary, visual_units: float, target_area: float) -> void:
	var trail: PackedVector2Array = volume.get("trail", PackedVector2Array())
	if trail.is_empty():
		trail.append(Vector2(volume.position))
	var count := mini(256, ceili(visual_units))
	var area_per_fleck := target_area / (visual_units if visual_units <= 256.0 else float(maxi(1, count)))
	var side := sqrt(area_per_fleck)
	var seed_value := int(volume.seed)
	for index in range(count):
		var represented := minf(1.0, visual_units - float(index)) if visual_units <= 256.0 else 1.0
		if represented <= 0.0:
			break
		var progress := clampf((float(index) + _noise(seed_value, index) * 0.85) / float(maxi(1, count)), 0.0, 1.0)
		var point := _sample_trail(trail, progress)
		var tangent := _trail_tangent(trail, progress)
		var normal := Vector2(-tangent.y, tangent.x)
		var scatter := (_noise(seed_value + 19, index) - 0.5) * maxf(5.0, side * 3.2)
		var along := (_noise(seed_value + 37, index) - 0.5) * maxf(2.0, side)
		point += normal * scatter + tangent * along
		var fleck_size := Vector2(side, side * represented)
		var color := Color("fffdf2") if index % 4 == 0 else Color("e9e5d8")
		draw_rect(Rect2(point - fleck_size * 0.5, fleck_size), color, true)

func _draw_falling_powder(volume: Dictionary, visual_units: float, target_area: float) -> void:
	var count := mini(256, ceili(visual_units))
	var area_per_fleck := target_area / (visual_units if visual_units <= 256.0 else float(maxi(1, count)))
	var side := sqrt(area_per_fleck)
	var center := Vector2(volume.position)
	var seed_value := int(volume.seed)
	# Distribución de copos en una nube ancha. El radio crece con sqrt(N), de modo
	# que el minado y Otra Rayita nunca vuelven a dibujar una columna vertical.
	var cloud_radius := maxf(5.0, sqrt(target_area) * 1.25)
	for index in range(count):
		var represented := minf(1.0, visual_units - float(index)) if visual_units <= 256.0 else 1.0
		if represented <= 0.0:
			break
		var angle := float(index) * 2.399963 + _noise(seed_value, index) * 0.55
		var radius := sqrt((float(index) + 0.5) / float(maxi(1, count))) * cloud_radius
		var offset := Vector2(cos(angle) * radius, sin(angle) * radius * 0.62)
		offset += Vector2((_noise(seed_value + 11, index) - 0.5) * side * 1.8, (_noise(seed_value + 23, index) - 0.5) * side * 1.8)
		var fleck_size := Vector2(side, side * represented)
		var color := Color("fffdf2") if index % 4 == 0 else Color("e7e3d5")
		draw_rect(Rect2(center + offset - fleck_size * 0.5, fleck_size), color, true)

func _sample_trail(trail: PackedVector2Array, progress: float) -> Vector2:
	if trail.size() <= 1:
		return trail[0]
	var scaled := progress * float(trail.size() - 1)
	var low := floori(scaled)
	var high := mini(low + 1, trail.size() - 1)
	return trail[low].lerp(trail[high], scaled - float(low))

func _trail_tangent(trail: PackedVector2Array, progress: float) -> Vector2:
	if trail.size() <= 1:
		return Vector2.RIGHT
	var index := clampi(roundi(progress * float(trail.size() - 1)), 0, trail.size() - 1)
	var low := maxi(0, index - 1)
	var high := mini(trail.size() - 1, index + 1)
	var tangent := trail[high] - trail[low]
	return tangent.normalized() if tangent.length_squared() > 0.0001 else Vector2.RIGHT

func _dust_pixel_offset(index: int, count: int, shape: String, unit_side: float, seed_value: int) -> Vector2:
	var jitter_x := (_noise(seed_value, index * 2) - 0.5) * unit_side * 0.9
	var jitter_y := (_noise(seed_value, index * 2 + 1) - 0.5) * unit_side * 0.9
	var columns := maxi(2, ceili(sqrt(float(count) * 1.5)))
	var row := index / columns
	var column := index % columns
	var centered_x := (float(column) - float(columns - 1) * 0.5) * unit_side * 1.08
	var centered_y := -float(row) * unit_side * 1.02
	return Vector2(centered_x + jitter_x * 0.35, centered_y + jitter_y * 0.25)

func _draw_dust_cloud(volume: Dictionary, target_area: float) -> void:
	var shape := str(volume.shape)
	var aspect := 1.8
	if shape == "vehicle": aspect = 2.6
	# El radio solo establece la caja inicial. El contorno se vuelve irregular y
	# después se normaliza para conservar exactamente el área solicitada.
	var radius_y := sqrt(target_area / (PI * aspect))
	var radius_x := radius_y * aspect
	var points := PackedVector2Array()
	var center := Vector2(volume.position)
	var direction := float(volume.direction)
	var seed_value := int(volume.seed)
	for index in range(26):
		var angle := TAU * float(index) / 26.0
		var roughness := 0.72 + _noise(seed_value, index) * 0.48
		var local := Vector2(cos(angle) * radius_x * roughness * direction, sin(angle) * radius_y * roughness)
		if shape in ["heap", "vehicle"] and local.y > 0.0:
			local.y *= 0.36
		points.append(center + local)
	var polygon_area := absf(_polygon_area(points))
	if polygon_area > 0.0001:
		var correction := sqrt(target_area / polygon_area)
		for index in range(points.size()):
			points[index] = center + (points[index] - center) * correction
	var color := Color("f4f0dc")
	if shape == "stream": color = Color("f8f5e8")
	draw_colored_polygon(points, color)
	# Manchas interiores pequeñas rompen la lectura de bloque sólido. Se dibujan
	# sobre la propia nube, por lo que no suman ni restan superficie de cocaína.
	for index in range(18):
		var local := Vector2(
			(_noise(seed_value + 31, index * 2) - 0.5) * radius_x * 1.25,
			(_noise(seed_value + 47, index * 2 + 1) - 0.5) * radius_y * 1.15
		)
		local.x *= direction
		var point := center + local
		if Geometry2D.is_point_in_polygon(point, points):
			var speck := 0.75 + _noise(seed_value + 73, index) * 0.75
			draw_rect(Rect2(point - Vector2.ONE * speck * 0.5, Vector2.ONE * speck), Color("c9c4b7") if index % 3 else Color("ffffff"), true)

func _noise(seed_value: int, index: int) -> float:
	return absf(fmod(sin(float(seed_value % 100003) * 0.0137 + float(index) * 12.9898) * 43758.5453, 1.0))

func _polygon_area(points: PackedVector2Array) -> float:
	var result := 0.0
	for index in range(points.size()):
		var next := (index + 1) % points.size()
		result += points[index].x * points[next].y - points[next].x * points[index].y
	return result * 0.5
