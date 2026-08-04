extends Control

const SAVE := "user://big_nose_joe.save"
const SAVE_VERSION := 9
const ProgressionData = preload("res://scripts/progression_data.gd")
const PHASES := ProgressionData.PHASES
const UPGRADES := ProgressionData.UPGRADES
const PHASE_SHORT_NAMES := ["DESAYUNO", "AVALANCHA", "ADULTERADA", "VOLCÁN", "ZOO"]
const STAGE_WIDTH := 5200.0
const SEPTUM_X := 2600.0
const WORLD_SCALE := 0.68
const FLOOR_HEIGHT := 95.0
const FIRST_WALL_HP := 120000.0
const FIRST_LEFT_WALL_HP := 180000.0
const TUNNEL_UNLOCK_RATIO := 0.50
const EDGE_SIZE := 34.0
const PAN_SPEED := 1050.0
const GRAIN_SPACING := 10.0
const GRAIN_HEIGHT := 7.4
const ROCK_HEIGHT := 18.0
const MAX_PILE_RADIUS := 46
const MAX_SURFACE_STEP := 1.7
const TERRAIN_BAND_SIZE := 30
const TERRAIN_ANCHORS := [0.16, 0.68, 0.38, 0.84, 0.53]
const ANOTHER_LINE_ANCHORS := [0.10, 0.52, 0.90]
const ANOTHER_LINE_SHIFTS := [0.0, 0.08, -0.05, 0.13, -0.10]
const COMPACTION_THRESHOLD := 24.0
const COMPACTION_INTERVAL := 3
const COMPACTION_GRAINS := 6
const RIGHT_WALL_COLUMN := -5
const LEFT_WALL_COLUMN := 5
const BASE_PAWN_SPEED := 70.0
const BASE_CAPACITY := 3
const PAWN_FOOT_DEPTH := 14.0
const PUNCH_BASE_INTERVAL := 3.4
const PUNCHER_WALK_SPEED := 235.0
const PUNCHER_STRIKE_TIME := 0.18
const MANUAL_DELIVERY_BASE_TIME := 0.46
const JOE_STARTING_HEALTH := 30.0
const JOE_RECOVERY_PER_CLEAN_UNIT := 0.01
const ANOTHER_LINE_INTERVAL := 180.0
const ANOTHER_LINE_WARNING := 8.0
const JOE_DROP_INTERVALS := [0.0, 0.0, 4.5, 4.0, 3.5, 3.0]
const WALL_CHUNK_MASS := 25.0
const WALL_CHUNK_HEALTH := 24.0
const WALL_CHUNK_MAX_CLICK_DAMAGE := 3.0
const WALL_CHUNK_SCALE := 0.12
const WALL_CHUNK_CELL := 512
const MAX_FALLEN_WALL_CHUNKS := 4

const PAWN_EMPTY := preload("res://assets/art/gameplay/sprites/pawn_empty.png")
const PAWN_CARRY := preload("res://assets/art/gameplay/sprites/pawn_carry.png")
const SPECIALIST_EMPTY := preload("res://assets/art/gameplay/sprites/pawn_specialist_empty.png")
const SPECIALIST_CARRY := preload("res://assets/art/gameplay/sprites/pawn_specialist_carry.png")
const DETECTOR_EMPTY := preload("res://assets/art/gameplay/sprites/pawn_detector_empty.png")
const DETECTOR_CARRY := preload("res://assets/art/gameplay/sprites/pawn_detector_carry.png")
const HANDLER_EMPTY := preload("res://assets/art/gameplay/sprites/pawn_handler_empty.png")
const HANDLER_CARRY := preload("res://assets/art/gameplay/sprites/pawn_handler_carry.png")
const PLATELET_TEXTURE := preload("res://assets/art/gameplay/sprites/platelet.png")
const BACTERIA_TEXTURE := preload("res://assets/art/gameplay/sprites/bacteria.png")
const GRAIN_TEXTURE := preload("res://assets/art/gameplay/sprites/cocaine_grain.png")
const WALL_CHUNK_SHEET := preload("res://assets/art/gameplay/sprites/cocaine_wall_chunks.png")

@onready var stage_view: Control = $World/StageViewport
@onready var stage: Control = $World/StageViewport/Stage
@onready var pawns: Control = $World/StageViewport/Stage/Layer60_Pawns
@onready var punchers: Control = $World/StageViewport/Stage/Layer58_Punchers
@onready var chunks: Control = $World/StageViewport/Stage/Layer50_Chunks
@onready var wall_chunks_layer: Control = $World/StageViewport/Stage/Layer52_WallChunks
@onready var platelets: Control = $World/StageViewport/Stage/Layer55_Platelets
@onready var effects: Control = $World/StageViewport/Stage/Layer70_Effects
@onready var blood_wash: ColorRect = $World/StageViewport/Stage/Layer46_Crisis/BloodWash
@onready var blood_drops: Control = $World/StageViewport/Stage/Layer46_Crisis/BloodDrops
@onready var damage_meter: PanelContainer = $World/DamageMeter
@onready var damage_label: Label = $World/DamageMeter/Margin/Content/Label
@onready var damage_progress: ProgressBar = $World/DamageMeter/Margin/Content/Progress
@onready var joe_health_label: Label = $World/JoePrognosis/Margin/Content/Label
@onready var joe_health_progress: ProgressBar = $World/JoePrognosis/Margin/Content/Progress
@onready var joe_portrait: TextureRect = $World/JoePrognosis/Margin/Content/Portrait
@onready var contamination_meter: PanelContainer = $World/ContaminationMeter
@onready var contamination_label: Label = $World/ContaminationMeter/Margin/Content/Label
@onready var contamination_progress: ProgressBar = $World/ContaminationMeter/Margin/Content/Progress
@onready var box: TextureRect = $World/StageViewport/Stage/Layer30_Props/CollectionBox
@onready var right_button: Button = $World/StageViewport/Stage/Layer40_Resources/RightWallButton
@onready var left_button: Button = $World/StageViewport/Stage/Layer40_Resources/LeftWallButton
@onready var right_visual: TextureRect = $World/StageViewport/Stage/Layer40_Resources/RightWallButton/Visual
@onready var left_visual: TextureRect = $World/StageViewport/Stage/Layer40_Resources/LeftWallButton/Visual
@onready var septum_upper: TextureRect = $World/StageViewport/Stage/Layer10_Septum/Upper
@onready var septum_gate: TextureRect = $World/StageViewport/Stage/Layer10_Septum/Gate
@onready var septum_hole: ColorRect = $World/StageViewport/Stage/Layer10_Septum/Hole
@onready var left_caption: Label = $World/StageViewport/Stage/LeftCaption
@onready var phase_label: Label = $World/TopBar/Margin/Stats/Phase
@onready var cells_label: Label = $World/TopBar/Margin/Stats/Cells
@onready var rate_label: Label = $World/TopBar/Margin/Stats/Rate
@onready var pressure_label: Label = $World/TopBar/Margin/Stats/Pressure
@onready var wall_label: Label = $World/TopBar/Margin/Stats/WallState
@onready var click_counter: Label = $World/TopBar/Margin/Stats/ClickCounter
@onready var break_button: Button = $Shop/Margin/Content/SeptumUpgradeButton
@onready var upgrade_list: VBoxContainer = $Shop/Margin/Content/UpgradeScroll/UpgradeList
@onready var upgrade_scroll: ScrollContainer = $Shop/Margin/Content/UpgradeScroll
@onready var phase_progress: ProgressBar = $Shop/Margin/Content/PhaseProgress
@onready var phase_hint: Label = $Shop/Margin/Content/PhaseHint
@onready var shop_subtitle: Label = $Shop/Margin/Content/Subtitle
@onready var world_subtitle: Label = $World/Subtitle
@onready var toast: Label = $World/Toast
@onready var start_screen: Control = $StartScreen
@onready var continue_button: Button = $StartScreen/Menu/Margin/Content/ContinueButton
@onready var save_state: Label = $StartScreen/Menu/Margin/Content/SaveState
@onready var joe_dialog: AcceptDialog = $JoeEventDialog
@onready var phase_debug_list: VBoxContainer = $PhaseLab/Margin/Content/PhaseList
@onready var phase_debug_active: Label = $PhaseLab/Margin/Content/Active

var cells := 0.0
var right_hp := FIRST_WALL_HP
var right_max := FIRST_WALL_HP
var left_hp := FIRST_LEFT_WALL_HP
var left_max := FIRST_LEFT_WALL_HP
var right_cleared := 0
var left_cleared := 0
var total_clicks := 0
var septum_open := false
var active_side := "right"
var levels := _empty_levels()
var buttons := {}
var phase_debug_buttons := {}
var loose_chunks: Array[Sprite2D] = []
var fallen_wall_chunks: Array[Sprite2D] = []
var compaction_steps := {"left":0, "right":0}
var compaction_announced := false
var current_phase := 1
var phase_work := 0.0
var contamination := 0.0
var tissue_damage := 0.0
var infection := 0.0
var joe_health := JOE_STARTING_HEALTH
var joe_health_display := JOE_STARTING_HEALTH
var impurities_handled := 0
var bacteria_handled := 0
var joe_clock := 0.0
var bacteria_clock := 0.0
var blood_drop_clock := 0.0
var punch_clock := 0.0
var contamination_band := 0
var box_jammed := false
var another_line_clock := ANOTHER_LINE_INTERVAL
var another_line_wave := 0
var another_line_drop_clock := 0.0
var another_line_spawn_index := 0
var another_line_events := 0
var another_line_warned := false
var puncher_unlocked := false
var puncher_debut_pending := false
var puncher_debut_clock := 0.0
var manual_clicks_since_burst := 0
var rocks_opened := 0
var impurities_cleaned := 0
var tissue_repaired := 0.0
var phase_event_pending := false
var camera_x := 0.0
var camera_goal := -1.0
var playing := false
var ui_clock := 0.0
var save_path := SAVE

func _ready() -> void:
	for phase in PHASES:
		var phase_button := Button.new()
		phase_button.custom_minimum_size = Vector2(0, 54)
		phase_button.add_theme_font_size_override("font_size", 9)
		phase_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		phase_button.pressed.connect(_debug_set_phase.bind(int(phase.id)))
		phase_debug_list.add_child(phase_button)
		phase_debug_buttons[phase.id] = phase_button
	for upgrade in UPGRADES:
		var button := Button.new()
		button.custom_minimum_size = Vector2(248, 64)
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_buy.bind(upgrade.id))
		upgrade_list.add_child(button)
		buttons[upgrade.id] = button
	right_button.pressed.connect(_click_wall.bind("right"))
	left_button.pressed.connect(_click_wall.bind("left"))
	break_button.pressed.connect($BreakDialog.popup_centered)
	$BreakDialog.confirmed.connect(_open_septum)
	$Shop/Margin/Content/ExitButton.pressed.connect(_exit_game)
	continue_button.pressed.connect(_continue_game)
	$StartScreen/Menu/Margin/Content/NewGameButton.pressed.connect(_request_new_game)
	$StartScreen/Menu/Margin/Content/ExitButton.pressed.connect(get_tree().quit)
	$NewGameDialog.confirmed.connect(_new_game)
	joe_dialog.confirmed.connect(_resume_after_joe)
	joe_dialog.close_requested.connect(_resume_after_joe)
	$SaveTimer.timeout.connect(_save)
	call_deferred("_finish_layout")
	_update_start_screen()
	_update_world()
	_update_ui()

func _finish_layout() -> void:
	stage.scale = Vector2(WORLD_SCALE, WORLD_SCALE)
	stage.size = Vector2(STAGE_WIDTH, stage_view.size.y / WORLD_SCALE)
	septum_upper.offset_bottom = stage.size.y - 245.0
	camera_x = _closed_camera_min()
	stage.position.x = -camera_x * WORLD_SCALE
	_update_box()
	_rebuild_pawns()
	_rebuild_punchers()
	_rebuild_platelets()
	_update_crisis_visuals()
	_update_pressure_visuals()

func _process(delta: float) -> void:
	if not playing:
		return
	_update_camera(delta)
	_update_another_line(delta)
	_update_crisis(delta)
	_update_box_jam(delta)
	_update_joe_prognosis(delta)
	_update_punchers(delta)
	_update_pawns(delta)
	_update_platelets(delta)
	ui_clock += delta
	if ui_clock >= 0.12:
		ui_clock = 0.0
		_update_pressure_visuals()
		_update_ui()

