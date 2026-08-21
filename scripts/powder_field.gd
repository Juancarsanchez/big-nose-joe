class_name PowderField
extends RefCounted

# Única fuente de verdad para la cocaína suelta. Cada cantidad es masa real;
# no existen granos u objetos con un valor oculto.
var columns := {"left": {}, "right": {}}
var totals := {"left": 0.0, "right": 0.0}
var joe_totals := {"left": 0.0, "right": 0.0}
var revisions := {"left": 0, "right": 0}

func clear(side: String = "") -> void:
	var sides := [side] if not side.is_empty() else ["left", "right"]
	for current in sides:
		columns[current] = {}
		totals[current] = 0.0
		joe_totals[current] = 0.0
		revisions[current] = int(revisions.get(current, 0)) + 1

func amount(side: String) -> float:
	return float(totals.get(side, 0.0))

func joe_amount(side: String) -> float:
	return float(joe_totals.get(side, 0.0))

func mass_columns(side: String) -> Dictionary:
	var result := {}
	for column_value in (columns.get(side, {}) as Dictionary):
		var cell: Dictionary = (columns[side] as Dictionary)[column_value]
		result[int(column_value)] = float(cell.get("player", 0.0)) + float(cell.get("joe", 0.0))
	return result

func column_amount(side: String, column: int) -> float:
	var cell: Dictionary = (columns.get(side, {}) as Dictionary).get(column, {})
	return float(cell.get("player", 0.0)) + float(cell.get("joe", 0.0))

func add(side: String, column: int, value: float, source: String = "player") -> float:
	var accepted := maxf(0.0, value)
	if accepted <= 0.0:
		return 0.0
	var side_columns: Dictionary = columns[side]
	var cell: Dictionary = side_columns.get(column, {"player": 0.0, "joe": 0.0})
	var source_key := "player" if source == "player" else "joe"
	cell[source_key] = float(cell.get(source_key, 0.0)) + accepted
	side_columns[column] = cell
	totals[side] = float(totals[side]) + accepted
	if source_key == "joe":
		joe_totals[side] = float(joe_totals[side]) + accepted
	revisions[side] = int(revisions[side]) + 1
	return accepted

func take(side: String, requested: float, preferred_column: int = 999) -> Dictionary:
	var remaining := minf(maxf(0.0, requested), amount(side))
	var result := {"amount": 0.0, "player": 0.0, "joe": 0.0}
	if remaining <= 0.0:
		return result
	var ordered: Array = (columns[side] as Dictionary).keys()
	if preferred_column == 999:
		ordered.sort_custom(func(a, b) -> bool: return column_amount(side, int(a)) > column_amount(side, int(b)))
	else:
		ordered.sort_custom(func(a, b) -> bool: return abs(int(a) - preferred_column) < abs(int(b) - preferred_column))
	for column_value in ordered:
		if remaining <= 0.0001:
			break
		var column := int(column_value)
		var cell: Dictionary = (columns[side] as Dictionary).get(column, {})
		# Joe queda arriba de forma conceptual: su polvo reciente sale primero. Esto
		# mantiene legible la presión de Otra Rayita sin inventar objetos visuales.
		for source_key in ["joe", "player"]:
			var available := float(cell.get(source_key, 0.0))
			var removed := minf(available, remaining)
			if removed <= 0.0:
				continue
			cell[source_key] = available - removed
			result[source_key] = float(result[source_key]) + removed
			result.amount = float(result.amount) + removed
			remaining -= removed
			totals[side] = maxf(0.0, float(totals[side]) - removed)
			if source_key == "joe":
				joe_totals[side] = maxf(0.0, float(joe_totals[side]) - removed)
		if float(cell.get("player", 0.0)) + float(cell.get("joe", 0.0)) <= 0.0001:
			(columns[side] as Dictionary).erase(column)
		else:
			(columns[side] as Dictionary)[column] = cell
	if float(result.amount) > 0.0:
		revisions[side] = int(revisions[side]) + 1
	return result

func densest_column(side: String, minimum: float = 0.0) -> int:
	var best := 999
	var best_amount := minimum
	for column_value in (columns[side] as Dictionary):
		var current := column_amount(side, int(column_value))
		if current >= best_amount:
			best_amount = current
			best = int(column_value)
	return best

func serialize() -> Array:
	var data: Array = []
	for side in ["left", "right"]:
		for column_value in (columns[side] as Dictionary):
			var cell: Dictionary = (columns[side] as Dictionary)[column_value]
			data.append([side, int(column_value), float(cell.get("player", 0.0)), float(cell.get("joe", 0.0))])
	return data

func restore(data: Variant) -> void:
	clear()
	if typeof(data) != TYPE_ARRAY:
		return
	for value in data:
		if typeof(value) != TYPE_ARRAY or (value as Array).size() < 4:
			continue
		var row: Array = value
		add(str(row[0]), int(row[1]), float(row[2]), "player")
		add(str(row[0]), int(row[1]), float(row[3]), "joe")
