extends PanelContainer

signal close_requested
signal unit_selected(unit_id: String)

@onready var unit_grid: GridContainer = $Margin/Content/Body/UnitScroll/UnitGrid
@onready var title_label: Label = $Margin/Content/Body/Detail/UnitTitle
@onready var type_label: Label = $Margin/Content/Body/Detail/UnitType
@onready var stats_label: Label = $Margin/Content/Body/Detail/Stats
@onready var status_label: Label = $Margin/Content/Body/Detail/Status
@onready var upgrade_scroll: ScrollContainer = $Margin/Content/Body/Detail/UpgradeScroll
@onready var upgrade_list: VBoxContainer = $Margin/Content/Body/Detail/UpgradeScroll/UpgradeList

var cards := {}
var selected_id := ""

func _ready() -> void:
	$Margin/Content/Header/CloseButton.pressed.connect(func(): close_requested.emit())

func setup(catalog: Array[Dictionary]) -> void:
	for child in unit_grid.get_children(): child.queue_free()
	cards.clear()
	for unit in catalog:
		var button := Button.new()
		button.custom_minimum_size = Vector2(150.0, 92.0)
		button.text = str(unit.name)
		button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.toggle_mode = true
		button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
		button.vertical_icon_alignment = VERTICAL_ALIGNMENT_TOP
		button.expand_icon = true
		button.add_theme_constant_override("icon_max_width", 48)
		button.add_theme_font_size_override("font_size", 10)
		button.tooltip_text = str(unit.get("description", unit.name))
		button.set_meta("display_name", str(unit.name))
		button.set_meta("description", button.tooltip_text)
		var icon_path := str(unit.get("icon", ""))
		if not icon_path.is_empty(): button.icon = load(icon_path)
		button.pressed.connect(func(): unit_selected.emit(str(unit.id)))
		unit_grid.add_child(button)
		if str(unit.id) == "pugilist": _add_pugilist_layers(button)
		cards[unit.id] = button

func _add_pugilist_layers(button: Button) -> void:
	# Mismo guante y cinta procedurales que usa el Púgil dentro del escenario.
	var glove := Polygon2D.new()
	glove.polygon = PackedVector2Array([Vector2(-16, -4), Vector2(-9, -7), Vector2(-3, -3), Vector2(0, 3), Vector2(-4, 10), Vector2(-12, 10), Vector2(-17, 4)])
	glove.color = Color("f05261")
	glove.position = Vector2(61, 33)
	glove.z_index = 3
	button.add_child(glove)
	var headband := Polygon2D.new()
	headband.polygon = PackedVector2Array([Vector2(-11, -2), Vector2(11, -2), Vector2(13, 1), Vector2(-13, 1)])
	headband.color = Color("51c8e8")
	headband.position = Vector2(76, 17)
	headband.z_index = 3
	button.add_child(headband)

func update_card(unit_id: String, unlocked: bool, owned: int, urgent: bool) -> void:
	var button := cards.get(unit_id) as Button
	if not button: return
	button.modulate = Color.WHITE if unlocked else Color(0.16, 0.14, 0.18, 0.72)
	button.text = ("★ " if urgent else "") + str(button.get_meta("display_name", unit_id))
	button.tooltip_text = "UNIDAD DESCONOCIDA" if not unlocked else str(button.get_meta("description", ""))
	if owned > 0: button.text += "\nACTIVA  ×%d" % owned
	button.add_theme_color_override("font_color", Color("8bdcff") if urgent else Color("f4dfbd"))

func select_unit(unit: Dictionary, unlocked: bool, stats: String) -> void:
	selected_id = str(unit.id)
	title_label.text = str(unit.name) if unlocked else "???"
	type_label.text = str(unit.get("type", "UNIDAD DESCONOCIDA")) if unlocked else "SILUETA SIN IDENTIFICAR"
	stats_label.text = stats if unlocked else "Joe todavía no ha obligado al sistema inmune a desarrollar esta adaptación."
	status_label.text = "TECNOLOGÍAS DISPONIBLES" if unlocked else "BLOQUEADA  ·  SIGUE REDUCIENDO EL COLOCÓN"
	for id in cards:
		(cards[id] as Button).button_pressed = str(id) == selected_id