func _update_camera(delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if Input.is_key_pressed(KEY_A): direction -= 1.0
	if Input.is_key_pressed(KEY_D): direction += 1.0
	var mouse := stage_view.get_local_mouse_position()
	if Rect2(Vector2.ZERO, stage_view.size).has_point(mouse):
		if mouse.x <= EDGE_SIZE: direction -= 1.0
		elif mouse.x >= stage_view.size.x - EDGE_SIZE: direction += 1.0
	if camera_goal >= 0.0 and is_zero_approx(direction):
		camera_x = move_toward(camera_x, camera_goal, PAN_SPEED * delta)
		if is_equal_approx(camera_x, camera_goal): camera_goal = -1.0
	else:
		camera_goal = -1.0
		camera_x += clampf(direction, -1.0, 1.0) * PAN_SPEED * delta
	var minimum := 0.0 if septum_open else _closed_camera_min()
	camera_x = clampf(camera_x, minimum, maxf(minimum, STAGE_WIDTH - _visible_world_width()))
	stage.position.x = -round(camera_x * WORLD_SCALE)

func _closed_camera_min() -> float:
	return maxf(0.0, SEPTUM_X - _visible_world_width() * 0.5)

func _visible_world_width() -> float:
	return stage_view.size.x / WORLD_SCALE

func _ground_y() -> float:
	return stage.size.y - FLOOR_HEIGHT

func _mine_x(side: String = active_side) -> float:
	return 2418.0 if side == "left" else 2782.0

func _wall_hp(side: String) -> float:
	return left_hp if side == "left" else right_hp

func _pile_center(side: String) -> float:
	return _mine_x(side) + (-58.0 if side == "left" else 58.0)

func _box_x() -> float:
	return box.position.x + box.size.x * 0.35

func _pawn_speed() -> float:
	var crisis_factor := 1.0
	if current_phase >= 4:
		crisis_factor *= lerpf(1.0, 0.68, tissue_damage / 100.0)
	if current_phase >= 5:
		crisis_factor *= lerpf(1.0, 0.72, infection / 100.0)
	return BASE_PAWN_SPEED * (1.0 + float(levels.shift) * 0.18) * crisis_factor

func _transport_capacity() -> int:
	return BASE_CAPACITY + int(levels.box)

func _deposit_duration() -> float:
	return 0.30 / _deposit_speed_multiplier()

func _deposit_speed_multiplier() -> float:
	return lerpf(1.0, 0.35, contamination / 100.0) if current_phase >= 3 else 1.0

func _box_yield_multiplier() -> float:
	return lerpf(1.0, 0.40, contamination / 100.0) if current_phase >= 3 else 1.0

func _update_box_jam(delta: float) -> void:
	if current_phase < 3:
		box_jammed = false
		return
	if not box_jammed and contamination >= 99.9:
		box_jammed = true
		_show_toast("CAJA ATASCADA  ·  TODOS PARADOS")
	if box_jammed and int(levels.detector) > 0:
		contamination = maxf(0.0, contamination - float(levels.detector) * 0.25 * delta)
	if box_jammed and contamination <= 85.0:
		box_jammed = false
		_show_toast("LA CAJA VUELVE A TRAGAR")
	_update_box()

func _pile_access_point(side: String) -> Vector2:
	var rightmost_column := 2
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side):
			rightmost_column = maxi(rightmost_column, int(piece.get_meta("column", 0)))
	var edge := maxf(34.0, float(rightmost_column) * GRAIN_SPACING + 22.0)
	return Vector2(_pile_center(side) + edge, _ground_y() - 14.0)

func _set_pawn_carrying(pawn: Sprite2D, carrying: bool) -> void:
	var specialist := bool(pawn.get_meta("specialist", false))
	var detector := bool(pawn.get_meta("detector", false))
	var handler := bool(pawn.get_meta("handler", false))
	var target: Texture2D
	if handler:
		var holds_bacteria := false
		for piece_value in pawn.get_meta("cargo", []):
			var piece := piece_value as Sprite2D
			if is_instance_valid(piece) and piece.get_meta("kind", "grain") == "bacteria":
				holds_bacteria = true
				break
		target = HANDLER_CARRY if carrying and holds_bacteria else HANDLER_EMPTY
	elif detector:
		target = DETECTOR_CARRY if carrying else DETECTOR_EMPTY
	elif specialist:
		target = SPECIALIST_CARRY if carrying else SPECIALIST_EMPTY
	else:
		target = PAWN_CARRY if carrying else PAWN_EMPTY
	if pawn.texture == target:
		return
	pawn.texture = target
	pawn.offset = Vector2(0.0, PAWN_FOOT_DEPTH / pawn.scale.y - target.get_height() * 0.5)

func _update_pawns(delta: float) -> void:
	for node in pawns.get_children():
		var pawn := node as Sprite2D
		if not pawn: continue
		if box_jammed:
			pawn.rotation = 0.0
			continue
		var state: String = pawn.get_meta("state", "to_pile")
		var side: String = pawn.get_meta("side", active_side)
		var speed := _pawn_speed() * (1.0 + float(int(pawn.get_meta("index", 0)) % 3) * 0.025)
		var lane_x := float(pawn.get_meta("lane_x", 0.0))
		var floor_y := _ground_y() - 14.0
		var depot := Vector2(_box_x() + lane_x, floor_y)
		var work_point := _pile_access_point(side) + Vector2(lane_x, 0.0)
		if state == "to_pile":
			var obstruction := _nearest_fallen_wall_chunk(side, pawn.position)
			if obstruction:
				var queue_offset := float(int(pawn.get_meta("index", 0))) * 13.0
				var stop := Vector2(obstruction.position.x + 43.0 + queue_offset, floor_y)
				pawn.position = pawn.position.move_toward(stop, speed * delta)
				_set_pawn_carrying(pawn, false)
				continue
			pawn.position = pawn.position.move_toward(work_point, speed * delta)
			_set_pawn_carrying(pawn, false)
			if pawn.position.distance_to(work_point) < 1.0:
				pawn.position = work_point
				pawn.set_meta("state", "working")
				pawn.set_meta("timer", 0.18 / (1.0 + float(levels.shift) * 0.12))
				pawn.set_meta("did_mine", false)
		elif state == "working":
			var timer: float = float(pawn.get_meta("timer", 0.0)) - delta
			pawn.set_meta("timer", timer)
			pawn.position.x = work_point.x + sin(Time.get_ticks_msec() * 0.018 + int(pawn.get_meta("index", 0))) * 1.8
			if timer <= 0.0:
				if not bool(pawn.get_meta("did_mine", false)):
					if _wall_hp(side) > 0.0:
						_damage_wall(1.0, side)
						_spawn_chunk(Vector2(_mine_x(side) + lane_x * 0.35, _ground_y() - 245.0), 1.0, side)
					pawn.set_meta("did_mine", true)
					pawn.set_meta("timer", 0.86 / (1.0 + float(levels.shift) * 0.12))
				else:
					var rock := _top_untreated_rock(side)
					if bool(pawn.get_meta("specialist", false)) and is_instance_valid(rock):
						_chip_rock(rock)
						pawn.set_meta("timer", 0.34 / (1.0 + float(levels.shift) * 0.12))
					else:
						var cargo := _claim_top_pieces(side, _transport_capacity(), pawn)
						pawn.set_meta("cargo", cargo)
						if cargo.is_empty():
							pawn.set_meta("timer", 0.25)
						else:
							pawn.set_meta("state", "lifting")
							pawn.set_meta("timer", 0.24)
							_set_pawn_carrying(pawn, true)
		elif state == "lifting":
			var timer: float = float(pawn.get_meta("timer", 0.0)) - delta
			pawn.set_meta("timer", timer)
			_set_pawn_carrying(pawn, true)
			if timer <= 0.0: pawn.set_meta("state", "to_box")
		elif state == "to_box":
			pawn.position = pawn.position.move_toward(depot, speed * delta)
			_set_pawn_carrying(pawn, true)
			_update_carried_pieces(pawn)
			if pawn.position.distance_to(depot) < 1.0:
				pawn.position = depot
				_begin_deposit(pawn)
		elif state == "deposit":
			_set_pawn_carrying(pawn, true)
			var timer: float = float(pawn.get_meta("timer", 0.0)) + delta
			pawn.set_meta("timer", timer)
			var deposit_time := _deposit_duration()
			_update_deposit(pawn, clampf(timer / deposit_time, 0.0, 1.0))
			if timer >= deposit_time: _finish_delivery(pawn)

func _choose_work_side(index: int) -> String:
	if not septum_open or int(levels.coord) == 0: return active_side
	var left_score := _pile_load("left")
	var right_score := _pile_load("right")
	if int(levels.coord) >= 2:
		left_score += float(_untreated_rock_count("left")) * 18.0
		right_score += float(_untreated_rock_count("right")) * 18.0
	var assigned_left := 0
	var assigned_right := 0
	for node in pawns.get_children():
		var pawn := node as Sprite2D
		if pawn and not pawn.is_queued_for_deletion() and int(pawn.get_meta("index", -1)) < index:
			if pawn.get_meta("side", "right") == "left": assigned_left += 1
			else: assigned_right += 1
	left_score -= float(assigned_left) * 12.0
	right_score -= float(assigned_right) * 12.0
	if is_equal_approx(left_score, right_score):
		return "left" if index % 2 == 0 else "right"
	return "left" if left_score > right_score else "right"

func _spawn_chunk(origin: Vector2, value: float, side: String = active_side, preferred_column: int = 999) -> void:
	var column := _choose_landing_column(side, preferred_column)
	var piece := _create_piece("grain", side, value, 0, column, randf_range(0.068, 0.078))
	_drop_piece(piece, origin)

func _spawn_special_piece(kind: String, side: String, material: String = "") -> void:
	var scale := randf_range(0.078, 0.092) if kind == "impurity" else randf_range(0.07, 0.085)
	var value := 1.0 if kind == "impurity" else 2.0
	var piece := _create_piece(kind, side, value, 0, _choose_landing_column(side), scale, material)
	_drop_piece(piece, Vector2(_mine_x(side) + randf_range(-18.0, 18.0), _ground_y() - randf_range(210.0, 350.0)))

func _drop_piece(piece: Sprite2D, origin: Vector2) -> void:
	piece.position = origin + Vector2(randf_range(-10.0, 10.0), 0.0)
	piece.rotation = randf_range(-0.18, 0.18)
	piece.set_meta("landed", false)
	var landing := _landing_position(piece)
	var duration := randf_range(0.82, 1.18)
	var tween := create_tween().set_parallel()
	tween.tween_property(piece, "position", landing, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(piece, "rotation", piece.rotation + randf_range(-0.42, 0.42), duration)
	tween.chain().tween_callback(_mark_landed.bind(piece))

func _create_piece(kind: String, side: String, value: float, hardness: int, column: int, piece_scale: float, material: String = "") -> Sprite2D:
	var piece := Sprite2D.new()
	piece.texture = BACTERIA_TEXTURE if kind == "bacteria" else GRAIN_TEXTURE
	column = _constrain_column(side, column)
	piece.scale = Vector2(piece_scale, piece_scale)
	piece.set_meta("base_scale", piece_scale)
	piece.set_meta("kind", kind)
	piece.set_meta("value", value)
	piece.set_meta("side", side)
	piece.set_meta("column", column)
	piece.set_meta("x_jitter", randf_range(-3.8, 3.8))
	piece.set_meta("height", ROCK_HEIGHT if kind == "rock" else (10.0 if kind == "bacteria" else GRAIN_HEIGHT))
	piece.set_meta("material", material)
	piece.set_meta("landed", true)
	piece.set_meta("carried", false)
	piece.set_meta("hardness", hardness)
	piece.set_meta("max_hardness", hardness)
	if kind == "rock":
		piece.modulate = Color("d6d2c4")
		var crack := Line2D.new()
		crack.name = "Crack"
		crack.points = PackedVector2Array([Vector2(-19, -17), Vector2(-4, -4), Vector2(-11, 7), Vector2(12, 20)])
		crack.width = 4.0
		crack.default_color = Color(0.33, 0.3, 0.38, 0.82)
		crack.visible = false
		piece.add_child(crack)
	elif kind == "impurity":
		if material == "serrín": piece.modulate = Color("db8730")
		elif material == "yeso": piece.modulate = Color("8ea8c4")
		else: piece.modulate = Color("e5c744")
	chunks.add_child(piece)
	loose_chunks.append(piece)
	piece.position = _landing_position(piece)
	return piece

func _mark_landed(piece: Variant) -> void:
	if not is_instance_valid(piece): return
	var sprite := piece as Sprite2D
	if not sprite: return
	sprite.set_meta("landed", true)
	var side: String = sprite.get_meta("side", "right")
	_restack_pile(side)
	compaction_steps[side] = int(compaction_steps.get(side, 0)) + 1
	_maybe_compact(side)

func _piece_is_in_pile(piece: Sprite2D, side: String = "") -> bool:
	return is_instance_valid(piece) and not bool(piece.get_meta("carried", false)) and (side.is_empty() or piece.get_meta("side", "right") == side)

func _column_height(side: String, column: int, ignore: Sprite2D = null) -> float:
	var height := 0.0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side) and bool(piece.get_meta("landed", false)) and piece != ignore and int(piece.get_meta("column", 0)) == column:
			height += float(piece.get_meta("height", GRAIN_HEIGHT))
	return height

func _reserved_column_height(side: String, column: int, ignore: Sprite2D = null) -> float:
	var height := 0.0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side) and not bool(piece.get_meta("landed", false)) and piece != ignore and int(piece.get_meta("column", 0)) == column:
			height += float(piece.get_meta("height", GRAIN_HEIGHT))
	return height

func _terrain_height(side: String, column: int) -> float:
	return _column_height(side, column) + _reserved_column_height(side, column)

func _constrain_column(side: String, column: int) -> int:
	if side == "right" and column < RIGHT_WALL_COLUMN:
		return RIGHT_WALL_COLUMN + (RIGHT_WALL_COLUMN - column)
	if side == "left" and column > LEFT_WALL_COLUMN:
		return LEFT_WALL_COLUMN - (column - LEFT_WALL_COLUMN)
	return clampi(column, -MAX_PILE_RADIUS, MAX_PILE_RADIUS)

func _column_bounds(side: String, radius: int) -> Vector2i:
	return Vector2i(-radius, LEFT_WALL_COLUMN) if side == "left" else Vector2i(RIGHT_WALL_COLUMN, radius)

func _landing_position(piece: Sprite2D) -> Vector2:
	var side: String = piece.get_meta("side", "right")
	var column: int = int(piece.get_meta("column", 0))
	var piece_height: float = float(piece.get_meta("height", GRAIN_HEIGHT))
	var stack_height := _column_height(side, column, piece)
	return Vector2(_pile_center(side) + float(column) * GRAIN_SPACING + float(piece.get_meta("x_jitter", 0.0)), _ground_y() - 5.0 - stack_height - piece_height * 0.5)

