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
	mass_volumes[id] = {"position": position, "amount": amount, "area_per_unit": area_per_unit, "shape": shape, "direction": direction, "seed":absi(hash(id))}
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

func _dust_pixel_offset(index: int, count: int, shape: String, unit_side: float, seed_value: int) -> Vector2:
	var jitter_x := (_noise(seed_value, index * 2) - 0.5) * unit_side * 0.9
	var jitter_y := (_noise(seed_value, index * 2 + 1) - 0.5) * unit_side * 0.9
	if shape == "stream":
		var progress := (float(index) - float(count - 1) * 0.5) * unit_side * 1.35
		return Vector2(progress + jitter_x, jitter_y)
	if shape == "fall":
		var progress := (float(index) - float(count - 1) * 0.5) * unit_side * 1.3
		return Vector2(jitter_x, progress + jitter_y)
	var columns := maxi(2, ceili(sqrt(float(count) * 1.5)))
	var row := index / columns
	var column := index % columns
	var centered_x := (float(column) - float(columns - 1) * 0.5) * unit_side * 1.08
	var centered_y := -float(row) * unit_side * 1.02
	return Vector2(centered_x + jitter_x * 0.35, centered_y + jitter_y * 0.25)

func _draw_dust_cloud(volume: Dictionary, target_area: float) -> void:
	var shape := str(volume.shape)
	var aspect := 1.8
	if shape == "stream": aspect = 5.8
	elif shape == "fall": aspect = 0.62
	elif shape == "vehicle": aspect = 2.6
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
