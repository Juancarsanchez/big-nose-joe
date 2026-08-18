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
	var columns: Dictionary = source.pile_columns[side]
	if columns.is_empty():
		return
	var keys: Array = columns.keys()
	keys.sort()
	var first := int(keys.front())
	var last := int(keys.back())
	var ground := float(source._ground_y()) - 3.0
	var center := float(source._pile_center(side))
	var spacing := float(source.GRAIN_SPACING)
	var raw_heights := PackedFloat32Array()
	var joe_heights := PackedFloat32Array()
	var side_visual: Dictionary = visual_heights[side]
	for column in range(first, last + 1):
		var stack: Array = columns.get(column, [])
		var total := 0.0
		var joe_top := 0.0
		var top_is_joe := true
		for index in range(stack.size() - 1, -1, -1):
			var piece = stack[index]
			var kind := str(piece.get_meta("kind", "grain"))
			if kind not in ["grain", "impurity"]:
				top_is_joe = false
				continue
			var height := float(piece.get_meta("height", source.GRAIN_HEIGHT))
			total += height
			if top_is_joe and kind == "grain" and str(piece.get_meta("source", "player")) != "player":
				joe_top += height
			else:
				top_is_joe = false
		var displayed := lerpf(float(side_visual.get(column, 0.0)), total, 0.34)
		if absf(displayed - total) < 0.15:
			displayed = total
		side_visual[column] = displayed
		raw_heights.append(displayed)
		joe_heights.append(joe_top)
	var heights := _smooth(raw_heights)
	var surface := PackedVector2Array()
	var fill := PackedVector2Array([Vector2(center + float(first) * spacing - spacing * 0.6, ground)])
	for index in range(heights.size()):
		var point := Vector2(center + float(first + index) * spacing, ground - heights[index])
		surface.append(point)
		fill.append(point)
	fill.append(Vector2(center + float(last) * spacing + spacing * 0.6, ground))
	draw_colored_polygon(fill, POWDER)
	_draw_lower_shade(fill, ground)
	_draw_joe_layer(surface, joe_heights)
	if surface.size() >= 2:
		draw_polyline(surface, OUTLINE, 2.2, true)
	_draw_powder_noise(side, first, heights, center, spacing, ground)
	_draw_impurity_stains(columns, first, heights, center, spacing, ground)

func _smooth(values: PackedFloat32Array) -> PackedFloat32Array:
	var result := values.duplicate()
	for pass_index in range(2):
		var previous := result.duplicate()
		for index in range(1, result.size() - 1):
			result[index] = previous[index] * 0.58 + (previous[index - 1] + previous[index + 1]) * 0.21
	return result

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

func _draw_impurity_stains(columns: Dictionary, first: int, heights: PackedFloat32Array, center: float, spacing: float, ground: float) -> void:
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
		var column := int(piece.get_meta("column", first))
		var surface_index := column - first
		if surface_index < 0 or surface_index >= heights.size():
			continue
		var surface_y := ground - float(heights[surface_index])
		pos.x = center + float(column) * spacing + clampf(pos.x - (center + float(column) * spacing), -spacing * 0.35, spacing * 0.35)
		pos.y = clampf(pos.y, surface_y + 6.0, ground - 5.0)
		var color: Color = IMPURITY_COLORS.get(str(piece.get_meta("material", "")), Color("a58b53"))
		var size := 5.0 + float((index * 13) % 5)
		var patch := PackedVector2Array([
			pos + Vector2(-size, 0.5), pos + Vector2(-size * 0.35, -size * 0.45),
			pos + Vector2(size, -0.2), pos + Vector2(size * 0.25, size * 0.42)
		])
		draw_colored_polygon(patch, color)