func _natural_drop_center(side: String, bounds: Vector2i) -> int:
	var band := int(_pile_load(side) / float(TERRAIN_BAND_SIZE)) % TERRAIN_ANCHORS.size()
	return roundi(lerpf(float(bounds.x), float(bounds.y), float(TERRAIN_ANCHORS[band])))

func _choose_landing_column(side: String, preferred_column: int = 999) -> int:
	var radius := mini(MAX_PILE_RADIUS, 2 + int(sqrt(_pile_load(side) / 2.8)))
	var bounds := _column_bounds(side, radius)
	var center := _natural_drop_center(side, bounds) if preferred_column == 999 else clampi(_constrain_column(side, preferred_column), bounds.x, bounds.y)
	var column := clampi(center + randi_range(-1, 1), bounds.x, bounds.y)
	for step in range(radius * 2 + 4):
		var here := _terrain_height(side, column)
		var left := INF if column <= bounds.x else _terrain_height(side, column - 1)
		var right := INF if column >= bounds.y else _terrain_height(side, column + 1)
		if here <= minf(left, right) + GRAIN_HEIGHT * randf_range(0.85, MAX_SURFACE_STEP): break
		if is_equal_approx(left, right): column += -1 if randf() < 0.5 else 1
		else: column += -1 if left < right else 1
		column = clampi(column, bounds.x, bounds.y)
	return column

func _movable_top_piece(side: String, column: int) -> Sprite2D:
	var top: Sprite2D = null
	for piece in loose_chunks:
		if not _piece_is_in_pile(piece, side) or not bool(piece.get_meta("landed", false)) or int(piece.get_meta("column", 0)) != column:
			continue
		if not top or piece.position.y < top.position.y:
			top = piece
	if top and top.get_meta("kind", "grain") == "rock":
		return null
	return top

func _settle_surface(side: String, max_moves: int) -> void:
	var bounds := _column_bounds(side, MAX_PILE_RADIUS)
	for move in range(max_moves):
		var source_column := 999
		var target_column := 999
		var steepest := GRAIN_HEIGHT * MAX_SURFACE_STEP
		for column in range(bounds.x, bounds.y):
			var left := _column_height(side, column)
			var right := _column_height(side, column + 1)
			var difference := absf(left - right)
			if difference <= steepest:
				continue
			var high_column := column if left > right else column + 1
			if not _movable_top_piece(side, high_column):
				continue
			steepest = difference
			source_column = high_column
			target_column = column + 1 if left > right else column
		if source_column == 999:
			break
		var grain := _movable_top_piece(side, source_column)
		if not grain:
			break
		grain.set_meta("column", target_column)

func _top_pieces(side: String) -> Array[Sprite2D]:
	var by_column := {}
	for piece in loose_chunks:
		if not _piece_is_in_pile(piece, side) or not bool(piece.get_meta("landed", false)): continue
		var column: int = int(piece.get_meta("column", 0))
		if not by_column.has(column) or piece.position.y < (by_column[column] as Sprite2D).position.y:
			by_column[column] = piece
	var result: Array[Sprite2D] = []
	for piece in by_column.values():
		result.append(piece)
	result.sort_custom(func(a: Sprite2D, b: Sprite2D) -> bool: return a.position.y < b.position.y)
	return result

func _claim_top_pieces(side: String, capacity: int, pawn: Sprite2D) -> Array:
	var cargo: Array = []
	while cargo.size() < capacity:
		var collectable: Array[Sprite2D] = []
		var handler := bool(pawn.get_meta("handler", false))
		for candidate in _top_pieces(side):
			var kind: String = candidate.get_meta("kind", "grain")
			if kind == "rock" and (not bool(pawn.get_meta("specialist", false)) or int(candidate.get_meta("hardness", 0)) > 0): continue
			if kind == "bacteria" and not handler: continue
			collectable.append(candidate)
		if collectable.is_empty(): break
		var preferred: Array[Sprite2D] = []
		if handler:
			preferred = collectable.filter(func(item: Sprite2D) -> bool: return item.get_meta("kind", "grain") == "bacteria")
		elif bool(pawn.get_meta("detector", false)):
			preferred = collectable.filter(func(item: Sprite2D) -> bool: return item.get_meta("kind", "grain") == "impurity")
		elif bool(pawn.get_meta("specialist", false)):
			preferred = collectable.filter(func(item: Sprite2D) -> bool: return item.get_meta("kind", "grain") == "rock")
		var source := preferred if not preferred.is_empty() else collectable
		var piece := source[randi_range(0, mini(6, source.size() - 1))]
		piece.set_meta("carried", true)
		piece.z_index = 20
		if handler and piece.get_meta("kind", "grain") == "bacteria":
			piece.visible = false
		cargo.append(piece)
		var tween := create_tween().set_parallel()
		tween.tween_property(piece, "position", _cargo_position(pawn, cargo.size() - 1, capacity), 0.22).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(piece, "rotation", randf_range(-0.12, 0.12), 0.22)
	_settle_surface(side, maxi(2, capacity))
	_restack_pile(side)
	return cargo

func _surface_piece_at(world_pos: Vector2) -> Sprite2D:
	var side := "left" if world_pos.x < SEPTUM_X else "right"
	if side == "left" and not septum_open:
		return null
	var nearest: Sprite2D = null
	var nearest_x := INF
	for piece in _top_pieces(side):
		var visual_height := maxf(6.0, float(piece.get_meta("height", GRAIN_HEIGHT)))
		var hit_width := maxf(GRAIN_SPACING * 1.35, piece.texture.get_width() * absf(piece.scale.x) * 0.55)
		var distance_x := absf(world_pos.x - piece.position.x)
		if distance_x <= hit_width and world_pos.y >= piece.position.y - visual_height and world_pos.y <= _ground_y() + 5.0 and distance_x < nearest_x:
			nearest = piece
			nearest_x = distance_x
	return nearest

func _nearest_fallen_wall_chunk(side: String, from := Vector2.ZERO) -> Sprite2D:
	var nearest: Sprite2D = null
	var nearest_distance := INF
	var origin := from if from != Vector2.ZERO else Vector2(_mine_x(side), _ground_y())
	for chunk in fallen_wall_chunks:
		if not is_instance_valid(chunk) or chunk.get_meta("side", "right") != side or not bool(chunk.get_meta("landed", false)):
			continue
		var distance := origin.distance_squared_to(chunk.position)
		if distance < nearest_distance:
			nearest = chunk
			nearest_distance = distance
	return nearest

func _fallen_wall_chunk_at(world_pos: Vector2) -> Sprite2D:
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk) and bool(chunk.get_meta("landed", false)) and Rect2(chunk.position - Vector2(40.0, 42.0), Vector2(80.0, 84.0)).has_point(world_pos):
			return chunk
	return null

func _manual_mine_fallen_wall_chunk(world_pos: Vector2) -> bool:
	var chunk := _fallen_wall_chunk_at(world_pos)
	if not chunk:
		return false
	total_clicks += 1
	var hit := minf(minf(WALL_CHUNK_MAX_CLICK_DAMAGE, 1.0 + float(levels.nails) * 0.25), float(chunk.get_meta("hp", 0.0)))
	_mine_fallen_wall_chunk(chunk, hit)
	_float_text("BLOQUE  -%s" % _number(hit), world_pos - Vector2(0.0, 38.0))
	return true

func _mine_fallen_wall_chunk(chunk: Sprite2D, amount: float) -> void:
	if not is_instance_valid(chunk) or amount <= 0.0:
		return
	var previous_hp := float(chunk.get_meta("hp", 0.0))
	var max_hp := maxf(1.0, float(chunk.get_meta("max_hp", WALL_CHUNK_HEALTH)))
	var damage := minf(amount, previous_hp)
	var hp := maxf(0.0, previous_hp - damage)
	var mass := float(chunk.get_meta("mass", WALL_CHUNK_MASS))
	var max_mass := maxf(0.001, float(chunk.get_meta("max_mass", WALL_CHUNK_MASS)))
	var released := mass if hp <= 0.0 else minf(mass, max_mass * damage / max_hp)
	var side: String = chunk.get_meta("side", "right")
	chunk.set_meta("hp", hp)
	chunk.set_meta("mass", maxf(0.0, mass - released))
	var column := roundi((chunk.position.x - _pile_center(side)) / GRAIN_SPACING)
	if released > 0.0:
		_spawn_chunk(chunk.position - Vector2(0.0, 34.0), released, side, column)
	var crack := chunk.get_node_or_null("Crack") as Line2D
	if crack:
		crack.visible = true
		crack.modulate.a = 0.25 + (1.0 - hp / max_hp) * 0.75
	var bump := create_tween()
	bump.tween_property(chunk, "rotation", chunk.rotation + randf_range(-0.08, 0.08), 0.05)
	bump.tween_property(chunk, "rotation", 0.0, 0.09)
	if hp > 0.0:
		return
	fallen_wall_chunks.erase(chunk)
	chunk.set_meta("landed", false)
	_float_text("¡BLOQUE DESHECHO!", chunk.position - Vector2(0.0, 58.0))
	var collapse := create_tween().set_parallel()
	collapse.tween_property(chunk, "scale", Vector2.ZERO, 0.24).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	collapse.tween_property(chunk, "rotation", chunk.rotation + randf_range(-0.55, 0.55), 0.24)
	collapse.chain().tween_callback(chunk.queue_free)

func _manual_collect_at(world_pos: Vector2) -> bool:
	var piece := _surface_piece_at(world_pos)
	if not piece:
		return false
	if box_jammed:
		_float_text("LA CAJA ESTÁ ATASCADA", world_pos)
		return true
	var kind: String = piece.get_meta("kind", "grain")
	if kind == "rock":
		_float_text("DEMASIADO APELMAZADA", world_pos)
		return true
	if kind == "bacteria":
		_float_text("ESO SE MUEVE", world_pos)
		return true
	var side: String = piece.get_meta("side", "right")
	piece.set_meta("carried", true)
	piece.set_meta("manual_flying", true)
	piece.z_index = 30
	_settle_surface(side, 3)
	_restack_pile(side)
	var start := piece.position
	var target := Vector2(_box_x() + 8.0, _ground_y() - 24.0)
	var control := (start + target) * 0.5 - Vector2(0.0, 85.0 + absf(target.x - start.x) * 0.08)
	var duration := MANUAL_DELIVERY_BASE_TIME + minf(0.28, start.distance_to(target) / 1500.0)
	var tween := create_tween()
	tween.tween_method(_animate_manual_flight.bind(piece, start, control, target), 0.0, 1.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(_finish_manual_delivery.bind(piece))
	return true

func _animate_manual_flight(progress: float, piece: Variant, start: Vector2, control: Vector2, target: Vector2) -> void:
	if not is_instance_valid(piece):
		return
	var sprite := piece as Sprite2D
	if not sprite:
		return
	var inverse := 1.0 - progress
	sprite.position = start * inverse * inverse + control * 2.0 * inverse * progress + target * progress * progress
	sprite.rotation += 0.055
	var base_scale := float(sprite.get_meta("base_scale", 0.07))
	var flight_pop := 1.0 + sin(progress * PI) * 0.42 - progress * 0.24
	sprite.scale = Vector2.ONE * base_scale * flight_pop

func _finish_manual_delivery(piece: Variant) -> void:
	if not is_instance_valid(piece):
		return
	var sprite := piece as Sprite2D
	if not sprite:
		return
	var kind: String = sprite.get_meta("kind", "grain")
	var value := float(sprite.get_meta("value", 1.0))
	var previous_contamination := contamination
	var delivered := 0.0
	if kind == "impurity":
		impurities_handled += 1
		contamination = clampf(contamination + _impurity_contamination(str(sprite.get_meta("material", ""))), 0.0, 100.0)
		_float_text("LA CAJA SE ENSUCIA", Vector2(_box_x(), _ground_y() - 22.0))
	else:
		delivered = value * _box_yield_multiplier()
		cells += delivered
		phase_work += value
		_improve_joe(value)
		_float_text("+%s" % _number(delivered), Vector2(_box_x(), _ground_y() - 22.0))
	loose_chunks.erase(sprite)
	sprite.queue_free()
	_update_contamination_warning(previous_contamination)
	_update_box()
	_box_bump()
	_check_phase_progress()
	_update_ui()

func _cargo_position(pawn: Sprite2D, index: int, capacity: int) -> Vector2:
	var columns := mini(3, capacity)
	var row := index / columns
	var column := index % columns
	return pawn.position + Vector2((float(column) - float(columns - 1) * 0.5) * 6.0, -14.0 - float(row) * 5.0)

func _update_carried_pieces(pawn: Sprite2D) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	for index in range(cargo.size()):
		var piece := cargo[index] as Sprite2D
		if is_instance_valid(piece): piece.position = _cargo_position(pawn, index, _transport_capacity())

func _begin_deposit(pawn: Sprite2D) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	for piece_value in cargo:
		var piece := piece_value as Sprite2D
		if is_instance_valid(piece): piece.set_meta("deposit_start", piece.position)
	pawn.set_meta("state", "deposit")
	pawn.set_meta("timer", 0.0)

func _update_deposit(pawn: Sprite2D, progress: float) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	var target := Vector2(_box_x() + 8.0, _ground_y() - 24.0)
	for index in range(cargo.size()):
		var piece := cargo[index] as Sprite2D
		if not is_instance_valid(piece): continue
		var start: Vector2 = piece.get_meta("deposit_start", piece.position)
		var delayed := clampf(progress * 1.35 - float(index) * 0.08, 0.0, 1.0)
		piece.position = start.lerp(target, smoothstep(0.0, 1.0, delayed))
		var base_scale: float = float(piece.get_meta("base_scale", 0.07))
		piece.scale = Vector2.ONE * lerpf(base_scale, 0.015, delayed)

func _finish_delivery(pawn: Sprite2D) -> void:
	var delivered := 0.0
	var contamination_delta := 0.0
	var previous_contamination := contamination
	var cargo: Array = pawn.get_meta("cargo", [])
	for piece_value in cargo:
		var piece := piece_value as Sprite2D
		if not is_instance_valid(piece): continue
		var value := float(piece.get_meta("value", 0.0))
		var kind: String = piece.get_meta("kind", "grain")
		if kind == "impurity":
			impurities_handled += 1
			if bool(pawn.get_meta("detector", false)):
				delivered += value * 0.15 * float(levels.detector)
				phase_work += 1.25 * float(levels.detector)
				contamination_delta -= 0.45 + float(levels.detector) * 0.15
				impurities_cleaned += 1
			else:
				contamination_delta += _impurity_contamination(str(piece.get_meta("material", "")))
		elif kind == "bacteria":
			if bool(pawn.get_meta("handler", false)):
				delivered += value
				bacteria_handled += 1
				infection = maxf(0.0, infection - 3.5)
				_change_joe_health(0.18)
				phase_work += 2.5
			else:
				piece.set_meta("carried", false)
				piece.visible = true
				piece.scale = Vector2.ONE * float(piece.get_meta("base_scale", 0.08))
				piece.position = _landing_position(piece)
				continue
		else:
			delivered += value * _box_yield_multiplier()
			phase_work += value
			_improve_joe(value)
		loose_chunks.erase(piece)
		piece.queue_free()
	contamination = clampf(contamination + contamination_delta, 0.0, 100.0)
	cells += delivered
	if contamination_delta > 0.0:
		_float_text("LA CAJA SE ENSUCIA", pawn.position - Vector2(0.0, 22.0))
	elif contamination_delta < 0.0:
		_float_text("LIMPIANDO", pawn.position - Vector2(0.0, 22.0))
	elif delivered > 0.0:
		_float_text("+%s" % _number(delivered), pawn.position - Vector2(0.0, 22.0))
	_update_contamination_warning(previous_contamination)
	pawn.set_meta("cargo", [])
	pawn.set_meta("state", "to_pile")
	pawn.set_meta("side", _choose_work_side(int(pawn.get_meta("index", 0))))
	_set_pawn_carrying(pawn, false)
	_restack_pile()
	_update_box()
	_box_bump()
	_check_phase_progress()

func _impurity_contamination(material: String) -> float:
	if material == "yeso": return 0.85
	if material == "serrín": return 0.55
	return 0.70

func _update_contamination_warning(previous: float) -> void:
	var previous_band := int(previous / 25.0)
	contamination_band = int(contamination / 25.0)
	if contamination_band <= previous_band:
		return
	if contamination_band >= 4:
		_show_toast("LA CAJA ESTÁ HECHA UN ASCO")
	elif contamination_band == 3:
		_show_toast("ESO NO PARECE COCAÍNA")
	elif contamination_band == 2:
		_show_toast("LA CAJA HACE UN RUIDO MUY RARO")
	else:
		_show_toast("LA CAJA EMPIEZA A ESTAR PEGAJOSA")

func _top_untreated_rock(side: String) -> Sprite2D:
	for piece in _top_pieces(side):
		if piece.get_meta("kind", "grain") == "rock" and int(piece.get_meta("hardness", 0)) > 0: return piece
	return null

func _chip_rock(rock: Sprite2D) -> void:
	if not is_instance_valid(rock): return
	var previous_hardness := int(rock.get_meta("hardness", 0))
	var hardness := maxi(0, previous_hardness - 1)
	rock.set_meta("hardness", hardness)
	if previous_hardness > 0 and hardness == 0:
		rocks_opened += 1
	var crack := rock.get_node_or_null("Crack") as Line2D
	if crack:
		crack.visible = true
		crack.modulate.a = 1.0 - float(hardness) / maxf(1.0, float(rock.get_meta("max_hardness", 1)))
	var tween := create_tween()
	tween.tween_property(rock, "rotation", rock.rotation + 0.12, 0.06)
	tween.tween_property(rock, "rotation", rock.rotation - 0.10, 0.06)
	tween.tween_property(rock, "rotation", 0.0, 0.08)
	_float_text("CRACK" if hardness > 0 else "LISTO", rock.position - Vector2(0.0, 18.0))
	if hardness == 0: rock.modulate = Color("eef4e7")

func _maybe_compact(side: String) -> void:
	if current_phase < 2: return
	if int(levels.breaker) == 0 and _rock_count(side) >= 6: return
	if _pile_load(side) < COMPACTION_THRESHOLD or int(compaction_steps.get(side, 0)) < COMPACTION_INTERVAL: return
	var grains := _dense_grain_cluster(side)
	if grains.size() < COMPACTION_GRAINS: return
	var value := 0.0
	for grain in grains:
		value += float(grain.get_meta("value", 1.0))
		loose_chunks.erase(grain)
		grain.queue_free()
	compaction_steps[side] = 0
	_restack_pile(side)
	var hardness := clampi(2 + int(_pile_load(side) / 180.0), 2, 4)
	var rock := _create_piece("rock", side, value, hardness, _choose_landing_column(side), randf_range(0.17, 0.205))
	rock.rotation = randf_range(-0.18, 0.18)
	rock.scale = Vector2.ZERO
	create_tween().tween_property(rock, "scale", Vector2.ONE * float(rock.get_meta("base_scale", 0.18)), 0.24).set_trans(Tween.TRANS_BACK)
	if not compaction_announced:
		compaction_announced = true
		_show_toast("EL POLVO SE APELMAZA  ·  HACEN FALTA ESPECIALISTAS")

func _dense_grain_cluster(side: String) -> Array[Sprite2D]:
	var grains: Array[Sprite2D] = []
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side) and bool(piece.get_meta("landed", false)) and piece.get_meta("kind", "grain") == "grain":
			grains.append(piece)
	for center in grains:
		var neighbours: Array[Sprite2D] = []
		for candidate in grains:
			if candidate != center and center.position.distance_to(candidate.position) <= 22.0:
				neighbours.append(candidate)
		if neighbours.size() >= COMPACTION_GRAINS - 1:
			neighbours.sort_custom(func(a: Sprite2D, b: Sprite2D) -> bool: return center.position.distance_squared_to(a.position) < center.position.distance_squared_to(b.position))
			var cluster: Array[Sprite2D] = [center]
			cluster.append_array(neighbours.slice(0, COMPACTION_GRAINS - 1))
			return cluster
	return []

func _pile_load(side: String) -> float:
	var total := 0.0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side): total += float(piece.get_meta("value", 1.0))
	return total

func _untreated_rock_count(side: String) -> int:
	var count := 0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side) and piece.get_meta("kind", "grain") == "rock" and int(piece.get_meta("hardness", 0)) > 0: count += 1
	return count

func _rock_count(side: String) -> int:
	var count := 0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece, side) and piece.get_meta("kind", "grain") == "rock": count += 1
	return count

func _click_wall(side: String) -> void:
	if (side == "left" and not septum_open) or _wall_hp(side) <= 0.0: return
	active_side = side
	for node in punchers.get_children():
		node.set_meta("side", side)
		_place_puncher(node as Sprite2D)
	total_clicks += 1
	var hit := minf(_click_power(), _wall_hp(side))
	_damage_wall(hit, side)
	_spawn_chunk(Vector2(_mine_x(side), _ground_y() - randf_range(160.0, 310.0)), hit, side)
	_float_text("-%s" % _number(hit), Vector2(_mine_x(side), _ground_y() - 280.0))
	if int(levels.click_burst) > 0 and _wall_hp(side) > 0.0:
		manual_clicks_since_burst += 1
		var threshold := maxi(6, 10 - int(levels.click_rhythm))
		if manual_clicks_since_burst >= threshold:
			manual_clicks_since_burst = 0
			var burst := mini(int(levels.click_burst) * 3, ceili(_wall_hp(side)))
			_damage_wall(float(burst), side)
			for grain in range(burst):
				_spawn_chunk(Vector2(_mine_x(side) + randf_range(-18.0, 18.0), _ground_y() - randf_range(190.0, 330.0)), 1.0, side)
			_float_text("¡RÁFAGA!  +%d" % burst, Vector2(_mine_x(side), _ground_y() - 245.0))

func _damage_wall(amount: float, side: String = active_side) -> void:
	if side == "left":
		if left_hp <= 0.0: return
		var previous_ratio := clampf(left_hp / left_max, 0.0, 1.0)
		left_hp = maxf(0.0, left_hp - amount)
		_update_world()
		left_hp = maxf(0.0, left_hp - _wall_damage_feedback(side, previous_ratio, clampf(left_hp / left_max, 0.0, 1.0), left_hp))
		if left_hp <= 0.0 and left_cleared == 0:
			left_cleared = 1
			_change_joe_health(3.0, true)
			_show_toast("PARED IZQUIERDA AGOTADA")
	else:
		if right_hp <= 0.0: return
		var previous_ratio := clampf(right_hp / right_max, 0.0, 1.0)
		right_hp = maxf(0.0, right_hp - amount)
		_update_world()
		right_hp = maxf(0.0, right_hp - _wall_damage_feedback(side, previous_ratio, clampf(right_hp / right_max, 0.0, 1.0), right_hp))
		if right_hp <= 0.0 and right_cleared == 0:
			right_cleared = 1
			_change_joe_health(3.0, true)
			_show_toast("PARED DERECHA AGOTADA")
	_update_world()

func _wall_damage_feedback(side: String, previous_ratio: float, current_ratio: float, available_mass := INF) -> float:
	var previous_step := floori((1.0 - previous_ratio) * 100.0 + 0.001)
	var current_step := floori((1.0 - current_ratio) * 100.0 + 0.001)
	var crossed := current_step - previous_step
	if crossed <= 0:
		return 0.0
	_spawn_wall_chips(side, mini(4, crossed))
	var previous_major := mini(9, floori(float(previous_step) / 10.0))
	var current_major := mini(9, floori(float(current_step) / 10.0))
	var reserved := 0.0
	for fracture_number in range(previous_major + 1, current_major + 1):
		var stored := minf(WALL_CHUNK_MASS, maxf(0.0, available_mass - reserved))
		if stored >= 1.0 and _spawn_fallen_wall_chunk(side, fracture_number, stored):
			reserved += stored
	return reserved

func _spawn_wall_chips(side: String, milestones: int) -> void:
	var free_x := _wall_free_x(side)
	var direction := -1.0 if side == "left" else 1.0
	for milestone in range(milestones):
		for index in range(3):
			var chip := Sprite2D.new()
			chip.texture = GRAIN_TEXTURE
			chip.scale = Vector2.ONE * randf_range(0.018, 0.032)
			chip.modulate = Color("e8edf0")
			chip.z_index = 40
			chip.position = Vector2(free_x, randf_range(_ground_y() - 330.0, _ground_y() - 24.0))
			effects.add_child(chip)
			var target := chip.position + Vector2(direction * randf_range(28.0, 72.0), randf_range(48.0, 105.0))
			var tween := create_tween().set_parallel()
			tween.tween_property(chip, "position", target, randf_range(0.42, 0.68)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
			tween.tween_property(chip, "rotation", chip.rotation + direction * randf_range(1.4, 3.4), 0.56)
			tween.tween_property(chip, "modulate:a", 0.0, 0.62).set_delay(0.18)
			tween.chain().tween_callback(chip.queue_free)

func _fracture_center(fracture_number: int) -> float:
	return 0.25 + fmod(float(fracture_number - 1) * 0.337, 0.52)

func _next_fallen_wall_chunk_slot(side: String) -> int:
	var used := {}
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk) and chunk.get_meta("side", "right") == side:
			used[int(chunk.get_meta("slot", 0))] = true
	for slot in range(MAX_FALLEN_WALL_CHUNKS):
		if not used.has(slot):
			return slot
	return -1

func _wall_chunk_texture(variant: int) -> AtlasTexture:
	var texture := AtlasTexture.new()
	texture.atlas = WALL_CHUNK_SHEET
	texture.region = Rect2(variant * WALL_CHUNK_CELL, 0, WALL_CHUNK_CELL, WALL_CHUNK_CELL)
	return texture

func _spawn_fallen_wall_chunk(side: String, fracture_number: int, stored_mass: float, animate := true, preferred_slot := -1) -> bool:
	var slot := preferred_slot if preferred_slot >= 0 else _next_fallen_wall_chunk_slot(side)
	if slot < 0 or slot >= MAX_FALLEN_WALL_CHUNKS:
		return false
	var variant := posmod(fracture_number - 1, 4)
	var chunk := Sprite2D.new()
	chunk.texture = _wall_chunk_texture(variant)
	chunk.scale = Vector2.ONE * WALL_CHUNK_SCALE
	chunk.flip_h = side == "left"
	chunk.z_index = slot
	chunk.set_meta("side", side)
	chunk.set_meta("variant", variant)
	chunk.set_meta("fracture_number", fracture_number)
	chunk.set_meta("slot", slot)
	chunk.set_meta("hp", WALL_CHUNK_HEALTH)
	chunk.set_meta("max_hp", WALL_CHUNK_HEALTH)
	chunk.set_meta("mass", stored_mass)
	chunk.set_meta("max_mass", stored_mass)
	chunk.set_meta("landed", not animate)
	var crack := Line2D.new()
	crack.name = "Crack"
	crack.points = PackedVector2Array([Vector2(-92, -128), Vector2(-20, -54), Vector2(-66, 12), Vector2(46, 94)])
	crack.width = 11.0
	crack.default_color = Color(0.31, 0.26, 0.39, 0.88)
	crack.visible = false
	chunk.add_child(crack)
	wall_chunks_layer.add_child(chunk)
	fallen_wall_chunks.append(chunk)
	var landing := Vector2(_pile_center(side) + 78.0 + float(slot) * 64.0, _ground_y() - 27.0)
	if not animate:
		chunk.position = landing
		return true
	chunk.position = Vector2(_wall_free_x(side), _ground_y() - 360.0 + _fracture_center(fracture_number) * 360.0)
	chunk.rotation = randf_range(-0.18, 0.18)
	var fall := create_tween().set_parallel()
	fall.tween_property(chunk, "position", landing, 0.82).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fall.tween_property(chunk, "rotation", randf_range(-0.38, 0.38), 0.82)
	fall.chain().tween_callback(_land_fallen_wall_chunk.bind(chunk))
	_show_toast("¡PASO BLOQUEADO!  ·  PICA EL BLOQUE A MANO")
	return true

func _land_fallen_wall_chunk(chunk: Variant) -> void:
	if not is_instance_valid(chunk):
		return
	var sprite := chunk as Sprite2D
	sprite.position.y = _ground_y() - 27.0
	sprite.rotation = 0.0
	sprite.set_meta("landed", true)
	var impact := create_tween()
	impact.tween_property(sprite, "scale", Vector2(WALL_CHUNK_SCALE * 1.1, WALL_CHUNK_SCALE * 0.9), 0.06)
	impact.tween_property(sprite, "scale", Vector2.ONE * WALL_CHUNK_SCALE, 0.11).set_trans(Tween.TRANS_BACK)

func _open_septum() -> void:
	if septum_open or right_hp / right_max > TUNNEL_UNLOCK_RATIO: return
	septum_open = true
	active_side = "left"
	camera_goal = maxf(0.0, SEPTUM_X - _visible_world_width() * 0.72)
	_update_world()
	_rebuild_pawns()
	_rebuild_punchers()
	_update_ui()
	_show_toast("TUNELADORA DE NARICES  ·  SEGUNDA FOSA ABIERTA")
	_save()

func _update_world() -> void:
	septum_gate.visible = not septum_open
	septum_hole.visible = septum_open
	left_button.disabled = not septum_open or left_hp <= 0.0
	right_button.disabled = right_hp <= 0.0
	left_visual.modulate = Color.WHITE if septum_open else Color(0.42, 0.42, 0.48)
	left_caption.text = "FOSA IZQUIERDA" if septum_open else "FOSA IZQUIERDA  ·  BLOQUEADA"
	break_button.visible = not septum_open and right_hp / right_max <= TUNNEL_UNLOCK_RATIO
	break_button.text = "TUNELADORA DE NARICES\nABRIR PASO A LA SEGUNDA FOSA"
	right_visual.pivot_offset = Vector2(0.0, right_visual.size.y)
	left_visual.pivot_offset = Vector2(left_visual.size.x, left_visual.size.y)
	var right_ratio := clampf(right_hp / right_max, 0.0, 1.0)
	var left_ratio := clampf(left_hp / left_max, 0.0, 1.0)
	right_visual.scale.x = 0.0 if right_ratio <= 0.0 else maxf(0.05, right_ratio)
	left_visual.scale.x = 0.0 if left_ratio <= 0.0 else maxf(0.05, left_ratio)
	(right_visual.material as ShaderMaterial).set_shader_parameter("health_ratio", right_ratio)
	(left_visual.material as ShaderMaterial).set_shader_parameter("health_ratio", left_ratio)
	_update_box()

func _update_box() -> void:
	box.pivot_offset = Vector2(box.size.x * 0.5, box.size.y)
	var box_scale: float = 1.0 + float(levels.box) * 0.08
	box.scale = Vector2(box_scale, box_scale)
	box.modulate = Color("5e3428").lerp(Color("8c5130"), sin(Time.get_ticks_msec() * 0.012) * 0.5 + 0.5) if box_jammed else Color.WHITE.lerp(Color("ad7f43"), contamination / 100.0)
	box.rotation = sin(Time.get_ticks_msec() * 0.025) * 0.012 if box_jammed else 0.0

func _rebuild_pawns() -> void:
	for child in pawns.get_children(): child.queue_free()
	for piece in loose_chunks:
		if is_instance_valid(piece) and bool(piece.get_meta("carried", false)):
			piece.set_meta("carried", false)
			piece.visible = true
			piece.position = _landing_position(piece)
			piece.scale = Vector2.ONE * float(piece.get_meta("base_scale", 0.07))
	_restack_pile()
	var count: int = mini(2 + int(levels.pawn), 18)
	var handler_count := mini(int(levels.handlers), count)
	var detector_count := mini(int(levels.detector), count - handler_count)
	for index in range(count):
		var pawn := Sprite2D.new()
		pawn.scale = Vector2(0.047, 0.047)
		pawn.z_index = index % 3
		pawn.set_meta("index", index)
		pawn.set_meta("lane_x", float(index % 5 - 2) * 7.0)
		var specialist_stride := maxi(1, 4 - int(levels.breaker))
		var handler := handler_count > 0 and index >= count - handler_count
		var detector := not handler and detector_count > 0 and index >= count - handler_count - detector_count
		var specialist := not handler and not detector and int(levels.breaker) > 0 and index % specialist_stride == 0
		pawn.set_meta("handler", handler)
		pawn.set_meta("detector", detector)
		pawn.set_meta("specialist", specialist)
		pawn.modulate = Color.WHITE
		_set_pawn_carrying(pawn, false)
		pawn.set_meta("state", "to_pile")
		pawn.set_meta("cargo", [])
		pawn.set_meta("side", _choose_work_side(index))
		pawn.position = Vector2(_box_x() - float(index) * 18.0, _ground_y() - 14.0)
		pawns.add_child(pawn)

func _rebuild_punchers() -> void:
	for child in punchers.get_children():
		child.queue_free()
	for index in range(mini(8, int(levels.puncher))):
		var puncher := Sprite2D.new()
		puncher.texture = PAWN_EMPTY
		puncher.scale = Vector2.ONE * 0.047
		puncher.offset = Vector2(0.0, PAWN_FOOT_DEPTH / puncher.scale.y - PAWN_EMPTY.get_height() * 0.5)
		puncher.z_index = index % 2
		puncher.set_meta("index", index)
		puncher.set_meta("side", active_side)
		puncher.set_meta("state", "idle")
		puncher.set_meta("timer", 0.0)
		puncher.set_meta("debut", false)
		var glove := Polygon2D.new()
		glove.name = "BoxingGlove"
		glove.polygon = PackedVector2Array([Vector2(-270, 30), Vector2(-225, 15), Vector2(-181, 37), Vector2(-166, 75), Vector2(-190, 118), Vector2(-240, 120), Vector2(-274, 82)])
		glove.color = Color("f05261")
		glove.z_index = 2
		puncher.add_child(glove)
		var headband := Polygon2D.new()
		headband.name = "AutoHeadband"
		headband.polygon = PackedVector2Array([Vector2(-150, -218), Vector2(136, -218), Vector2(158, -180), Vector2(-164, -180)])
		headband.color = Color("51c8e8")
		headband.z_index = 2
		puncher.add_child(headband)
		punchers.add_child(puncher)
		_place_puncher(puncher)

func _place_puncher(puncher: Sprite2D) -> void:
	var side: String = puncher.get_meta("side", active_side)
	puncher.flip_h = side == "left"
	var glove := puncher.get_node_or_null("BoxingGlove") as Polygon2D
	if glove:
		glove.scale.x = -1.0 if side == "left" else 1.0
	puncher.position = _puncher_home_position(puncher)
	puncher.rotation = 0.0
	puncher.set_meta("state", "idle")

func _wall_free_x(side: String) -> float:
	var visual := left_visual if side == "left" else right_visual
	var button := left_button if side == "left" else right_button
	return button.position.x + (visual.size.x * (1.0 - visual.scale.x) if side == "left" else visual.size.x * visual.scale.x)

func _pile_outer_x(side: String) -> float:
	var outer_column := -2 if side == "left" else 2
	for piece in loose_chunks:
		if not _piece_is_in_pile(piece, side):
			continue
		var column := int(piece.get_meta("column", 0))
		outer_column = mini(outer_column, column) if side == "left" else maxi(outer_column, column)
	var direction := -1.0 if side == "left" else 1.0
	return _pile_center(side) + float(outer_column) * GRAIN_SPACING + direction * 22.0

func _puncher_home_position(puncher: Sprite2D) -> Vector2:
	var index := int(puncher.get_meta("index", 0))
	var side: String = puncher.get_meta("side", active_side)
	var direction := -1.0 if side == "left" else 1.0
	return Vector2(_pile_outer_x(side) + direction * (30.0 + float(index) * 19.0), _ground_y() - 14.0)

func _puncher_strike_position(puncher: Sprite2D) -> Vector2:
	var side: String = puncher.get_meta("side", active_side)
	var direction := -1.0 if side == "left" else 1.0
	return Vector2(_wall_free_x(side) + direction * 14.0, _ground_y() - 14.0)

func _punch_interval() -> float:
	return PUNCH_BASE_INTERVAL * pow(0.84, int(levels.punch_speed))

func _punch_output() -> int:
	return 1 + int(levels.punch_power)

func _auto_hit_rate() -> float:
	if int(levels.puncher) == 0 or box_jammed or _nearest_fallen_wall_chunk(active_side):
		return 0.0
	return float(levels.puncher) * float(_punch_output()) / _punch_interval()

func _update_punchers(delta: float) -> void:
	if int(levels.puncher) == 0 or box_jammed or _nearest_fallen_wall_chunk(active_side):
		return
	if puncher_debut_pending:
		puncher_debut_clock -= delta
		for node in punchers.get_children():
			var warmup := node as Sprite2D
			if warmup:
				warmup.rotation = sin(Time.get_ticks_msec() * 0.028) * 0.04
		if puncher_debut_clock <= 0.0:
			puncher_debut_pending = false
			_perform_punch_round(true)
			punch_clock = _punch_interval()
		return
	_update_puncher_motion(delta)
	punch_clock -= delta
	if punch_clock > 0.0 or not _punchers_idle():
		return
	punch_clock = _punch_interval()
	_perform_punch_round(false)

func _perform_punch_round(debut: bool) -> void:
	for node in punchers.get_children():
		var puncher := node as Sprite2D
		if not puncher:
			continue
		var side: String = puncher.get_meta("side", active_side)
		if side != active_side and not septum_open:
			side = active_side
			puncher.set_meta("side", side)
			_place_puncher(puncher)
		puncher.set_meta("debut", debut and int(puncher.get_meta("index", 0)) == 0)
		puncher.set_meta("state", "to_wall")

func _punchers_idle() -> bool:
	for node in punchers.get_children():
		if node.get_meta("state", "idle") != "idle":
			return false
	return true

func _update_puncher_motion(delta: float) -> void:
	for node in punchers.get_children():
		var puncher := node as Sprite2D
		if not puncher:
			continue
		var state: String = puncher.get_meta("state", "idle")
		var speed := PUNCHER_WALK_SPEED * (1.0 + float(levels.punch_speed) * 0.1)
		puncher.position.y = _ground_y() - 14.0
		if state == "idle":
			puncher.position = puncher.position.move_toward(_puncher_home_position(puncher), speed * delta)
			puncher.rotation = move_toward(puncher.rotation, 0.0, delta * 0.8)
		elif state == "to_wall":
			var strike := _puncher_strike_position(puncher)
			puncher.position = puncher.position.move_toward(strike, speed * delta)
			if puncher.position.distance_to(strike) < 0.5:
				puncher.position = strike
				puncher.set_meta("state", "striking")
				puncher.set_meta("timer", PUNCHER_STRIKE_TIME)
				_resolve_punch(puncher)
		elif state == "striking":
			var timer := float(puncher.get_meta("timer", 0.0)) - delta
			puncher.set_meta("timer", timer)
			var direction := -1.0 if puncher.get_meta("side", "right") == "left" else 1.0
			puncher.rotation = -direction * sin(clampf(timer / PUNCHER_STRIKE_TIME, 0.0, 1.0) * PI) * 0.11
			if timer <= 0.0:
				puncher.rotation = 0.0
				puncher.set_meta("state", "returning")
		elif state == "returning":
			var home := _puncher_home_position(puncher)
			puncher.position = puncher.position.move_toward(home, speed * delta)
			if puncher.position.distance_to(home) < 0.5:
				puncher.position = home
				puncher.set_meta("state", "idle")

func _resolve_punch(puncher: Sprite2D) -> void:
	var side: String = puncher.get_meta("side", active_side)
	if _wall_hp(side) <= 0.0:
		return
	var debut := bool(puncher.get_meta("debut", false))
	var output := mini(12 if debut else _punch_output(), ceili(_wall_hp(side)))
	_damage_wall(float(output), side)
	total_clicks += output
	var direction := -1.0 if side == "left" else 1.0
	var impact_x := _wall_free_x(side) + direction * 4.0
	for grain in range(output):
		_spawn_chunk(Vector2(impact_x + randf_range(-7.0, 7.0), _ground_y() - randf_range(185.0, 300.0)), 1.0, side)
	_float_text("¡¡PUM!!  +%d" % output if debut else "¡PUM!  +%d" % output, Vector2(impact_x, _ground_y() - 95.0))
	if debut:
		_show_toast("DEBUT DEL PÚGIL  ·  ESO SÍ HA SIDO UN PUÑETAZO")
	puncher.set_meta("debut", false)
	_update_world()

func _click_power() -> float:
	return 1.0 + float(levels.nails)

func _rate() -> float:
	if box_jammed:
		return 0.0
	var distance := absf(_box_x() - _pile_center(active_side))
	var cycle := distance * 2.0 / maxf(1.0, _pawn_speed()) + 0.8 + _deposit_duration()
	return float(2 + int(levels.pawn)) * float(_transport_capacity()) / cycle * _box_yield_multiplier()

func _buy(id: String) -> void:
	var upgrade := _upgrade(id)
	var level: int = int(levels[id])
	var cost: float = ceil(float(upgrade.base) * pow(float(upgrade.growth), level))
	if cells < cost or level >= int(upgrade.get("max", 999)): return
	cells -= cost
	levels[id] = level + 1
	if upgrade.kind in ["pawn", "speed", "coordination", "specialist", "detector", "handler"]: _rebuild_pawns()
	elif upgrade.kind == "autoclicker":
		_rebuild_punchers()
		if level == 0:
			puncher_debut_pending = true
			puncher_debut_clock = 1.35
			punch_clock = _punch_interval()
			_show_toast("EL NUEVO PÚGIL ESTÁ CALENTANDO EL BRAZO...")
	elif upgrade.kind == "capacity": _update_box()
	elif upgrade.kind == "platelet": _rebuild_platelets()
	_update_ui()
	_check_phase_progress()
	_save()

func _phase() -> Dictionary:
	return PHASES[clampi(current_phase - 1, 0, PHASES.size() - 1)]

func _phase_target() -> float:
	return float(_phase().target)

func _debug_set_phase(next_phase: int) -> void:
	joe_dialog.hide()
	phase_event_pending = false
	playing = true
	current_phase = clampi(next_phase, 1, PHASES.size())
	phase_work = 0.0
	joe_health = clampf(JOE_STARTING_HEALTH + float(current_phase - 1) * 7.0, 0.0, 100.0)
	joe_health_display = joe_health
	contamination = 0.0 if current_phase < 3 else 42.0
	contamination_band = int(contamination / 25.0)
	box_jammed = false
	joe_clock = 0.0
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	another_line_clock = ANOTHER_LINE_INTERVAL
	another_line_wave = 0
	another_line_drop_clock = 0.0
	another_line_spawn_index = 0
	another_line_events = 0
	another_line_warned = false
	puncher_unlocked = current_phase >= 2 or int(levels.puncher) > 0
	puncher_debut_pending = false
	puncher_debut_clock = 0.0
	manual_clicks_since_burst = 0
	rocks_opened = 0
	impurities_cleaned = 0
	tissue_repaired = 0.0
	compaction_steps = {"left":0, "right":0}
	if current_phase < 2:
		compaction_announced = false
	tissue_damage = 0.0 if current_phase < 4 else (34.0 if current_phase == 4 else 48.0)
	infection = 38.0 if current_phase >= 5 else 0.0
	_rebuild_pawns()
	_rebuild_punchers()
	_remove_future_crisis_pieces()
	_rebuild_platelets()
	_update_world()
	_update_crisis_visuals()
	_update_pressure_visuals()
	_update_ui()
	call_deferred("_focus_required_upgrade")
	_show_toast("MODO PRUEBA  ·  FASE %d REINICIADA" % current_phase)
	_save()

func _remove_future_crisis_pieces() -> void:
	for piece in loose_chunks.duplicate():
		if not is_instance_valid(piece): continue
		var kind: String = piece.get_meta("kind", "grain")
		var remove := (current_phase < 2 and kind == "rock") or (current_phase < 3 and kind == "impurity") or (current_phase < 5 and kind == "bacteria")
		if remove:
			loose_chunks.erase(piece)
			piece.queue_free()
	_restack_pile()

func _restack_pile(side_filter: String = "") -> void:
	var columns := {}
	for piece in loose_chunks:
		if not is_instance_valid(piece) or bool(piece.get_meta("carried", false)) or not bool(piece.get_meta("landed", false)): continue
		var side: String = piece.get_meta("side", "right")
		if not side_filter.is_empty() and side != side_filter: continue
		var column := _constrain_column(side, int(piece.get_meta("column", 0)))
		piece.set_meta("column", column)
		var key := "%s:%d" % [side, column]
		if not columns.has(key): columns[key] = []
		(columns[key] as Array).append(piece)
	for stack_value in columns.values():
		var stack: Array = stack_value
		stack.sort_custom(func(a: Sprite2D, b: Sprite2D) -> bool: return a.position.y > b.position.y)
		var accumulated := 0.0
		for piece_value in stack:
			var piece := piece_value as Sprite2D
			var height := float(piece.get_meta("height", GRAIN_HEIGHT))
			var side: String = piece.get_meta("side", "right")
			var column := int(piece.get_meta("column", 0))
			piece.position = Vector2(_pile_center(side) + float(column) * GRAIN_SPACING + float(piece.get_meta("x_jitter", 0.0)), _ground_y() - 5.0 - accumulated - height * 0.5)
			accumulated += height

func _update_another_line(delta: float) -> void:
	if another_line_wave > 0:
		another_line_clock = maxf(0.0, another_line_clock - delta)
		another_line_drop_clock -= delta
		if another_line_drop_clock <= 0.0:
			another_line_drop_clock = 0.18
			var batch := mini(5, another_line_wave)
			another_line_wave -= batch
			for grain in range(batch):
				var wave_total := 120 + current_phase * 20
				var projected_load := _pile_load(active_side) + float(another_line_wave)
				var previous_load := maxf(0.0, projected_load - float(wave_total))
				var reach := mini(MAX_PILE_RADIUS, 18 + current_phase * 2 + int(sqrt(previous_load / 12.0)))
				var bounds := _column_bounds(active_side, reach)
				var band_size := ceili(float(wave_total) / float(ANOTHER_LINE_ANCHORS.size()))
				var band := mini(ANOTHER_LINE_ANCHORS.size() - 1, int(another_line_spawn_index / band_size))
				var event_index := maxi(0, another_line_events - 1) % ANOTHER_LINE_SHIFTS.size()
				var anchor := clampf(float(ANOTHER_LINE_ANCHORS[band]) + float(ANOTHER_LINE_SHIFTS[event_index]), 0.05, 0.95)
				var center := roundi(lerpf(float(bounds.x), float(bounds.y), anchor))
				another_line_spawn_index += 1
				var rain_x := _pile_center(active_side) + float(center) * GRAIN_SPACING
				_spawn_chunk(Vector2(rain_x + randf_range(-7.0, 7.0), _ground_y() - randf_range(300.0, 430.0)), 1.0, active_side, center)
			if another_line_wave == 0:
				_finish_another_line()
		return
	another_line_clock -= delta
	if another_line_clock <= ANOTHER_LINE_WARNING and not another_line_warned:
		another_line_warned = true
		_show_toast("JOE ESTÁ PREPARANDO OTRA RAYITA...")
	if another_line_clock <= 0.0:
		another_line_clock = ANOTHER_LINE_INTERVAL
		another_line_warned = false
		another_line_wave = 120 + current_phase * 20
		another_line_drop_clock = 0.0
		another_line_spawn_index = 0
		another_line_events += 1
		_change_joe_health(-1.2 - float(current_phase) * 0.25, true)
		_show_toast("OTRA RAYITA  ·  JOE ACABA DE INUNDAR LA FOSA")

func _finish_another_line() -> void:
	if puncher_unlocked:
		return
	puncher_unlocked = true
	_update_ui()
	var button := buttons.get("puncher") as Button
	if button:
		_scroll_to_required_upgrade(button)
	_show_toast("NUEVA ADAPTACIÓN  ·  CÉLULA PÚGIL EN PRÁCTICAS")
	_save()

func _update_crisis(delta: float) -> void:
	if current_phase >= 2:
		joe_clock -= delta
		if joe_clock <= 0.0:
			joe_clock = float(JOE_DROP_INTERVALS[current_phase])
			var side := active_side
			var drops := mini(5, current_phase)
			for index in range(drops):
				var impurity_chance := maxf(0.08, 0.34 - float(levels.sorting) * 0.08)
				if current_phase >= 3 and randf() < impurity_chance:
					var materials := ["serrín", "yeso", "tiza"]
					_spawn_special_piece("impurity", side, materials[randi_range(0, materials.size() - 1)])
				else:
					_spawn_chunk(Vector2(_mine_x(side) + randf_range(-22.0, 22.0), _ground_y() - randf_range(220.0, 380.0)), 1.0, side)
	if current_phase >= 4:
		var bleed_rate := 0.72 + float(current_phase - 4) * 0.16
		var repair_rate := 0.0 if box_jammed else float(levels.platelets) * (0.42 + float(levels.repair) * 0.16) * (1.0 + float(levels.signals) * 0.1)
		tissue_repaired += maxf(0.0, repair_rate - bleed_rate) * delta
		tissue_damage = clampf(tissue_damage + (bleed_rate - repair_rate) * delta, 0.0, 100.0)
		phase_work += repair_rate * delta * 0.35
		blood_drop_clock -= delta
		if blood_drop_clock <= 0.0 and tissue_damage > 1.0:
			blood_drop_clock = lerpf(0.72, 0.2, tissue_damage / 100.0)
			_spawn_blood_drop()
	if current_phase >= 5:
		bacteria_clock -= delta
		if bacteria_clock <= 0.0:
			bacteria_clock = maxf(0.62, 1.8 - float(levels.signals) * 0.18)
			_spawn_special_piece("bacteria", active_side)
		var bacterial_load := float(_kind_count("bacteria"))
		var containment := 0.0 if box_jammed else float(levels.handlers) * (0.025 + float(levels.signals) * 0.022)
		infection = clampf(infection + (0.07 + bacterial_load * 0.008 - containment) * delta, 0.0, 100.0)
	_update_crisis_visuals()
	_check_phase_progress()

func _improve_joe(clean_units: float) -> void:
	_change_joe_health(clean_units * JOE_RECOVERY_PER_CLEAN_UNIT)

func _change_joe_health(amount: float, pulse: bool = false) -> void:
	joe_health = clampf(joe_health + amount, 0.0, 100.0)
	if not pulse or not is_instance_valid(joe_portrait):
		return
	joe_portrait.modulate = Color("8be2ae") if amount > 0.0 else Color("f06470")
	create_tween().tween_property(joe_portrait, "modulate", Color.WHITE, 0.48)

func _update_joe_prognosis(delta: float) -> void:
	var pile_burden := _pile_load("left") + _pile_load("right") + _fallen_wall_chunk_load()
	var pile_drain := clampf((pile_burden - 90.0) / 900.0, 0.0, 1.0) * 0.025
	var contamination_drain := contamination / 100.0 * 0.012 if current_phase >= 3 else 0.0
	var tissue_drain := tissue_damage / 100.0 * 0.018 if current_phase >= 4 else 0.0
	var infection_drain := infection / 100.0 * 0.022 if current_phase >= 5 else 0.0
	joe_health = clampf(joe_health - (pile_drain + contamination_drain + tissue_drain + infection_drain) * delta, 0.0, 100.0)
	joe_health_display = move_toward(joe_health_display, joe_health, delta * 9.0)

func _fallen_wall_chunk_load() -> float:
	var total := 0.0
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk):
			total += float(chunk.get_meta("hp", 0.0))
	return total

func _spawn_blood_drop() -> void:
	if blood_drops.get_child_count() >= 24:
		return
	var drop := Polygon2D.new()
	drop.polygon = PackedVector2Array([Vector2(0, -8), Vector2(-4, -1), Vector2(-3, 4), Vector2(0, 7), Vector2(3, 4), Vector2(4, -1)])
	drop.color = Color("cf3346")
	var scale_factor := randf_range(0.7, 1.25)
	drop.scale = Vector2.ONE * scale_factor
	var visible_width := _visible_world_width()
	drop.position = Vector2(camera_x + randf_range(55.0, maxf(56.0, visible_width - 55.0)), -12.0)
	blood_drops.add_child(drop)
	var duration := randf_range(1.15, 1.75)
	var tween := create_tween().set_parallel()
	tween.tween_property(drop, "position:y", _ground_y() - randf_range(2.0, 14.0), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(drop, "modulate:a", 0.45, duration)
	tween.chain().tween_callback(drop.queue_free)

func _kind_count(kind: String) -> int:
	var count := 0
	for piece in loose_chunks:
		if _piece_is_in_pile(piece) and piece.get_meta("kind", "grain") == kind:
			count += 1
	return count

func _check_phase_progress() -> void:
	if phase_event_pending or current_phase >= PHASES.size() or phase_work < _phase_target():
		return
	var adapted := true
	if current_phase == 1:
		adapted = puncher_unlocked and int(levels.puncher) > 0 and int(levels.pawn) + int(levels.shift) + int(levels.box) >= 3
	elif current_phase == 2:
		adapted = int(levels.breaker) > 0 and rocks_opened >= 6
	elif current_phase == 3:
		adapted = int(levels.detector) > 0 and contamination < 30.0 and impurities_cleaned >= 10
	elif current_phase == 4:
		adapted = int(levels.platelets) > 0 and tissue_damage < 45.0 and tissue_repaired >= 18.0
	if adapted:
		_advance_phase()

func _advance_phase() -> void:
	current_phase = mini(PHASES.size(), current_phase + 1)
	phase_work = 0.0
	joe_clock = 0.0
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	if current_phase == 2: rocks_opened = 0
	if current_phase == 3: impurities_cleaned = 0
	if current_phase == 4: tissue_repaired = 0.0
	if current_phase == 4: tissue_damage = maxf(tissue_damage, 28.0)
	if current_phase == 5: infection = maxf(infection, 24.0)
	phase_event_pending = true
	playing = false
	_rebuild_pawns()
	_rebuild_platelets()
	_update_world()
	_update_ui()
	call_deferred("_focus_required_upgrade")
	_show_phase_event()
	_save()

func _show_phase_event() -> void:
	if not phase_event_pending:
		return
	var phase := _phase()
	var required := _required_upgrade_id()
	var requirement := ""
	if not required.is_empty():
		requirement = "\n\nADAPTACIÓN OBLIGATORIA: %s\nLa hemos marcado con un halo azul en el laboratorio." % _upgrade(required).name
	joe_dialog.title = "FASE %d — %s" % [current_phase, phase.title]
	joe_dialog.dialog_text = "%s\n\n%s%s" % [phase.joe, phase.problem, requirement]
	joe_dialog.popup_centered(Vector2i(590, 260))

func _resume_after_joe() -> void:
	phase_event_pending = false
	playing = true
	_update_ui()
	_save()

func _rebuild_platelets() -> void:
	for child in platelets.get_children():
		child.queue_free()
	if current_phase < 4:
		return
	var count := mini(12, int(levels.platelets) * 2)
	for index in range(count):
		var platelet := Sprite2D.new()
		platelet.texture = PLATELET_TEXTURE
		platelet.scale = Vector2.ONE * 0.088
		platelet.z_index = index % 2
		platelet.set_meta("index", index)
		platelet.position = Vector2(SEPTUM_X + (-1.0 if index % 2 == 0 else 1.0) * (92.0 + float(index / 2) * 19.0), _ground_y() - 8.0)
		platelets.add_child(platelet)

func _update_platelets(_delta: float) -> void:
	if box_jammed:
		return
	var now := Time.get_ticks_msec() * 0.001
	for child in platelets.get_children():
		var platelet := child as Sprite2D
		if not platelet: continue
		var index := int(platelet.get_meta("index", 0))
		var side := -1.0 if index % 2 == 0 else 1.0
		var center := SEPTUM_X + side * (92.0 + float(index / 2) * 19.0)
		platelet.position.x = center + sin(now * (1.2 + float(index % 3) * 0.08) + index) * 18.0
		platelet.position.y = _ground_y() - 8.0
		platelet.rotation = sin(now * 1.6 + index) * 0.025

func _update_crisis_visuals() -> void:
	var bleeding := current_phase >= 4
	contamination_meter.visible = false
	contamination_progress.value = contamination
	contamination_label.text = "LECTURA INTERNA"
	contamination_progress.modulate = Color("91c787").lerp(Color("ef5b57"), contamination / 100.0)
	damage_meter.visible = bleeding
	damage_progress.value = tissue_damage
	damage_label.text = "DAÑO TISULAR  %d%%" % roundi(tissue_damage)
	blood_wash.modulate.a = (tissue_damage / 100.0) * 0.75 if bleeding else 0.0
	if not bleeding:
		for drop in blood_drops.get_children():
			drop.queue_free()
	_update_box()

func _update_pressure_visuals() -> void:
	var rocks := _untreated_rock_count("left") + _untreated_rock_count("right")
	if box_jammed:
		pressure_label.text = "LA CAJA NO TRAGA  ·  NADIE SE MUEVE"
		pressure_label.modulate = Color("ef5b57")
	elif current_phase >= 5:
		pressure_label.text = "INFECCIÓN %d%%  ·  BACTERIAS %d" % [roundi(infection), _kind_count("bacteria")]
		pressure_label.modulate = Color("a9d38c") if infection < 35.0 else Color("e9a1a0")
	elif current_phase >= 4:
		pressure_label.text = "HEMORRAGIA ACTIVA  ·  PLAQUETAS %d" % platelets.get_child_count()
		pressure_label.modulate = Color("82b9ad") if tissue_damage < 35.0 else Color("e9a1a0")
	elif current_phase >= 3:
		pressure_label.text = "JOE JURA QUE ERA PURA"
		pressure_label.modulate = Color("e8c694")
	elif rocks > 0:
		pressure_label.text = "ALGO SE HA PUESTO DURO"
		pressure_label.modulate = Color("e9a1a0")
	else:
		pressure_label.text = "JOE SIGUE RESPIRANDO"
		pressure_label.modulate = Color("82b9ad")

func _upgrade_available(upgrade: Dictionary) -> bool:
	var phase := int(upgrade.phase)
	if current_phase < phase:
		return false
	if bool(upgrade.get("requires_septum", false)) and not septum_open:
		return false
	if bool(upgrade.get("requires_puncher_unlock", false)) and not puncher_unlocked and current_phase == 1:
		return false
	var dependency := str(upgrade.get("requires_upgrade", ""))
	if not dependency.is_empty() and int(levels.get(dependency, 0)) == 0:
		return false
	if current_phase == phase and phase_work < float(upgrade.get("unlock_at", 0.0)) and int(levels[upgrade.id]) == 0:
		return false
	return true

func _update_ui() -> void:
	var phase := _phase()
	for phase_data in PHASES:
		var phase_id := int(phase_data.id)
		var phase_button := phase_debug_buttons[phase_id] as Button
		phase_button.text = "%sFASE %d\n%s" % ["▶ " if phase_id == current_phase else "", phase_id, PHASE_SHORT_NAMES[phase_id - 1]]
		phase_button.modulate = Color.WHITE if phase_id == current_phase else Color(0.68, 0.62, 0.66)
	phase_debug_active.text = "FASE ACTIVA: %d\n%s" % [current_phase, PHASE_SHORT_NAMES[current_phase - 1]]
	phase_label.text = "FASE %d/%d" % [current_phase, PHASES.size()]
	world_subtitle.text = "FASE %d  ·  %s" % [current_phase, phase.title]
	shop_subtitle.text = phase.joe
	phase_progress.max_value = _phase_target()
	phase_progress.value = minf(phase_work, _phase_target())
	phase_hint.text = "ESTABILIDAD  %s / %s  ·  %s" % [_number(phase_work), _number(_phase_target()), _phase_requirement()]
	joe_health_progress.value = joe_health_display
	joe_health_progress.modulate = Color("e15b67").lerp(Color("72d39c"), joe_health_display / 100.0)
	joe_health_label.text = "PRONÓSTICO DE JOE  %d%%" % roundi(joe_health_display)
	cells_label.text = "CÉLULAS  %s" % _number(cells)
	rate_label.text = "+%s/s  ·  %s/clic  ·  AUTO %s/s" % [_number(_rate()), _number(_click_power()), _number(_auto_hit_rate())]
	var tunnel_progress := clampf((1.0 - right_hp / right_max) / TUNNEL_UNLOCK_RATIO, 0.0, 1.0)
	click_counter.text = "DOS FOSAS ACTIVAS" if septum_open else "TUNELADORA  %d%%" % roundi(tunnel_progress * 100.0)
	var hp := left_hp if active_side == "left" else right_hp
	wall_label.text = "PARED %s  ·  FALTAN %s" % ["IZQUIERDA" if active_side == "left" else "DERECHA", _number(maxf(0.0, hp))]
	for upgrade in UPGRADES:
		var button := buttons[upgrade.id] as Button
		button.visible = _upgrade_available(upgrade)
		var level: int = int(levels[upgrade.id])
		var required: bool = str(upgrade.id) == _required_upgrade_id() and level == 0
		button.custom_minimum_size.y = 82.0 if required else 64.0
		_set_upgrade_halo(button, required)
		if not button.visible: continue
		var cost: float = ceil(float(upgrade.base) * pow(float(upgrade.growth), level))
		var maxed: bool = level >= int(upgrade.get("max", 999))
		var effect := "+%s / clic" % _number(float(upgrade.power))
		if upgrade.kind == "pawn": effect = "+1 peón"
		elif upgrade.kind == "speed": effect = "+18% velocidad de movimiento"
		elif upgrade.kind == "capacity": effect = "+1 pieza visible por viaje"
		elif upgrade.kind == "coordination": effect = "reparto entre fosas" if level == 0 else "prioridad a pedruscos"
		elif upgrade.kind == "specialist": effect = "1 de cada %d peones especializado" % maxi(1, 3 - level)
		elif upgrade.kind == "detector": effect = "menos viajes desperdiciados"
		elif upgrade.kind == "sorting": effect = "-8% de impurezas por nivel"
		elif upgrade.kind == "platelet": effect = "+2 plaquetas visibles"
		elif upgrade.kind == "repair": effect = "+16% reparación por plaqueta"
		elif upgrade.kind == "handler": effect = "+1 cuidador con guantes"
		elif upgrade.kind == "signals": effect = "+12% coordinación de crisis"
		elif upgrade.kind == "autoclicker": effect = "+1 púgil automático"
		elif upgrade.kind == "auto_power": effect = "+1 grano por puñetazo"
		elif upgrade.kind == "auto_speed": effect = "-16% intervalo automático"
		elif upgrade.kind == "click_burst": effect = "+3 granos en cada ráfaga"
		elif upgrade.kind == "click_rhythm": effect = "-1 clic para provocar la ráfaga"
		var required_line := "★ NECESARIA PARA SUPERAR ESTA FASE\n" if required else ""
		button.text = "%s%s  [NV. %d]\n%s\n%s  ·  %s células" % [required_line, upgrade.name, level, upgrade.desc, effect, _number(cost)]
		button.disabled = cells < cost or maxed

func _required_upgrade_id() -> String:
	if current_phase == 1 and puncher_unlocked: return "puncher"
	if current_phase == 2: return "breaker"
	if current_phase == 3: return "detector"
	if current_phase == 4: return "platelets"
	if current_phase == 5: return "handlers"
	return ""

func _set_upgrade_halo(button: Button, active: bool) -> void:
	if not active:
		for state in ["normal", "hover", "pressed", "disabled"]:
			button.remove_theme_stylebox_override(state)
		button.remove_theme_color_override("font_color")
		button.remove_theme_color_override("font_disabled_color")
		return
	var style := StyleBoxFlat.new()
	style.bg_color = Color("151525")
	style.border_color = Color("58c9ff")
	style.set_border_width_all(3)
	style.set_corner_radius_all(5)
	style.shadow_color = Color(0.2, 0.72, 1.0, 0.55)
	style.shadow_size = 6
	for state in ["normal", "hover", "pressed", "disabled"]:
		button.add_theme_stylebox_override(state, style)
	button.add_theme_color_override("font_color", Color("d9f4ff"))
	button.add_theme_color_override("font_disabled_color", Color("a9dff3"))

func _focus_required_upgrade() -> void:
	var required := _required_upgrade_id()
	if required.is_empty() or int(levels[required]) > 0: return
	var button := buttons.get(required) as Button
	if button and button.visible:
		_scroll_to_required_upgrade(button)

func _scroll_to_required_upgrade(button: Button) -> void:
	await get_tree().process_frame
	upgrade_scroll.ensure_control_visible(button)
	var target := button.position.y + button.size.y - upgrade_scroll.size.y + 8.0
	upgrade_scroll.scroll_vertical = maxi(0, roundi(target))

func _phase_requirement() -> String:
	if current_phase == 1:
		if not puncher_unlocked: return "JOE TODAVÍA NO HA TRAÍDO REFUERZOS"
		if int(levels.puncher) == 0: return "FALTA ESTRENAR AL PÚGIL"
		if int(levels.pawn) + int(levels.shift) + int(levels.box) < 3: return "SIGUE MEJORANDO LA LOGÍSTICA"
	if current_phase == 2 and int(levels.breaker) == 0: return "FALTA UN CASCO AZUL"
	if current_phase == 2 and rocks_opened < 6: return "PEDRUSCOS ABIERTOS  %d / 6" % rocks_opened
	if current_phase == 3:
		if int(levels.detector) == 0: return "FALTAN QUIMIORRECEPTORES"
		if impurities_cleaned < 10: return "MUESTRAS FILTRADAS  %d / 10" % impurities_cleaned
		if contamination >= 30.0: return "CAJA AÚN CONTAMINADA"
	if current_phase == 4:
		if int(levels.platelets) == 0: return "FALTAN PLAQUETAS"
		if tissue_repaired < 18.0: return "TEJIDO REPARADO  %d / 18" % floori(tissue_repaired)
		if tissue_damage >= 45.0: return "TEJIDO AÚN INESTABLE"
	if current_phase == 5:
		if int(levels.handlers) == 0: return "FALTAN CUIDADORES"
		if infection >= 35.0: return "INFECCIÓN AÚN INESTABLE"
		if phase_work >= _phase_target(): return "JOE SIGUE VIVO. DE MOMENTO."
	return "SISTEMA EN ADAPTACIÓN"

func _float_text(value: String, world_pos: Vector2) -> void:
	var label := Label.new()
	label.text = value
	label.position = world_pos - Vector2(30, 20)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color("fff1c7"))
	effects.add_child(label)
	var tween := create_tween().set_parallel()
	tween.tween_property(label, "position:y", label.position.y - 48.0, 0.55)
	tween.tween_property(label, "modulate:a", 0.0, 0.55)
	tween.chain().tween_callback(label.queue_free)

func _box_bump() -> void:
	var tween := create_tween()
	tween.tween_property(box, "rotation", -0.025, 0.05)
	tween.tween_property(box, "rotation", 0.0, 0.1)

func _show_toast(message: String) -> void:
	toast.text = message
	toast.modulate.a = 0.0
	var tween := create_tween()
	tween.tween_property(toast, "modulate:a", 1.0, 0.15)
	tween.tween_interval(1.15)
	tween.tween_property(toast, "modulate:a", 0.0, 0.25)

func _upgrade(id: String) -> Dictionary:
	for upgrade in UPGRADES:
		if upgrade.id == id: return upgrade
	return {}

func _number(value: float) -> String:
	var units := ["", "K", "M", "B", "T"]
	var index := 0
	while abs(value) >= 1000.0 and index < units.size() - 1:
		value /= 1000.0
		index += 1
	if index == 0 and value > 0.0 and value < 10.0 and not is_equal_approx(value, floor(value)): return "%.1f" % value
	return ("%.1f%s" % [value, units[index]]) if index else ("%d" % floor(value))

func _serialize_pile() -> Array:
	var data: Array = []
	for piece in loose_chunks:
		if not is_instance_valid(piece): continue
		data.append({"kind":piece.get_meta("kind", "grain"), "material":piece.get_meta("material", ""), "side":piece.get_meta("side", "right"), "value":float(piece.get_meta("value", 1.0)), "hardness":int(piece.get_meta("hardness", 0)), "max_hardness":int(piece.get_meta("max_hardness", 0)), "column":int(piece.get_meta("column", 0)), "scale":float(piece.get_meta("base_scale", 0.07)), "x_jitter":float(piece.get_meta("x_jitter", 0.0))})
	return data

func _serialize_fallen_wall_chunks() -> Array:
	var data: Array = []
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk):
			data.append({"side":chunk.get_meta("side", "right"), "fracture":int(chunk.get_meta("fracture_number", 1)), "slot":int(chunk.get_meta("slot", 0)), "hp":float(chunk.get_meta("hp", WALL_CHUNK_HEALTH)), "max_hp":float(chunk.get_meta("max_hp", WALL_CHUNK_HEALTH)), "mass":float(chunk.get_meta("mass", WALL_CHUNK_MASS)), "max_mass":float(chunk.get_meta("max_mass", WALL_CHUNK_MASS))})
	return data

func _clear_pile() -> void:
	for piece in loose_chunks:
		if is_instance_valid(piece): piece.queue_free()
	loose_chunks.clear()

func _clear_fallen_wall_chunks() -> void:
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk):
			chunk.queue_free()
	fallen_wall_chunks.clear()

func _restore_fallen_wall_chunks(data: Variant) -> void:
	_clear_fallen_wall_chunks()
	if typeof(data) != TYPE_ARRAY:
		return
	for entry_value in data:
		if typeof(entry_value) != TYPE_DICTIONARY:
			continue
		var entry: Dictionary = entry_value
		var legacy_hp := maxf(0.0, float(entry.get("hp", WALL_CHUNK_MASS)))
		var mass := maxf(0.0, float(entry.get("mass", legacy_hp)))
		var hp := maxf(1.0, float(entry.get("hp", WALL_CHUNK_HEALTH if entry.has("mass") else WALL_CHUNK_HEALTH * legacy_hp / WALL_CHUNK_MASS)))
		var side := str(entry.get("side", "right"))
		if _spawn_fallen_wall_chunk(side, int(entry.get("fracture", 1)), mass, false, int(entry.get("slot", -1))):
			var chunk: Sprite2D = fallen_wall_chunks.back()
			chunk.set_meta("hp", hp)
			chunk.set_meta("max_hp", maxf(hp, float(entry.get("max_hp", WALL_CHUNK_HEALTH))))
			chunk.set_meta("mass", mass)
			chunk.set_meta("max_mass", maxf(mass, float(entry.get("max_mass", WALL_CHUNK_MASS))))

func _restore_pile(data: Variant) -> void:
	_clear_pile()
	if typeof(data) != TYPE_ARRAY: return
	for entry_value in data:
		if typeof(entry_value) != TYPE_DICTIONARY: continue
		var entry: Dictionary = entry_value
		var kind := str(entry.get("kind", "grain"))
		if kind == "smart_clump": kind = "grain"
		var hardness := int(entry.get("hardness", 0))
		var piece := _create_piece(kind, str(entry.get("side", "right")), float(entry.get("value", 1.0)), int(entry.get("max_hardness", hardness)), int(entry.get("column", 0)), float(entry.get("scale", 0.18 if kind == "rock" else 0.07)), str(entry.get("material", "")))
		piece.set_meta("hardness", hardness)
		piece.set_meta("x_jitter", float(entry.get("x_jitter", 0.0)))
		piece.position = _landing_position(piece)
		if kind == "rock" and hardness == 0:
			piece.modulate = Color("eef4e7")
			var crack := piece.get_node_or_null("Crack") as Line2D
			if crack: crack.visible = true
	_restack_pile()

func _save() -> void:
	if not playing and not phase_event_pending: return
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({
			"version":SAVE_VERSION, "cells":cells,
			"right_hp":right_hp, "right_max":right_max, "left_hp":left_hp, "left_max":left_max,
			"right_cleared":right_cleared, "left_cleared":left_cleared,
			"septum_open":septum_open, "active_side":active_side, "levels":levels,
			"total_clicks":total_clicks, "pile":_serialize_pile(), "fallen_wall_chunks":_serialize_fallen_wall_chunks(),
			"compaction_steps":compaction_steps, "compaction_announced":compaction_announced,
			"current_phase":current_phase, "phase_work":phase_work, "joe_health":joe_health,
			"contamination":contamination, "box_jammed":box_jammed, "tissue_damage":tissue_damage, "infection":infection,
			"impurities_handled":impurities_handled, "bacteria_handled":bacteria_handled,
			"rocks_opened":rocks_opened, "impurities_cleaned":impurities_cleaned, "tissue_repaired":tissue_repaired,
			"another_line_clock":another_line_clock, "another_line_wave":another_line_wave, "another_line_spawn_index":another_line_spawn_index, "another_line_events":another_line_events,
			"puncher_unlocked":puncher_unlocked, "puncher_debut_pending":puncher_debut_pending,
			"puncher_debut_clock":puncher_debut_clock, "manual_clicks_since_burst":manual_clicks_since_burst,
			"phase_event_pending":phase_event_pending
		}))

func _load() -> void:
	if not FileAccess.file_exists(save_path): return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if typeof(data) != TYPE_DICTIONARY: return
	cells = float(data.get("cells", 0.0))
	right_hp = float(data.get("right_hp", FIRST_WALL_HP))
	right_max = float(data.get("right_max", FIRST_WALL_HP))
	left_hp = float(data.get("left_hp", FIRST_LEFT_WALL_HP))
	left_max = float(data.get("left_max", FIRST_LEFT_WALL_HP))
	right_cleared = int(data.get("right_cleared", 0))
	left_cleared = int(data.get("left_cleared", 0))
	total_clicks = int(data.get("total_clicks", 0))
	septum_open = bool(data.get("septum_open", false))
	active_side = str(data.get("active_side", "right"))
	levels = _empty_levels()
	for id in data.get("levels", {}):
		if levels.has(id): levels[id] = int(data.levels[id])
	if right_max < FIRST_WALL_HP:
		var right_ratio := clampf(right_hp / maxf(1.0, right_max), 0.0, 1.0)
		right_max = FIRST_WALL_HP
		right_hp = right_max * right_ratio
		right_cleared = 1 if right_hp <= 0.0 else 0
	if left_max < FIRST_LEFT_WALL_HP:
		var left_ratio := clampf(left_hp / maxf(1.0, left_max), 0.0, 1.0)
		left_max = FIRST_LEFT_WALL_HP
		left_hp = left_max * left_ratio
		left_cleared = 1 if left_hp <= 0.0 else 0
	_restore_pile(data.get("pile", []))
	_restore_fallen_wall_chunks(data.get("fallen_wall_chunks", []))
	var saved_steps = data.get("compaction_steps", {})
	if typeof(saved_steps) == TYPE_DICTIONARY:
		compaction_steps.left = int(saved_steps.get("left", 0))
		compaction_steps.right = int(saved_steps.get("right", 0))
	compaction_announced = bool(data.get("compaction_announced", false))
	current_phase = clampi(int(data.get("current_phase", 0)), 0, PHASES.size())
	if current_phase == 0:
		current_phase = 2 if compaction_announced or int(levels.breaker) > 0 else 1
	phase_work = float(data.get("phase_work", cells))
	joe_health = clampf(float(data.get("joe_health", JOE_STARTING_HEALTH + float(current_phase - 1) * 5.0)), 0.0, 100.0)
	joe_health_display = joe_health
	contamination = clampf(float(data.get("contamination", 0.0)), 0.0, 100.0)
	box_jammed = bool(data.get("box_jammed", contamination >= 99.9))
	contamination_band = int(contamination / 25.0)
	tissue_damage = clampf(float(data.get("tissue_damage", 0.0)), 0.0, 100.0)
	infection = clampf(float(data.get("infection", 0.0)), 0.0, 100.0)
	impurities_handled = int(data.get("impurities_handled", 0))
	bacteria_handled = int(data.get("bacteria_handled", 0))
	rocks_opened = int(data.get("rocks_opened", 0))
	impurities_cleaned = int(data.get("impurities_cleaned", 0))
	tissue_repaired = float(data.get("tissue_repaired", 0.0))
	another_line_clock = clampf(float(data.get("another_line_clock", ANOTHER_LINE_INTERVAL)), 0.0, ANOTHER_LINE_INTERVAL)
	another_line_wave = maxi(0, int(data.get("another_line_wave", 0)))
	another_line_spawn_index = maxi(0, int(data.get("another_line_spawn_index", 0)))
	another_line_events = maxi(0, int(data.get("another_line_events", 0)))
	puncher_unlocked = bool(data.get("puncher_unlocked", current_phase >= 2 or int(levels.puncher) > 0))
	puncher_debut_pending = bool(data.get("puncher_debut_pending", false))
	puncher_debut_clock = maxf(0.0, float(data.get("puncher_debut_clock", 0.0)))
	manual_clicks_since_burst = maxi(0, int(data.get("manual_clicks_since_burst", 0)))
	another_line_warned = another_line_clock <= ANOTHER_LINE_WARNING
	another_line_drop_clock = 0.0
	joe_clock = 0.0
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	phase_event_pending = bool(data.get("phase_event_pending", false))

func _continue_game() -> void:
	_load()
	_begin_game()

func _request_new_game() -> void:
	if FileAccess.file_exists(save_path): $NewGameDialog.popup_centered()
	else: _new_game()

func _empty_levels() -> Dictionary:
	var result := {}
	for upgrade in UPGRADES:
		result[upgrade.id] = 0
	return result

func _new_game() -> void:
	cells = 0.0
	right_hp = FIRST_WALL_HP
	right_max = FIRST_WALL_HP
	left_hp = FIRST_LEFT_WALL_HP
	left_max = FIRST_LEFT_WALL_HP
	right_cleared = 0
	left_cleared = 0
	total_clicks = 0
	septum_open = false
	active_side = "right"
	levels = _empty_levels()
	compaction_steps = {"left":0, "right":0}
	compaction_announced = false
	current_phase = 1
	phase_work = 0.0
	joe_health = JOE_STARTING_HEALTH
	joe_health_display = joe_health
	contamination = 0.0
	contamination_band = 0
	box_jammed = false
	tissue_damage = 0.0
	infection = 0.0
	impurities_handled = 0
	bacteria_handled = 0
	rocks_opened = 0
	impurities_cleaned = 0
	tissue_repaired = 0.0
	joe_clock = 0.0
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	another_line_clock = ANOTHER_LINE_INTERVAL
	another_line_wave = 0
	another_line_drop_clock = 0.0
	another_line_spawn_index = 0
	another_line_events = 0
	another_line_warned = false
	puncher_unlocked = false
	puncher_debut_pending = false
	puncher_debut_clock = 0.0
	manual_clicks_since_burst = 0
	phase_event_pending = true
	_clear_pile()
	_clear_fallen_wall_chunks()
	if FileAccess.file_exists(save_path): DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	_begin_game()

func _begin_game() -> void:
	playing = not phase_event_pending
	start_screen.hide()
	camera_x = _closed_camera_min()
	_rebuild_pawns()
	_rebuild_punchers()
	_rebuild_platelets()
	_update_world()
	_update_crisis_visuals()
	_update_pressure_visuals()
	_update_ui()
	call_deferred("_focus_required_upgrade")
	if phase_event_pending:
		call_deferred("_show_phase_event")

func _update_start_screen() -> void:
	var has_save := FileAccess.file_exists(save_path)
	continue_button.disabled = not has_save
	continue_button.text = "CONTINUAR PARTIDA" if has_save else "CONTINUAR  ·  SIN PARTIDA"
	save_state.text = "Joe sigue esperando dentro." if has_save else "Todavía no hay historial clínico."

func _exit_game() -> void:
	_save()
	get_tree().quit()

func _input(event: InputEvent) -> void:
	if not playing or not event is InputEventMouseButton:
		return
	var click := event as InputEventMouseButton
	if click.button_index != MOUSE_BUTTON_LEFT or not click.pressed or not stage_view.get_global_rect().has_point(click.position):
		return
	var world_pos := stage.get_global_transform_with_canvas().affine_inverse() * click.position
	if _manual_mine_fallen_wall_chunk(world_pos) or _manual_collect_at(world_pos):
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if playing and event.is_action_pressed("ui_accept"): _click_wall(active_side)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save()
		get_tree().quit()
