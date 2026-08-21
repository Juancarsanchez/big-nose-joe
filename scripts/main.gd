extends Control

const SAVE := "user://big_nose_joe.save"
const SETTINGS := "user://big_nose_joe_settings.cfg"
const SAVE_VERSION := 19
const ProgressionData = preload("res://scripts/progression_data.gd")
const PilePieceData = preload("res://scripts/pile_piece.gd")
const PileBatchRenderer = preload("res://scripts/pile_renderer.gd")
const PowderSurfaceData = preload("res://scripts/powder_surface.gd")
const PowderEffectsData = preload("res://scripts/powder_effects.gd")
const PHASES := ProgressionData.PHASES
const UPGRADES := ProgressionData.UPGRADES
const UNIT_CATALOG := ProgressionData.UNIT_CATALOG
const QUICK_UPGRADE_IDS := ["nails", "continuous_sweep", "pawn", "pawn_capacity", "smart_clump", "breaker", "detector", "sponge_power", "repair"]
const MAX_PINNED_UPGRADES := 3
const PHASE_HIGH_THRESHOLDS := [90.0, 70.0, 52.0, 34.0, 18.0]
const STAGE_WIDTH := 7800.0
const SEPTUM_X := 3800.0
const WORLD_SCALE := 0.62
const FLOOR_HEIGHT := 95.0
const FIRST_WALL_HP := 100000000000000.0
const FIRST_LEFT_WALL_HP := 100000000000000.0
const TUNNEL_UNLOCK_PHASE := 4
const EDGE_SIZE := 34.0
const PAN_SPEED := 1050.0
const GRAIN_SPACING := 9.2
const GRAIN_HEIGHT := 7.4
# La montaña es una superficie continua: desde cinco unidades, una unidad de
# polvo ocupa exactamente un píxel de pantalla. Los impactos de 1-4 reservan
# cuatro píxeles para seguir siendo visibles. No hay un Sprite por grano.
const FOSSA_PIXEL_WORLD_AREA := 1.0 / (WORLD_SCALE * WORLD_SCALE)
const FOSSA_BASE_CAPACITY := 75000.0
const FOSSA_GALLERY_CAPACITY := 600000.0
const FOSSA_COMPRESSION_CAPACITIES := [600000.0, 100000000.0, 50000000000.0, 100000000000000.0]
const FOSSA_COMPRESSION_VISUAL_DIVISORS := [1.0, 200.0, 100000.0, 200000000.0]
const FOSSA_BASE_RADIUS := 92
const FOSSA_GALLERY_RADIUS := 300
const FOSSA_GALLERY_BOX_X := 7050.0
const ROCK_HEIGHT := 18.0
const MAX_PILE_RADIUS := 92
const PILE_BOX_MARGIN := 118.0
const BASE_BOX_LEFT := 4500.0
const MAX_SURFACE_STEP := 1.35
const TERRAIN_BAND_SIZE := 30
const TERRAIN_ANCHORS := [0.16, 0.68, 0.38, 0.84, 0.53]
const ANOTHER_LINE_ANCHORS := [0.10, 0.52, 0.90]
const ANOTHER_LINE_SHIFTS := [0.0, 0.08, -0.05, 0.13, -0.10]
const COMPACTION_THRESHOLD := 18.0
const COMPACTION_INTERVAL_MIN := 8
const COMPACTION_INTERVAL_MAX := 24
const COMPACTION_GRAINS := 6
const COMPACTION_ROCK_LIMIT := 8
const COMPACTION_CLICK_WINDOW := 10.0
const RIGHT_WALL_COLUMN := -5
const LEFT_WALL_COLUMN := 5
const BASE_PAWN_SPEED := 70.0
const BASE_CAPACITY := 3
const SMART_CLUMP_SIZES := [1, 3, 5, 8, 13, 21]
const SMART_CLUMP_RENAISSANCE_SIZES := [21, 55, 144]
const PAWN_FOOT_DEPTH := 14.0
const ROCK_SURFACE_INSET := 2.0
const STORAGE_CAPACITIES := [500.0, 1000.0, 5000.0, 100000.0, 2000000.0, 10000000.0, 100000000.0, 1000000000.0, 3000000000.0, 10000000000.0, 50000000000.0, 150000000000.0, 500000000000.0, 5000000000000.0, 50000000000000.0]
const CONTAINER_X := 4860.0
const SILO_X := 5350.0
const PLANT_X := 1150.0
const CART_CAPACITY := 12.0
const CART_REINFORCED_CAPACITY := 60.0
const CART_TRAILER_CAPACITY := 300.0
const CART_FREIGHT_CAPACITY := 1500.0
const CART_BULK_CAPACITY := 6000.0
const CART_TANKER_CAPACITY := 24000.0
const CART_RENAISSANCE_CAPACITIES := [24000.0, 500000000.0, 5000000000.0]
const OX_CAPACITIES := [40000.0, 150000.0, 600000.0, 2000000.0, 6500000.0, 20000000.0, 100000000.0, 500000000.0, 2000000000.0, 5000000000.0, 20000000000.0, 80000000000.0]
const CART_SPEED := 145.0
const OX_SPEED := 105.0
const TRAIN_SPEED := 330.0
const TRAIN_TUNNEL_TIME := 2.0
const LEFT_TUNNEL_X := 120.0
const RIGHT_TUNNEL_X := 7680.0
const CLICK_POWER_TIERS := [1.0, 3.0, 10.0, 30.0, 100.0, 300.0, 1000.0, 3000.0, 10000.0]
const PUGILIST_DAMAGE := [50, 500, 5000, 50000]
const PUGILIST_GRAINS_PER_HIT := 10
const PUGILIST_INTERVALS := [4.0, 3.2, 2.6, 2.2]
const PUNCHER_WALK_SPEED := 235.0
const PUNCHER_STRIKE_TIME := 0.18
const RAM_DAMAGE := [500000.0, 1000000.0, 2500000.0]
const RAM_INTERVAL := 8.0
const ELEPHANT_INTERVAL := 20.0
const CANNON_INTERVAL := 14.0
const SUPERSAIYAN_INTERVAL := 50.0
const HAMMER_INTERVAL := 4.0
const METEOR_INTERVAL := 12.0
const ELEPHANT_DAMAGE := [15000000.0, 45000000.0, 150000000.0, 600000000.0, 2400000000.0]
const PLASMA_DAMAGE := [5000000000.0, 20000000000.0, 80000000000.0, 320000000000.0]
const SUPERSAIYAN_DAMAGE := [1000000000000.0, 10000000000000.0, 100000000000000.0]
const HAMMER_DAMAGE := [600000000.0, 1200000000.0]
const METEOR_DAMAGE := [100000000000.0, 200000000000.0]
const PUNCH_RENAISSANCE_MULTIPLIERS := [1.0, 100.0, 1000.0]
const ELEPHANT_BASE_DAMAGE := 15000000.0
const CANNON_BASE_DAMAGE := 5000000000.0
const SUPERSAIYAN_BASE_DAMAGE := 1000000000000.0
const MANUAL_DELIVERY_BASE_TIME := 0.46
const JOE_STARTING_HIGH := 90.0
const JOE_HIGH_PER_COCAINE_UNIT := 0.00011
const PHASE_CLEANING_EFFICIENCY := [0.00024, 0.0000002, 0.000000001, 0.00000000003, 0.0000000000003]
const PHASE_TRANSITION_MULTIPLIERS := [1.0, 30.0, 60.0, 8.0, 1.0]
const ANOTHER_LINE_INTERVAL := 120.0
const ANOTHER_LINE_WARNING := 8.0
const ANOTHER_LINE_HIGH_GAIN := 0.5
const ANOTHER_LINE_MAX_PRESSURE := 0.025
const ANOTHER_LINE_MINING_THRESHOLDS := [1000.0, 5000.0, 20000.0, 100000.0, 500000.0, 2000000.0]
const ANOTHER_LINE_GRAIN_TIERS := [240, 360, 600, 1000, 1600, 2600, 4000]
const ANOTHER_LINE_DROP_INTERVAL := 0.035
const CHALK_INTERVAL := 180.0
const CHALK_UNITS := 600.0
const SPRAY_INTERVAL := 240.0
const SPRAY_FOLLOWUP := 30.0
const SPRAY_RECOAT_UNITS := 50000000.0
const SPRAY_FILM_UNITS := 2400.0
const SPRAY_MANUAL_SCRAPE := 20.0
const SCRATCH_INTERVAL := 240.0
const SCRATCH_DAMAGE := 28.0
const SCRATCH_HIGH_GAIN := 6.0
const PLATELET_REPAIR_MULTIPLIERS := [1.0, 2.5, 6.0, 15.0, 40.0, 100.0]
const MUCUS_INTERVAL := 180.0
const MUCUS_STRENGTH := 12000.0
const CATAPULT_INTERVAL := 2.8
const CATAPULT_BASE_DAMAGE := 600.0
const WALL_CHUNK_MASS := 25.0
const WALL_CHUNK_HEALTH := 24.0
const WALL_CHUNK_MAX_CLICK_DAMAGE := 3.0
const WALL_CHUNK_SCALE := 0.12
const WALL_CHUNK_CELL := 512
const MAX_FALLEN_WALL_CHUNKS := 4
const JAM_PASSIVE_PURGE := 0.10
const JAM_DETECTOR_PURGE := 0.20

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
const PLAYER_GRAIN_MATERIAL := preload("res://assets/art/gameplay/materials/player_grain_outline.tres")
const WALL_CHUNK_SHEET := preload("res://assets/art/gameplay/sprites/cocaine_wall_chunks.png")
const SPONGE_TEXTURE := preload("res://assets/art/gameplay/sprites/sponge_yellow.png")
const CATAPULT_TEXTURE := preload("res://assets/art/gameplay/sprites/mucus_catapult.png")
const CART_TEXTURE := preload("res://assets/art/gameplay/sprites/vesicular_cart.png")
const LEUKOX_TEXTURE := preload("res://assets/art/gameplay/sprites/leukox.png")
const CONVOY_TEXTURE := preload("res://assets/art/gameplay/sprites/convoy_wagons.png")
const TRAIN_TEXTURE := preload("res://assets/art/gameplay/sprites/leukocyte_express.png")
const CONTAINER_TEXTURE := preload("res://assets/art/gameplay/infrastructure/storage_container.png")
const SILO_TEXTURE := preload("res://assets/art/gameplay/infrastructure/cocaine_silo.png")
const PLANT_TEXTURE := preload("res://assets/art/gameplay/infrastructure/processing_plant.png")
const ELEPHANT_TEXTURE := preload("res://assets/art/gameplay/sprites/leukocyte_elephant.png")
const RAM_TEXTURE := preload("res://assets/art/gameplay/sprites/leukocyte_ram.png")
const PLASMA_CANNON_TEXTURE := preload("res://assets/art/gameplay/sprites/plasma_cannon.png")
const SUPERSAIYAN_TEXTURE := preload("res://assets/art/gameplay/sprites/leukocyte_supersaiyan.png")
const HAMMER_TEXTURE := preload("res://assets/art/gameplay/sprites/leukocyte_hammer.png")
const METEOR_TEXTURE := preload("res://assets/art/gameplay/sprites/neutrophil_meteor.png")
const SPECIAL_SPRITE_FOOT_PIXELS := {"ram":434.0, "elephant":337.0, "hammer":595.0, "plasma":353.0, "meteor":345.0, "supersaiyan":461.0}
const MUSIC_NASAL_SHIFT := preload("res://assets/audio/nasal_shift_loop.wav")
const SFX_PUNCH := preload("res://assets/audio/punch.wav")
const SFX_ELEPHANT := preload("res://assets/audio/elephant_hit.wav")
const SFX_CANNON := preload("res://assets/audio/cannon_fire.wav")
const SFX_KAMEHAMEHA := preload("res://assets/audio/kamehameha.wav")
const SFX_JOE_INHALE := preload("res://assets/audio/joe_inhale.wav")
const SFX_MUCUS := preload("res://assets/audio/mucus_splat.wav")
const SFX_ROCK := preload("res://assets/audio/rock_crack.wav")
const SFX_SAVE := preload("res://assets/audio/save_stamp.wav")
const SFX_OVERDOSE := preload("res://assets/audio/overdose.wav")

@onready var stage_view: Control = $World/StageViewport
@onready var stage: Control = $World/StageViewport/Stage
@onready var pawns: Control = $World/StageViewport/Stage/Layer60_Pawns
@onready var punchers: Control = $World/StageViewport/Stage/Layer58_Punchers
@onready var chunks: Control = $World/StageViewport/Stage/Layer50_Chunks
@onready var wall_chunks_layer: Control = $World/StageViewport/Stage/Layer52_WallChunks
@onready var infrastructure: Control = $World/StageViewport/Stage/Layer32_Infrastructure
@onready var transporters: Control = $World/StageViewport/Stage/Layer57_Transport
@onready var joe_events: Control = $World/StageViewport/Stage/Layer45_JoeEvents
@onready var platelets: Control = $World/StageViewport/Stage/Layer55_Platelets
@onready var effects: Control = $World/StageViewport/Stage/Layer70_Effects
@onready var adaptations: Control = $World/StageViewport/Stage/Layer59_Adaptations
@onready var blood_wash: ColorRect = $World/StageViewport/Stage/Layer46_Crisis/BloodWash
@onready var blood_drops: Control = $World/StageViewport/Stage/Layer46_Crisis/BloodDrops
@onready var damage_meter: PanelContainer = $World/DamageMeter
@onready var damage_label: Label = $World/DamageMeter/Margin/Content/Label
@onready var damage_progress: ProgressBar = $World/DamageMeter/Margin/Content/Progress
@onready var joe_high_label: Label = $World/JoeHigh/Margin/Content/Label
@onready var joe_high_progress: ProgressBar = $World/JoeHigh/Margin/Content/Progress
@onready var joe_portrait: TextureRect = $World/JoeHigh/Margin/Content/Portrait
@onready var joe_high_panel: PanelContainer = $World/JoeHigh
@onready var joe_high_feedback: Label = $World/JoeHigh/Margin/Content/Feedback
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
@onready var upgrade_list: VBoxContainer = $TechnologyLab/Margin/Content/Body/Detail/UpgradeScroll/UpgradeList
@onready var upgrade_scroll: ScrollContainer = $TechnologyLab/Margin/Content/Body/Detail/UpgradeScroll
@onready var phase_progress: ProgressBar = $Shop/Margin/Content/PhaseProgress
@onready var phase_hint: Label = $Shop/Margin/Content/PhaseHint
@onready var shop_subtitle: Label = $Shop/Margin/Content/Subtitle
@onready var shop: PanelContainer = $Shop
@onready var technology_lab = $TechnologyLab
@onready var technology_button: Button = $Shop/Margin/Content/TechnologyButton
@onready var quick_title: Label = $Shop/Margin/Content/QuickTitle
@onready var quick_scroll: ScrollContainer = $Shop/Margin/Content/UpgradeScroll
@onready var quick_list: VBoxContainer = $Shop/Margin/Content/UpgradeScroll/UpgradeList
@onready var options_menu: PanelContainer = $OptionsMenu
@onready var pause_button: Button = $OptionsMenu/Margin/Content/PauseButton
@onready var pause_overlay: PanelContainer = $PauseOverlay
@onready var music_slider: HSlider = $OptionsMenu/Margin/Content/MusicSlider
@onready var sfx_slider: HSlider = $OptionsMenu/Margin/Content/SfxSlider
@onready var music_label: Label = $OptionsMenu/Margin/Content/MusicLabel
@onready var sfx_label: Label = $OptionsMenu/Margin/Content/SfxLabel
@onready var world_subtitle: Label = $World/Subtitle
@onready var toast: Label = $World/Toast
@onready var start_screen: Control = $StartScreen
@onready var continue_button: Button = $StartScreen/Menu/Margin/Content/ContinueButton
@onready var save_state: Label = $StartScreen/Menu/Margin/Content/SaveState
@onready var joe_dialog: AcceptDialog = $JoeEventDialog

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
var pin_buttons := {}
var quick_buttons := {}
var pinned_buttons := {}
var pinned_upgrade_ids: Array[String] = []
var loose_chunks: Array[PilePiece] = []
var fallen_wall_chunks: Array[Sprite2D] = []
var pile_renderer: PileRenderer
var powder_surface: PowderSurface
var powder_effects: Node2D
var fossa_meter: PanelContainer
var fossa_meter_title: Label
var fossa_meter_progress: ProgressBar
var fossa_meter_readout: Label
var fossa_saturation_notice_clock := 0.0
var particle_motions: Array[Dictionary] = []
var pile_columns := {"left":{}, "right":{}}
var pile_heights := {"left":{}, "right":{}}
var reserved_heights := {"left":{}, "right":{}}
var pile_load_cache := {"left":0.0, "right":0.0}
var pile_visual_load_cache := {"left":0.0, "right":0.0}
var pile_mass_columns := {"left":{}, "right":{}}
var pile_revision := {"left":0, "right":0}
var joe_grain_load_cache := {"left":0.0, "right":0.0}
var rock_count_cache := {"left":0, "right":0}
var untreated_rock_count_cache := {"left":0, "right":0}
var kind_count_cache := {"grain":0, "rock":0, "impurity":0, "bacteria":0}
var manual_reserved_units := 0.0
var compaction_steps := {"left":0, "right":0}
var compaction_announced := false
var manual_mining_click_times: Array[float] = []
var current_phase := 1
var phase_work := 0.0
var phase_events := {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
var contamination := 0.0
var tissue_damage := 0.0
var infection := 0.0
var joe_high := JOE_STARTING_HIGH
var joe_high_display := JOE_STARTING_HIGH
var impurities_handled := 0
var bacteria_handled := 0
var bacteria_clock := 0.0
var blood_drop_clock := 0.0
var punch_clock := 0.0
var punch_round_count := 0
var contamination_band := 0
var box_jammed := false
var another_line_clock := ANOTHER_LINE_INTERVAL
var another_line_wave := 0
var another_line_drop_clock := 0.0
var another_line_spawn_index := 0
var another_line_events := 0
var another_line_warned := false
var mined_since_line := 0.0
var pending_line_grains := ANOTHER_LINE_GRAIN_TIERS[0]
var current_line_grains := 0
var last_line_grains := ANOTHER_LINE_GRAIN_TIERS[0]
var chalk_clock := CHALK_INTERVAL
var spray_clock := SPRAY_INTERVAL
var spray_followup_clock := 0.0
var spray_pending := false
var spray_side := "right"
var spray_film_hp := 0.0
var spray_film_max := 0.0
var spray_feedback_clock := 0.0
var scratch_clock := SCRATCH_INTERVAL
var mucus_clock := MUCUS_INTERVAL
var mucus_hp := 0.0
var mucus_max_hp := 0.0
var catapult_clock := 0.0
var puncher_unlocked := false
var puncher_debut_pending := false
var puncher_debut_clock := 0.0
var unit_debuts_seen := {}
var unit_debut_pending := {}
var manual_clicks_since_burst := 0
var continuous_sweep_held := false
var continuous_sweep_clock := 0.0
var rocks_opened := 0
var impurities_cleaned := 0
var tissue_repaired := 0.0
var phase_event_pending := false
var pending_phase_debut := 0
var camera_x := 0.0
var camera_goal := -1.0
var playing := false
var overdose_active := false
var overdose_dialog: ConfirmationDialog
var victory_active := false
var victory_reached := false
var victory_dialog: ConfirmationDialog
var ui_clock := 0.0
var save_path := SAVE
var settings_path := SETTINGS
var platelet_feedback_clock := 0.0
var music_player: AudioStreamPlayer
var impact_shake_tween: Tween
var joe_high_feedback_tween: Tween
var toast_tween: Tween
var joe_high_feedback_clock := 0.0
var music_volume := 0.75
var sfx_volume := 0.85
var selected_technology_unit := "manual"
var user_paused := false
var texture_foot_cache := {}
var texture_image_cache := {}

func _ready() -> void:
	powder_surface = PowderSurfaceData.new() as PowderSurface
	powder_surface.name = "PowderSurface"
	powder_surface.z_index = 0
	chunks.add_child(powder_surface)
	powder_surface.setup(self)
	powder_effects = PowderEffectsData.new()
	powder_effects.name = "PowderEffects"
	powder_effects.z_index = 32
	effects.add_child(powder_effects)
	_build_fossa_meter()
	pile_renderer = PileBatchRenderer.new()
	pile_renderer.name = "PileRenderer"
	add_child(pile_renderer)
	pile_renderer.setup(chunks)
	_discard_obsolete_save()
	_setup_audio()
	_start_music()
	technology_lab.setup(UNIT_CATALOG)
	# La barra superior solo conserva las tres cifras que sirven para decidir:
	# dinero disponible, potencia manual y extracción automática.
	phase_label.hide()
	pressure_label.hide()
	wall_label.hide()
	click_counter.hide()
	world_subtitle.hide()
	phase_progress.hide()
	overdose_dialog = ConfirmationDialog.new()
	overdose_dialog.title = "JOE SE HA MUERTO"
	overdose_dialog.dialog_text = "Joe se ha muerto por gilipollas y por sobredosis.\n\n¿Quieres cargar la última partida guardada?"
	overdose_dialog.ok_button_text = "SÍ, CARGAR PARTIDA"
	overdose_dialog.cancel_button_text = "NO, VOLVER AL MENÚ"
	overdose_dialog.exclusive = false
	overdose_dialog.confirmed.connect(_reload_after_overdose)
	overdose_dialog.canceled.connect(_return_to_menu_after_overdose)
	overdose_dialog.close_requested.connect(_return_to_menu_after_overdose)
	add_child(overdose_dialog)
	victory_dialog = ConfirmationDialog.new()
	victory_dialog.title = "JOE ESTÁ SOBRIO"
	victory_dialog.dialog_text = "Joe está sobrio, pero triste.\n\n¡Enhorabuena! Le has salvado la vida a Joe."
	victory_dialog.ok_button_text = "SEGUIR JUGANDO"
	victory_dialog.cancel_button_text = "VOLVER AL MENÚ"
	victory_dialog.exclusive = false
	victory_dialog.confirmed.connect(_continue_after_victory)
	victory_dialog.canceled.connect(_return_to_menu_after_victory)
	victory_dialog.close_requested.connect(_return_to_menu_after_victory)
	add_child(victory_dialog)
	for upgrade in UPGRADES:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 64)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_buy.bind(upgrade.id))
		var pin_button := Button.new()
		pin_button.custom_minimum_size = Vector2(58, 0)
		pin_button.text = "FIJAR"
		pin_button.tooltip_text = "Mostrar esta tecnología junto a los accesos rápidos"
		pin_button.pressed.connect(_toggle_upgrade_pin.bind(str(upgrade.id)))
		row.add_child(button)
		row.add_child(pin_button)
		upgrade_list.add_child(row)
		buttons[upgrade.id] = button
		pin_buttons[upgrade.id] = pin_button
	for upgrade_id in QUICK_UPGRADE_IDS:
		var quick_button := Button.new()
		quick_button.custom_minimum_size = Vector2(0.0, 62.0)
		quick_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		quick_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		quick_button.add_theme_font_size_override("font_size", 9)
		quick_button.pressed.connect(_buy.bind(upgrade_id))
		quick_list.add_child(quick_button)
		quick_buttons[upgrade_id] = quick_button
	technology_button.pressed.connect(_open_technology_lab)
	technology_lab.close_requested.connect(_close_technology_lab)
	technology_lab.unit_selected.connect(_select_technology_unit)
	right_button.pressed.connect(_click_wall.bind("right"))
	left_button.pressed.connect(_click_wall.bind("left"))
	break_button.pressed.connect($BreakDialog.popup_centered)
	$BreakDialog.confirmed.connect(_open_septum)
	$Shop/Margin/Content/MenuButton.pressed.connect(_open_options_menu)
	$OptionsMenu/Margin/Content/SaveButton.pressed.connect(_manual_save)
	pause_button.pressed.connect(_toggle_pause)
	$OptionsMenu/Margin/Content/SaveExitButton.pressed.connect(_exit_game)
	$OptionsMenu/Margin/Content/CloseButton.pressed.connect(_close_options_menu)
	music_slider.value_changed.connect(_set_music_volume)
	sfx_slider.value_changed.connect(_set_sfx_volume)
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
	_select_technology_unit(selected_technology_unit)
	_update_ui()

func _setup_audio() -> void:
	_ensure_audio_bus("Music")
	_ensure_audio_bus("SFX")
	var settings := ConfigFile.new()
	if settings.load(settings_path) == OK:
		music_volume = clampf(float(settings.get_value("audio", "music", music_volume)), 0.0, 1.0)
		sfx_volume = clampf(float(settings.get_value("audio", "effects", sfx_volume)), 0.0, 1.0)
	music_slider.set_value_no_signal(music_volume * 100.0)
	sfx_slider.set_value_no_signal(sfx_volume * 100.0)
	_apply_audio_volume("Music", music_volume)
	_apply_audio_volume("SFX", sfx_volume)
	_update_audio_labels()

func _ensure_audio_bus(bus_name: String) -> void:
	if AudioServer.get_bus_index(bus_name) >= 0: return
	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.bus_count - 1, bus_name)

func _apply_audio_volume(bus_name: String, volume: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index < 0: return
	AudioServer.set_bus_mute(index, volume <= 0.0)
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(0.0001, volume)))

func _set_music_volume(value: float) -> void:
	music_volume = clampf(value / 100.0, 0.0, 1.0)
	_apply_audio_volume("Music", music_volume)
	_update_audio_labels()
	_save_audio_settings()

func _set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value / 100.0, 0.0, 1.0)
	_apply_audio_volume("SFX", sfx_volume)
	_update_audio_labels()
	_save_audio_settings()

func _update_audio_labels() -> void:
	music_label.text = "MÚSICA  %d%%" % roundi(music_volume * 100.0)
	sfx_label.text = "EFECTOS DE SONIDO  %d%%" % roundi(sfx_volume * 100.0)

func _save_audio_settings() -> void:
	var settings := ConfigFile.new()
	settings.set_value("audio", "music", music_volume)
	settings.set_value("audio", "effects", sfx_volume)
	settings.save(settings_path)

func _open_options_menu() -> void:
	technology_lab.hide()
	shop.hide()
	options_menu.show()

func _close_options_menu() -> void:
	options_menu.hide()
	shop.show()

func _toggle_pause() -> void:
	user_paused = not user_paused
	pause_overlay.visible = user_paused
	pause_button.text = "REANUDAR PARTIDA" if user_paused else "PAUSAR PARTIDA"
	continuous_sweep_held = false
	_show_toast("PAUSA MÉDICA" if user_paused else "JOE VUELVE A SER UN PROBLEMA")

func _open_technology_lab() -> void:
	options_menu.hide()
	technology_lab.show()
	_update_technology_lab()

func _close_technology_lab() -> void:
	technology_lab.hide()

func _select_technology_unit(unit_id: String) -> void:
	selected_technology_unit = unit_id
	_update_technology_lab()
	_update_ui()

func _catalog_unit(unit_id: String) -> Dictionary:
	for unit in UNIT_CATALOG:
		if str(unit.id) == unit_id: return unit
	return {}

func _technology_unit_for_upgrade(upgrade_id: String) -> String:
	for unit in UNIT_CATALOG:
		if upgrade_id in unit.upgrades: return str(unit.id)
	return ""

func _technology_unit_unlocked(unit: Dictionary) -> bool:
	var unit_id := str(unit.id)
	if unit_id in ["manual", "pawn", "storage"]: return true
	if unit_id == "breaker" and compaction_announced: return true
	for upgrade_id in unit.upgrades:
		if int(levels.get(str(upgrade_id), 0)) > 0: return true
		var upgrade := _upgrade(str(upgrade_id))
		if not upgrade.is_empty() and _upgrade_available(upgrade): return true
	return false

func _technology_owned_count(unit_id: String) -> int:
	match unit_id:
		"manual": return 1
		"pawn": return int(levels.pawn)
		"surveyor": return 1 if int(levels.get("fossa_depth", 0)) > 0 else 0
		"pugilist": return _puncher_count()
		"ram": return int(levels.ram)
		"leukophant": return int(levels.elephant)
		"hammer": return int(levels.hammer)
		"plasma_cannon": return int(levels.plasma_cannon)
		"meteor": return int(levels.meteor)
		"supersaiyan": return int(levels.supersaiyan)
		"breaker":
			return pawns.get_children().filter(func(pawn: Node) -> bool: return bool(pawn.get_meta("specialist", false))).size()
		"detector": return int(levels.detector)
		"sponge": return int(levels.sponge)
		"platelet": return int(levels.platelets) * 2
		"handler": return int(levels.handlers)
		"catapult": return int(levels.catapult)
		"cart": return int(levels.cart)
		"leukox": return int(levels.ox_convoy)
		"train": return int(levels.train)
		"storage": return _storage_tier() + 1
	return 0

func _technology_stats(unit_id: String) -> String:
	match unit_id:
		"manual":
			var sweep := "BLOQUEADO" if int(levels.continuous_sweep) == 0 else "1 GRANO / %.2f S" % _continuous_sweep_interval()
			return "POTENCIA DE CLIC: %s\nBARRIDO: %s\nNUDILLOS: NV. %d" % [_number(_click_power()), sweep, int(levels.click_burst)]
		"pawn": return "UNIDADES: %d\nFUNCIÓN: RECOGIDA Y TRANSPORTE\nCARGA: %d BOLAS × %d GRANOS  ·  VELOCIDAD: %s" % [int(levels.pawn), _transport_capacity(), _smart_clump_size(), _number(_pawn_speed())]
		"surveyor":
			if int(levels.get("fossa_depth", 0)) <= 0:
				return "SIN FOSA CONSTRUIDA\nFUNCIÓN: MEDIR EL ESPACIO DE VERTIDO\nEL MEDIDOR APARECE AL CONSTRUIRLA"
			return "UNIDADES: 1\nESPACIO OCUPADO: %s\nCAPACIDAD MEDIDA: %s" % [_number(_pile_load(active_side)), _number(_fossa_capacity(active_side))]
		"pugilist":
			var combo := "CADA 3ª RONDA: DAÑO ×2" if int(levels.get("punch_combo", 0)) > 0 else "COMBO: SIN INVESTIGAR"
			return "UNIDADES: %d / 8\nDAÑO POR GOLPE: %s\nGOLPE CADA %.2f S\n%s" % [_puncher_count(), _number(_punch_output()), _punch_interval(), combo]
		"ram": return "UNIDADES: %d / 1\nEMBESTIDA: %s\nCARGA CADA %.0f S" % [int(levels.ram), _number(_special_extractor_damage("ram")), _special_extractor_interval("ram")]
		"leukophant": return "UNIDADES: %d / 1\nCABEZAZO: %s\nEMBESTIDA CADA %.0f S" % [int(levels.elephant), _number(_special_extractor_damage("elephant")), ELEPHANT_INTERVAL]
		"hammer": return "UNIDADES: %d / 1\nMARTILLAZO: %s\nIMPACTO CADA %.0f S" % [int(levels.hammer), _number(_special_extractor_damage("hammer")), HAMMER_INTERVAL]
		"plasma_cannon": return "UNIDADES: %d / 1\nDESCARGA: %s\nDISPARO CADA %.0f S" % [int(levels.plasma_cannon), _number(_special_extractor_damage("plasma")), CANNON_INTERVAL]
		"meteor": return "UNIDADES: %d / 1\nIMPACTO: %s\nVUELO CADA %.0f S" % [int(levels.meteor), _number(_special_extractor_damage("meteor")), METEOR_INTERVAL]
		"supersaiyan": return "UNIDADES: %d / 1\nKAMEHAMEHA: %s\nATAQUE CADA %.0f S" % [int(levels.supersaiyan), _number(_special_extractor_damage("supersaiyan")), SUPERSAIYAN_INTERVAL]
		"breaker": return "CASCOS ACTIVOS: %d\nDAÑO AL APELMAZADO: %d\nLÍMITE ACTUAL: %d PEDRUSCOS" % [_technology_owned_count(unit_id), _breaker_damage(), _compaction_rock_limit()]
		"detector": return "UNIDADES: %d\nIMPUREZAS FILTRADAS: %d\nCONTAMINACIÓN INTERNA: %d%%" % [int(levels.detector), impurities_cleaned, roundi(contamination)]
		"sponge": return "UNIDADES: %d / 2\nABSORCIÓN: %s DE SPRAY/S\nPELÍCULA RESTANTE: %s" % [int(levels.sponge), _number(_sponge_absorb_rate()), _number(spray_film_hp)]
		"platelet": return "UNIDADES: %d\nREPARACIÓN: %s TEJIDO/S\nDAÑO NASAL: %d%%" % [int(levels.platelets) * 2, _number(_platelet_repair_rate()), roundi(tissue_damage)]
		"handler": return "UNIDADES: %d\nBACTERIAS RETIRADAS: %d\nINFECCIÓN: %d%%" % [int(levels.handlers), bacteria_handled, roundi(infection)]
		"catapult": return "MÁQUINAS: %d / 2\nIMPACTO: %s\nLANZAMIENTO CADA %.1f S" % [int(levels.catapult), _number(CATAPULT_BASE_DAMAGE * pow(2.0, int(levels.catapult_power))), CATAPULT_INTERVAL]
		"cart": return "UNIDADES: %d / 1\nCARGA: %s POR VIAJE\nVELOCIDAD: %s" % [int(levels.cart), _number(_cart_capacity()), _number(_ground_transport_speed(CART_SPEED))]
		"leukox": return "UNIDADES: %d / 1\nCARGA: %s POR VIAJE\nVELOCIDAD: %s" % [int(levels.ox_convoy), _number(_ox_capacity()), _number(_ground_transport_speed(OX_SPEED))]
		"train": return "UNIDADES: %d / 1\nCARGA: TODO EL POLVO DISPONIBLE\nVELOCIDAD: %s" % [int(levels.train), _number(_train_speed())]
		"storage": return "NIVEL DE INSTALACIÓN: %d\nCAPACIDAD: %s\nOCUPACIÓN: %s" % [_storage_tier() + 1, _number(_storage_capacity()), _number(cells)]
	return "SIN DATOS"

func _update_technology_lab() -> void:
	if not is_instance_valid(technology_lab): return
	var required := _required_upgrade_id()
	for unit in UNIT_CATALOG:
		var unlocked := _technology_unit_unlocked(unit)
		var urgent: bool = not required.is_empty() and required in unit.upgrades
		technology_lab.update_card(str(unit.id), unlocked, _technology_owned_count(str(unit.id)), urgent)
	var selected := _catalog_unit(selected_technology_unit)
	if selected.is_empty():
		selected = UNIT_CATALOG[0]
		selected_technology_unit = str(selected.id)
	technology_lab.select_unit(selected, _technology_unit_unlocked(selected), _technology_stats(selected_technology_unit))

func _start_music() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.name = "NasalShiftMusic"
	music_player.stream = MUSIC_NASAL_SHIFT
	music_player.bus = "Music"
	music_player.volume_db = -18.0
	add_child(music_player)
	music_player.finished.connect(music_player.play)
	music_player.play()

func _play_sfx(stream: AudioStream, volume_db: float = -7.0, pitch: float = 1.0) -> void:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.bus = "SFX"
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()

func _impact_shake(strength: float) -> void:
	if impact_shake_tween and impact_shake_tween.is_valid(): impact_shake_tween.kill()
	stage.position.y = 0.0
	impact_shake_tween = create_tween()
	for offset in [strength, -strength * 0.7, strength * 0.4, 0.0]:
		impact_shake_tween.tween_property(stage, "position:y", offset, 0.045)

func _make_powder_flake(color: Color, size: float) -> Polygon2D:
	var flake := Polygon2D.new()
	flake.polygon = PackedVector2Array([
		Vector2(-size, size * 0.18), Vector2(-size * 0.28, -size * 0.72),
		Vector2(size * 0.82, -size * 0.24), Vector2(size * 0.44, size * 0.66),
	])
	flake.color = color
	return flake

func _spawn_impact_dust(origin: Vector2, color: Color = Color("9b5960"), amount: int = 5) -> void:
	for index in range(amount):
		var dust := _make_powder_flake(color, randf_range(2.2, 5.2))
		dust.position = origin + Vector2(randf_range(-14.0, 14.0), -randf_range(2.0, 12.0))
		dust.rotation = randf_range(-0.8, 0.8)
		dust.z_index = 30
		effects.add_child(dust)
		var destination := dust.position + Vector2(randf_range(-32.0, 32.0), -randf_range(20.0, 55.0))
		var tween := create_tween().set_parallel()
		tween.tween_property(dust, "position", destination, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(dust, "modulate:a", 0.0, 0.38)
		tween.chain().tween_callback(dust.queue_free)

func _spawn_debut_powder_burst(side: String, origin: Vector2, intensity: float = 1.0) -> void:
	# Es puramente celebración: no añade cocaína ni altera la economía. El polvo
	# económico ya cae mediante _spawn_extraction_payload con su masa real.
	var direction := -1.0 if side == "left" else 1.0
	var count := clampi(roundi(18.0 * intensity), 18, 46)
	for index in range(count):
		var flake := _make_powder_flake(Color("fff9e8"), randf_range(2.5, 6.8) * (0.85 + intensity * 0.18))
		flake.position = origin + Vector2(direction * randf_range(-8.0, 16.0), -randf_range(8.0, 42.0))
		flake.rotation = randf_range(-0.8, 0.8)
		flake.z_index = 31
		effects.add_child(flake)
		var apex := flake.position + Vector2(direction * randf_range(34.0, 100.0) * intensity, -randf_range(54.0, 145.0) * intensity)
		var landing := origin + Vector2(direction * randf_range(130.0, 340.0) * intensity, -randf_range(3.0, 26.0))
		var tween := create_tween()
		tween.tween_property(flake, "position", apex, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(flake, "position", landing, 0.38).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(flake, "modulate:a", 0.0, 0.22).set_delay(0.34)
		tween.parallel().tween_property(flake, "rotation", flake.rotation + randf_range(-2.8, 2.8), 0.56)
		tween.tween_callback(flake.queue_free)

func _spawn_powder_fall(origin: Vector2, side: String, amount: int = 6, intensity: float = 1.0, landing_column: int = 999) -> void:
	# El valor económico sigue viajando como datos; este polvo es únicamente la
	# lectura visual de que una porción de nieve ha salido de la pared o del techo.
	var direction := -1.0 if side == "left" else 1.0
	var targets: Array[Vector2] = []
	for index in range(clampi(amount, 1, 18)):
		var landing_x := origin.x + direction * randf_range(22.0, 105.0) * intensity
		if landing_column != 999:
			landing_x = _pile_center(side) + float(landing_column) * GRAIN_SPACING + randf_range(-9.0, 9.0) * intensity
		var surface_y := powder_surface.surface_y_at(side, landing_x) if powder_surface else _ground_y()
		targets.append(Vector2(landing_x, minf(_ground_y() - 2.0, surface_y - randf_range(1.0, 4.0))))
	powder_effects.spawn_fall(origin, targets, intensity)

func _spawn_powder_stream(start: Vector2, target: Vector2, intensity: float = 1.0) -> void:
	# Polvo atomizado: no existe una línea que delate la trayectoria completa.
	# Cada mota recorre el arco de forma independiente y el barrido continuo crea
	# una sucesión de pequeñas nubes en lugar de un rayo o una manguera.
	powder_effects.spawn_arc(start, target, intensity)

func _grain_stack_height(value: float) -> float:
	# Las piezas lógicas conservan una altura estable. Su valor solo cambia el
	# área de PowderSurface, donde el valor visual se traduce a píxeles de pantalla.
	return GRAIN_HEIGHT

func _spawn_energy_ring(origin: Vector2, color: Color, radius: float = 20.0) -> void:
	var ring := Line2D.new()
	var points := PackedVector2Array()
	for index in range(25):
		var angle := TAU * float(index) / 24.0
		points.append(origin + Vector2(cos(angle), sin(angle)) * radius)
	ring.points = points
	ring.width = 5.0
	ring.default_color = color
	ring.z_index = 19
	effects.add_child(ring)
	var tween := create_tween().set_parallel()
	tween.tween_property(ring, "scale", Vector2.ONE * 4.8, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(ring, "modulate:a", 0.0, 0.5)
	tween.chain().tween_callback(ring.queue_free)

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
	_rebuild_adaptations()
	_rebuild_infrastructure()
	_rebuild_transporters()
	_update_crisis_visuals()
	_update_pressure_visuals()

func _process(delta: float) -> void:
	_update_fossa_meter()
	if user_paused:
		return
	_update_particle_motions(delta)
	if not playing:
		return
	_update_camera(delta)
	_update_another_line(delta)
	_update_continuous_sweep(delta)
	_update_joe_events(delta)
	_update_crisis(delta)
	_update_box_jam(delta)
	_update_joe_high(delta)
	_update_punchers(delta)
	_update_special_extractors(delta)
	_update_pawns(delta)
	_update_platelets(delta)
	_update_adaptations(delta)
	_update_transporters(delta)
	ui_clock += delta
	if ui_clock >= 0.12:
		ui_clock = 0.0
		_update_pressure_visuals()
		_update_ui()
		_check_phase_progress()

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

func _build_fossa_meter() -> void:
	fossa_meter = PanelContainer.new()
	fossa_meter.name = "FossaMeter"
	fossa_meter.position = Vector2(28.0, 146.0)
	fossa_meter.size = Vector2(288.0, 57.0)
	fossa_meter.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var panel := StyleBoxFlat.new()
	panel.bg_color = Color("180d1cdd")
	panel.border_color = Color("b97f54")
	panel.set_border_width_all(1)
	panel.set_corner_radius_all(4)
	fossa_meter.add_theme_stylebox_override("panel", panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 9)
	margin.add_theme_constant_override("margin_right", 9)
	margin.add_theme_constant_override("margin_top", 5)
	margin.add_theme_constant_override("margin_bottom", 5)
	fossa_meter.add_child(margin)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 1)
	margin.add_child(content)
	fossa_meter_title = Label.new()
	fossa_meter_title.add_theme_font_size_override("font_size", 10)
	fossa_meter_title.add_theme_color_override("font_color", Color("9be6ef"))
	content.add_child(fossa_meter_title)
	fossa_meter_progress = ProgressBar.new()
	fossa_meter_progress.show_percentage = false
	fossa_meter_progress.custom_minimum_size = Vector2(0, 12)
	content.add_child(fossa_meter_progress)
	fossa_meter_readout = Label.new()
	fossa_meter_readout.add_theme_font_size_override("font_size", 10)
	fossa_meter_readout.add_theme_color_override("font_color", Color("f5e9c9"))
	content.add_child(fossa_meter_readout)
	$World.add_child(fossa_meter)

func _update_fossa_meter() -> void:
	if not is_instance_valid(fossa_meter):
		return
	fossa_meter.visible = playing and int(levels.get("fossa_depth", 0)) > 0
	if not fossa_meter.visible:
		return
	var side := active_side
	var load := _pile_load(side)
	var capacity := _fossa_capacity(side)
	var ratio := clampf(load / maxf(1.0, capacity), 0.0, 1.0)
	fossa_meter_title.text = "LEUCOTOPÓGRAFO DE 1927  ·  FOSA %s" % ("IZQUIERDA" if side == "left" else "DERECHA")
	fossa_meter_progress.value = ratio * 100.0
	fossa_meter_readout.text = "ESPACIO OCUPADO  %s / %s" % [_number(load), _number(capacity)]
	var danger := Color("e95b61") if ratio >= 0.9 else Color("9be6ef")
	fossa_meter_title.add_theme_color_override("font_color", danger)

func _mine_x(side: String = active_side) -> float:
	return 3618.0 if side == "left" else 3982.0

func _wall_center_x(side: String = active_side) -> float:
	return 3684.0 if side == "left" else 3916.0

func _wall_hp(side: String) -> float:
	return left_hp if side == "left" else right_hp

func _pile_center(side: String) -> float:
	return _mine_x(side) + (-58.0 if side == "left" else 58.0)

func _box_x() -> float:
	if int(levels.get("fossa_depth", 0)) > 0:
		return FOSSA_GALLERY_BOX_X
	if int(levels.get("silo", 0)) > 0:
		return SILO_X
	if int(levels.get("container", 0)) > 0:
		return CONTAINER_X
	return box.position.x + box.size.x * 0.35

func _storage_tier() -> int:
	var fusion_level := int(levels.get("plant_capacity", 0))
	if fusion_level > 0: return 11 + clampi(fusion_level, 1, 3)
	var buffer_level := int(levels.get("plant_buffer", 0))
	if buffer_level > 0: return 9 + clampi(buffer_level, 1, 2)
	if int(levels.get("plant", 0)) > 0: return 9
	if int(levels.get("vault_reserve", 0)) > 0: return 8
	if int(levels.get("vault_capacity", 0)) > 0: return 7
	if int(levels.get("vault", 0)) > 0: return 6
	if int(levels.get("silo_capacity", 0)) > 0: return 5
	if int(levels.get("silo", 0)) > 0: return 4
	if int(levels.get("warehouse", 0)) > 0: return 3
	if int(levels.get("container_capacity", 0)) > 0: return 2
	if int(levels.get("container", 0)) > 0: return 1
	return 0

func _storage_capacity() -> float:
	return float(STORAGE_CAPACITIES[_storage_tier()])

func _storage_space() -> float:
	return maxf(0.0, _storage_capacity() - cells)

func _reserved_storage() -> float:
	var reserved := 0.0
	for piece in loose_chunks:
		if not is_instance_valid(piece) or not bool(piece.get_meta("carried", false)):
			continue
		var kind: String = piece.get_meta("kind", "grain")
		if kind == "impurity":
			continue
		var value := float(piece.get_meta("value", 1.0))
		reserved += value * (_box_yield_multiplier() if kind == "grain" else 1.0)
	return reserved

func _storage_claim_space() -> float:
	return maxf(0.0, _storage_space() - _reserved_storage())

func _manual_reserved_storage() -> float:
	return manual_reserved_units

func _manual_claim_space() -> float:
	return maxf(0.0, _storage_space() - _manual_reserved_storage())

func _reserve_manual_piece(piece: PilePiece, stored_value: float) -> void:
	if piece.get_meta("kind", "grain") == "impurity":
		return
	piece.set_meta("manual_reservation", stored_value)
	manual_reserved_units += stored_value

func _release_manual_reservation(piece: PilePiece) -> void:
	var reserved := float(piece.get_meta("manual_reservation", 0.0))
	manual_reserved_units = maxf(0.0, manual_reserved_units - reserved)
	piece.set_meta("manual_reservation", 0.0)

func _store_cocaine(amount: float) -> float:
	var accepted := minf(maxf(0.0, amount), _storage_space())
	cells += accepted
	_update_storage_visual()
	return accepted

func _store_automatic_cocaine(amount: float) -> float:
	if amount > _manual_claim_space() + 0.001:
		return 0.0
	return _store_cocaine(amount)

func _pawn_speed() -> float:
	var crisis_factor := 1.0
	if current_phase >= 5:
		crisis_factor *= lerpf(1.0, 0.68, tissue_damage / 100.0)
	if current_phase >= 5:
		crisis_factor *= lerpf(1.0, 0.72, infection / 100.0)
	var motorway_multiplier := 1.50 if int(levels.shift) > 0 else 1.0
	return BASE_PAWN_SPEED * motorway_multiplier * crisis_factor

func _ground_transport_speed(base_speed: float) -> float:
	if is_equal_approx(base_speed, CART_SPEED):
		return base_speed * (1.0 + 0.40 * float(levels.get("cart_speed", 0)))
	if is_equal_approx(base_speed, OX_SPEED):
		return base_speed * (1.0 + 0.50 * float(levels.get("ox_speed", 0)))
	return base_speed

func _train_speed() -> float:
	return TRAIN_SPEED * float([1.0, 1.6, 2.5][clampi(int(levels.get("train_speed", 0)), 0, 2)])

func _transport_capacity() -> int:
	return BASE_CAPACITY + int(levels.get("pawn_capacity", 0))

func _breaker_damage() -> int:
	return 1 + int(levels.get("breaker_power", 0))

func _smart_clump_size(level := -1) -> int:
	var resolved_level := int(levels.get("smart_clump", 0)) if level < 0 else level
	var base_size := int(SMART_CLUMP_SIZES[clampi(resolved_level, 0, SMART_CLUMP_SIZES.size() - 1)])
	if resolved_level < SMART_CLUMP_SIZES.size() - 1:
		return base_size
	var renaissance := clampi(int(levels.get("pawn_renaissance", 0)), 0, SMART_CLUMP_RENAISSANCE_SIZES.size() - 1)
	return int(SMART_CLUMP_RENAISSANCE_SIZES[renaissance])

func _pawn_smart_clump_size(pawn: Sprite2D) -> int:
	if bool(pawn.get_meta("specialist", false)) or bool(pawn.get_meta("detector", false)) or bool(pawn.get_meta("handler", false)):
		return 1
	return _smart_clump_size()

func _pawn_claim_capacity(pawn: Sprite2D) -> int:
	return _transport_capacity() * _pawn_smart_clump_size(pawn)

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
		if int(levels.detector) == 0:
			_show_toast("CAJA ATASCADA  ·  QUIMIORRECEPTOR DE URGENCIAS GRATIS EN EL LABORATORIO", 6.5)
		else:
			_show_toast("CAJA ATASCADA  ·  TODOS PARADOS")
	if box_jammed:
		# La purga de emergencia impide una partida muerta. Sin detector tarda
		# 150 s; con el primero, solo 50 s. Los siguientes siguen acelerándola.
		var purge_rate := JAM_PASSIVE_PURGE + float(levels.detector) * JAM_DETECTOR_PURGE
		contamination = maxf(0.0, contamination - purge_rate * delta)
	if box_jammed and contamination <= 85.0:
		box_jammed = false
		_show_toast("LA CAJA VUELVE A TRAGAR")
	_update_box()

func _pile_access_point(side: String) -> Vector2:
	var rightmost_column := 2
	for column in (pile_columns[side] as Dictionary).keys():
		rightmost_column = maxi(rightmost_column, int(column))
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
			var piece := piece_value as PilePiece
			if is_instance_valid(piece) and piece.get_meta("kind", "grain") == "bacteria":
				holds_bacteria = true
				break
		target = HANDLER_CARRY if carrying and holds_bacteria else HANDLER_EMPTY
	elif detector:
		target = DETECTOR_EMPTY
	elif specialist:
		target = SPECIALIST_EMPTY
	else:
		# Los recolectores normales llevan un pellizco de nieve, no una ristra de
		# canicas. La carga real sigue existiendo fuera de pantalla como datos.
		target = PAWN_EMPTY
	if not carrying:
		var mound := pawn.get_node_or_null("PowderMound") as Node2D
		if mound: mound.visible = false
	if pawn.texture == target:
		return
	pawn.texture = target
	pawn.offset = Vector2(0.0, PAWN_FOOT_DEPTH / pawn.scale.y - _texture_opaque_bottom(target))

func _texture_opaque_bottom(texture: Texture2D) -> float:
	# Algunos uniformes tienen píxeles transparentes bajo los pies. Usar el alto
	# completo del PNG hacía flotar especialmente al casco azul.
	var key := texture.resource_path
	if texture_foot_cache.has(key):
		return float(texture_foot_cache[key])
	var image := texture.get_image()
	var opaque_bottom := float(texture.get_height()) * 0.5
	if image and not image.is_empty():
		for y in range(image.get_height() - 1, -1, -1):
			var found := false
			for x in range(image.get_width()):
				if image.get_pixel(x, y).a > 0.08:
					found = true
					break
			if found:
				opaque_bottom = float(y + 1) - float(image.get_height()) * 0.5
				break
	texture_foot_cache[key] = opaque_bottom
	return opaque_bottom

func _pawn_carries_powder_mound(pawn: Sprite2D) -> bool:
	if bool(pawn.get_meta("specialist", false)) or bool(pawn.get_meta("detector", false)) or bool(pawn.get_meta("handler", false)):
		return false
	var cargo: Array = pawn.get_meta("cargo", [])
	if cargo.is_empty():
		return false
	for value in cargo:
		var piece := value as PilePiece
		if not is_instance_valid(piece) or str(piece.get_meta("kind", "grain")) != "grain":
			return false
	return true

func _ensure_pawn_powder_mound(pawn: Sprite2D) -> Node2D:
	var existing := pawn.get_node_or_null("PowderMound") as Node2D
	if existing:
		return existing
	var mound := Node2D.new()
	mound.name = "PowderMound"
	mound.z_index = 16
	mound.visible = false
	var outline := Polygon2D.new()
	outline.name = "Outline"
	outline.polygon = PackedVector2Array([Vector2(-190, 92), Vector2(-170, 10), Vector2(-112, -58), Vector2(-40, -92), Vector2(42, -82), Vector2(122, -42), Vector2(178, 20), Vector2(194, 92)])
	outline.color = Color("32283a")
	mound.add_child(outline)
	var powder := Polygon2D.new()
	powder.name = "Powder"
	powder.polygon = PackedVector2Array([Vector2(-166, 78), Vector2(-148, 12), Vector2(-98, -44), Vector2(-36, -68), Vector2(35, -59), Vector2(103, -28), Vector2(153, 24), Vector2(169, 78)])
	powder.color = Color("f4f0dc")
	mound.add_child(powder)
	var shade := Polygon2D.new()
	shade.name = "PowderShade"
	shade.polygon = PackedVector2Array([Vector2(-152, 62), Vector2(-68, 34), Vector2(12, 44), Vector2(92, 18), Vector2(156, 58), Vector2(160, 78), Vector2(-160, 78)])
	shade.color = Color("d5d0c3")
	mound.add_child(shade)
	var glint := Polygon2D.new()
	glint.name = "PowderGlint"
	glint.polygon = PackedVector2Array([Vector2(-94, -30), Vector2(-38, -54), Vector2(16, -45), Vector2(-24, -24)])
	glint.color = Color("ffffff")
	mound.add_child(glint)
	pawn.add_child(mound)
	return mound

func _refresh_pawn_cargo_visual(pawn: Sprite2D) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	var powder_mound := _pawn_carries_powder_mound(pawn)
	var mound := _ensure_pawn_powder_mound(pawn) if powder_mound else pawn.get_node_or_null("PowderMound") as Node2D
	if mound:
		mound.visible = powder_mound
	if powder_mound:
		var clump_size := _pawn_smart_clump_size(pawn)
		var bundles := ceili(float(cargo.size()) / float(clump_size))
		var cargo_mass := 0.0
		for value in cargo:
			var carried_piece := value as PilePiece
			if is_instance_valid(carried_piece): cargo_mass += float(carried_piece.get_meta("value", 1.0))
		# Una unidad es apenas un pellizco. La mini-montaña solo alcanza el tamaño
		# anterior cuando la carga real justifica visualmente ese volumen.
		var mass_scale := 0.26 + minf(0.72, log(maxf(1.0, cargo_mass) + 1.0) / log(2.0) * 0.16)
		mound.set_meta("load_scale", mass_scale + minf(0.24, float(bundles - 1) * 0.08))
		for value in cargo:
			var powder_piece := value as PilePiece
			if is_instance_valid(powder_piece):
				powder_piece.visible = false
				pile_renderer.refresh_group(powder_piece)
		_update_pawn_powder_mound(pawn)
		return
	var clump_size := _pawn_smart_clump_size(pawn)
	var clump_scale := 1.0 + 0.08 * sqrt(float(clump_size - 1))
	for index in range(cargo.size()):
		var piece := cargo[index] as PilePiece
		if not is_instance_valid(piece):
			continue
		var bundle_head := index % clump_size == 0
		if bool(pawn.get_meta("handler", false)) and str(piece.get_meta("kind", "grain")) == "bacteria":
			bundle_head = false
		piece.set_meta("cargo_visual_index", int(index / clump_size))
		piece.set_meta("cargo_visual_scale", clump_scale)
		piece.visible = bundle_head
		piece.scale = Vector2.ONE * float(piece.get_meta("base_scale", 0.07)) * clump_scale
		pile_renderer.refresh_group(piece)

func _update_pawn_powder_mound(pawn: Sprite2D) -> void:
	var mound := pawn.get_node_or_null("PowderMound") as Node2D
	if not mound or not mound.visible:
		return
	var front := 1.0 if pawn.flip_h else -1.0
	mound.position = Vector2(front * 320.0, -248.0)
	mound.scale = Vector2.ONE * float(mound.get_meta("load_scale", 1.0))

func _update_pawns(delta: float) -> void:
	for node in pawns.get_children():
		var pawn := node as Sprite2D
		if not pawn: continue
		if box_jammed:
			if bool(pawn.get_meta("specialist", false)):
				_snap_pawn_to_surface(pawn, str(pawn.get_meta("side", active_side)))
			pawn.rotation = 0.0
			continue
		var state: String = pawn.get_meta("state", "to_pile")
		var cargo: Array = pawn.get_meta("cargo", [])
		# Recuperación barata frente a estados incompletos tras reconstruir la caja,
		# cambiar de fosa o retirar una pieza mientras el peón iba hacia ella.
		if state not in ["to_pile", "working", "lifting", "to_box", "deposit"]:
			state = "to_box" if not cargo.is_empty() else "to_pile"
			pawn.set_meta("state", state)
		elif state in ["lifting", "to_box", "deposit"] and cargo.is_empty():
			state = "to_pile"
			pawn.set_meta("state", state)
		elif state in ["to_pile", "working"] and not cargo.is_empty():
			state = "to_box"
			pawn.set_meta("state", state)
		var side: String = pawn.get_meta("side", active_side)
		var speed := _pawn_speed() * (1.0 + float(int(pawn.get_meta("index", 0)) % 3) * 0.025)
		var lane_x := float(pawn.get_meta("lane_x", 0.0))
		var floor_y := _ground_y() - 14.0
		var depot := Vector2(_box_x() + lane_x, floor_y)
		var specialist := bool(pawn.get_meta("specialist", false))
		var specialist_rock := _specialist_rock_target(side, pawn.position) if specialist else null
		var work_point := _pile_access_point(side) + Vector2(lane_x, 0.0)
		# Los cascos azules trepan hasta el pedrusco aunque la nieve normal lo haya
		# rodeado. Nunca se ponen a recoger polvo como si fueran peones corrientes.
		if is_instance_valid(specialist_rock):
			var specialist_x := specialist_rock.position.x + lane_x * 0.12
			var specialist_floor := powder_surface.surface_y_at(side, specialist_x) if powder_surface else _ground_y()
			work_point = Vector2(specialist_x, specialist_floor - PAWN_FOOT_DEPTH)
		if state == "to_pile":
			var obstruction := _nearest_fallen_wall_chunk(side, pawn.position)
			if obstruction:
				var queue_offset := float(int(pawn.get_meta("index", 0))) * 13.0
				var stop := Vector2(obstruction.position.x + 43.0 + queue_offset, floor_y)
				_move_pawn_toward(pawn, stop, speed, delta)
				_set_pawn_carrying(pawn, false)
				continue
			if specialist:
				_move_pawn_along_surface(pawn, work_point.x, side, speed, delta)
			else:
				_move_pawn_toward(pawn, work_point, speed, delta)
			_set_pawn_carrying(pawn, false)
			if pawn.position.distance_to(work_point) < 1.0:
				pawn.position = work_point
				pawn.set_meta("state", "working")
				pawn.set_meta("timer", 0.18 / (1.0 + float(levels.shift) * 0.12))
		elif state == "working":
			_set_pawn_facing(pawn, side == "left")
			var timer: float = float(pawn.get_meta("timer", 0.0)) - delta
			pawn.set_meta("timer", timer)
			pawn.position.x = work_point.x + sin(Time.get_ticks_msec() * 0.018 + int(pawn.get_meta("index", 0))) * 1.8
			if specialist:
				_snap_pawn_to_surface(pawn, side)
			if timer <= 0.0:
				if specialist:
					var rock := _specialist_rock_target(side, pawn.position)
					if not is_instance_valid(rock):
						# Sin apelmazados no hay trabajo para casco azul. Espera en lugar
						# de vaciar la montaña de nieve corriente.
						pawn.set_meta("timer", 0.42)
					elif pawn.position.distance_to(rock.position) > 30.0:
						pawn.set_meta("state", "to_pile")
						pawn.set_meta("timer", 0.0)
					elif int(rock.get_meta("hardness", 0)) > 0:
						_chip_rock(rock, _breaker_damage())
						pawn.set_meta("timer", 0.34 / (1.0 + float(levels.shift) * 0.12))
					else:
						var rocks := _claim_top_pieces(side, _pawn_claim_capacity(pawn), pawn)
						if rocks.is_empty():
							pawn.set_meta("timer", 0.28)
						else:
							pawn.set_meta("state", "lifting")
							pawn.set_meta("timer", 0.24)
							_set_pawn_carrying(pawn, true)
				else:
					var claimed := _claim_top_pieces(side, _pawn_claim_capacity(pawn), pawn)
					pawn.set_meta("cargo", claimed)
					if claimed.is_empty():
						pawn.set_meta("timer", 0.25)
					else:
						pawn.set_meta("state", "lifting")
						pawn.set_meta("timer", 0.24)
						_set_pawn_carrying(pawn, true)
		elif state == "lifting":
			var timer: float = float(pawn.get_meta("timer", 0.0)) - delta
			pawn.set_meta("timer", timer)
			_set_pawn_carrying(pawn, true)
			if specialist:
				_snap_pawn_to_surface(pawn, side)
			if timer <= 0.0: pawn.set_meta("state", "to_box")
		elif state == "to_box":
			if specialist:
				_move_pawn_along_surface(pawn, depot.x, side, speed, delta)
			else:
				_move_pawn_toward(pawn, depot, speed, delta)
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

func _move_pawn_toward(pawn: Sprite2D, target: Vector2, speed: float, delta: float) -> void:
	var direction := signf(target.x - pawn.position.x)
	if not is_zero_approx(direction): _set_pawn_facing(pawn, direction > 0.0)
	pawn.position = pawn.position.move_toward(target, speed * delta)

func _surface_pawn_y(side: String, x: float) -> float:
	var support := powder_surface.surface_y_at(side, x) if powder_surface else _ground_y()
	return minf(_ground_y(), support) - PAWN_FOOT_DEPTH

func _snap_pawn_to_surface(pawn: Sprite2D, side: String) -> void:
	pawn.position.y = _surface_pawn_y(side, pawn.position.x)

func _move_pawn_along_surface(pawn: Sprite2D, target_x: float, side: String, speed: float, delta: float) -> void:
	var direction := signf(target_x - pawn.position.x)
	if not is_zero_approx(direction):
		_set_pawn_facing(pawn, direction > 0.0)
	pawn.position.x = move_toward(pawn.position.x, target_x, speed * delta)
	_snap_pawn_to_surface(pawn, side)

func _set_pawn_facing(pawn: Sprite2D, faces_right: bool) -> void:
	# Todos los sprites de glóbulo blanco se dibujaron mirando a la izquierda.
	pawn.flip_h = faces_right

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

func _spawn_chunk(origin: Vector2, value: float, side: String = active_side, preferred_column: int = 999, source: String = "player", powder_effect: bool = false) -> void:
	var column := _choose_landing_column(side, preferred_column)
	var piece := _create_piece("grain", side, value, 0, column, randf_range(0.068, 0.078), "", source)
	_drop_piece(piece, origin)
	if powder_effect:
		_spawn_powder_fall(origin, side, clampi(roundi(3.0 + log(maxf(1.0, value)) / log(10.0) * 2.0), 3, 10), 1.0, column)

func _spawn_special_piece(kind: String, side: String, material: String = "") -> void:
	var scale := randf_range(0.078, 0.092) if kind == "impurity" else randf_range(0.07, 0.085)
	var value := 1.0 if kind == "impurity" else 2.0
	var piece := _create_piece(kind, side, value, 0, _choose_landing_column(side), scale, material)
	_drop_piece(piece, Vector2(_mine_x(side) + randf_range(-18.0, 18.0), _ground_y() - randf_range(210.0, 350.0)))

func _drop_piece(piece: PilePiece, origin: Vector2) -> void:
	_index_remove_piece(piece)
	piece.position = origin + Vector2(randf_range(-10.0, 10.0), 0.0)
	piece.rotation = randf_range(-0.18, 0.18)
	if piece.get_meta("kind", "grain") == "grain":
		piece.visible = false
	piece.set_meta("landed", false)
	pile_renderer.refresh_group(piece)
	var landing := _landing_position(piece)
	_index_add_piece(piece)
	var duration := randf_range(0.82, 1.18)
	particle_motions.append({"kind":"drop", "piece":piece, "elapsed":0.0, "duration":duration, "start":piece.position, "target":landing, "start_rotation":piece.rotation, "target_rotation":piece.rotation + randf_range(-0.42, 0.42)})

func _update_particle_motions(delta: float) -> void:
	for index in range(particle_motions.size() - 1, -1, -1):
		var motion: Dictionary = particle_motions[index]
		var piece := motion.piece as PilePiece
		if not piece or not piece.alive:
			particle_motions.remove_at(index)
			continue
		motion.elapsed = float(motion.elapsed) + delta
		var progress := clampf(float(motion.elapsed) / maxf(0.001, float(motion.duration)), 0.0, 1.0)
		if motion.kind == "drop":
			var eased := progress * progress
			piece.position = (motion.start as Vector2).lerp(motion.target as Vector2, eased)
			piece.rotation = lerpf(float(motion.start_rotation), float(motion.target_rotation), progress)
		else:
			_animate_manual_flight(smoothstep(0.0, 1.0, progress), piece, motion.start, motion.control, motion.target)
		if progress < 1.0:
			continue
		particle_motions.remove_at(index)
		if motion.kind == "drop":
			_mark_landed(piece)
		else:
			_finish_manual_delivery(piece)

func _create_piece(kind: String, side: String, value: float, hardness: int, column: int, piece_scale: float, material: String = "", source: String = "player") -> PilePiece:
	var piece := PilePieceData.new() as PilePiece
	piece.renderer = pile_renderer
	piece.texture = BACTERIA_TEXTURE if kind == "bacteria" else GRAIN_TEXTURE
	if kind == "grain" and source == "player":
		piece.material = PLAYER_GRAIN_MATERIAL
	column = _constrain_column(side, column)
	piece.scale = Vector2(piece_scale, piece_scale)
	piece.set_meta("base_scale", piece_scale)
	piece.set_meta("kind", kind)
	piece.set_meta("value", value)
	# Los primeros golpes necesitan un mínimo legible. Desde cinco unidades la
	# superficie vuelve a ser estrictamente lineal: N extraído = N píxeles.
	var visual_value := 4.0 if kind == "grain" and source == "player" and value <= 4.0 else value
	piece.set_meta("visual_value", visual_value)
	piece.set_meta("side", side)
	piece.set_meta("column", column)
	piece.set_meta("x_jitter", randf_range(-1.8, 1.8))
	piece.set_meta("height", ROCK_HEIGHT if kind == "rock" else (10.0 if kind == "bacteria" else _grain_stack_height(value)))
	piece.set_meta("material", material)
	piece.set_meta("source", source)
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
	loose_chunks.append(piece)
	piece.position = _landing_position(piece)
	_index_add_piece(piece)
	pile_renderer.add_piece(piece)
	if kind == "rock":
		_align_compacted_rocks(side)
	return piece

func _mark_landed(piece: Variant) -> void:
	if not is_instance_valid(piece): return
	var sprite := piece as PilePiece
	if not sprite: return
	_index_remove_piece(sprite)
	sprite.set_meta("landed", true)
	pile_renderer.refresh_group(sprite)
	_index_add_piece(sprite)
	var side: String = sprite.get_meta("side", "right")
	_settle_surface(side, 6)
	_restack_pile(side)
	compaction_steps[side] = int(compaction_steps.get(side, 0)) + 1
	_maybe_compact(side)

func _piece_is_in_pile(piece: PilePiece, side: String = "") -> bool:
	return is_instance_valid(piece) and piece.alive and not bool(piece.get_meta("carried", false)) and (side.is_empty() or piece.get_meta("side", "right") == side)

func _set_piece_carried(piece: PilePiece, carried: bool) -> void:
	if not is_instance_valid(piece) or bool(piece.get_meta("carried", false)) == carried:
		return
	piece.set_meta("carried", carried)
	pile_renderer.refresh_group(piece)

func _reset_pile_index() -> void:
	pile_columns = {"left":{}, "right":{}}
	pile_heights = {"left":{}, "right":{}}
	reserved_heights = {"left":{}, "right":{}}
	pile_load_cache = {"left":0.0, "right":0.0}
	pile_visual_load_cache = {"left":0.0, "right":0.0}
	pile_mass_columns = {"left":{}, "right":{}}
	pile_revision = {"left":int(pile_revision.get("left", 0)) + 1, "right":int(pile_revision.get("right", 0)) + 1}
	joe_grain_load_cache = {"left":0.0, "right":0.0}
	rock_count_cache = {"left":0, "right":0}
	untreated_rock_count_cache = {"left":0, "right":0}
	kind_count_cache = {"grain":0, "rock":0, "impurity":0, "bacteria":0}

func _index_add_piece(piece: PilePiece) -> void:
	if not _piece_is_in_pile(piece):
		return
	var side: String = piece.get_meta("side", "right")
	var column := int(piece.get_meta("column", 0))
	var height := float(piece.get_meta("height", GRAIN_HEIGHT))
	var value := float(piece.get_meta("value", 1.0))
	var visual_value := float(piece.get_meta("visual_value", value))
	pile_load_cache[side] = float(pile_load_cache[side]) + value
	pile_visual_load_cache[side] = float(pile_visual_load_cache[side]) + visual_value
	var mass_columns: Dictionary = pile_mass_columns[side]
	mass_columns[column] = float(mass_columns.get(column, 0.0)) + visual_value
	pile_revision[side] = int(pile_revision.get(side, 0)) + 1
	var kind := str(piece.get_meta("kind", "grain"))
	if kind == "grain" and piece.get_meta("source", "player") != "player":
		joe_grain_load_cache[side] = float(joe_grain_load_cache[side]) + value
	kind_count_cache[kind] = int(kind_count_cache.get(kind, 0)) + 1
	if kind == "rock":
		rock_count_cache[side] = int(rock_count_cache[side]) + 1
		if int(piece.get_meta("hardness", 0)) > 0:
			untreated_rock_count_cache[side] = int(untreated_rock_count_cache[side]) + 1
	if bool(piece.get_meta("landed", false)):
		var side_columns: Dictionary = pile_columns[side]
		if not side_columns.has(column):
			side_columns[column] = []
		(side_columns[column] as Array).append(piece)
		var heights: Dictionary = pile_heights[side]
		heights[column] = float(heights.get(column, 0.0)) + height
	else:
		var reserved: Dictionary = reserved_heights[side]
		reserved[column] = float(reserved.get(column, 0.0)) + height

func _index_remove_piece(piece: PilePiece) -> void:
	if not is_instance_valid(piece) or not piece.alive or bool(piece.get_meta("carried", false)):
		return
	var side: String = piece.get_meta("side", "right")
	var column := int(piece.get_meta("column", 0))
	var height := float(piece.get_meta("height", GRAIN_HEIGHT))
	var value := float(piece.get_meta("value", 1.0))
	var visual_value := float(piece.get_meta("visual_value", value))
	pile_load_cache[side] = maxf(0.0, float(pile_load_cache[side]) - value)
	pile_visual_load_cache[side] = maxf(0.0, float(pile_visual_load_cache[side]) - visual_value)
	var mass_columns: Dictionary = pile_mass_columns[side]
	var remaining_mass := maxf(0.0, float(mass_columns.get(column, 0.0)) - visual_value)
	if remaining_mass <= 0.001:
		mass_columns.erase(column)
	else:
		mass_columns[column] = remaining_mass
	pile_revision[side] = int(pile_revision.get(side, 0)) + 1
	var kind := str(piece.get_meta("kind", "grain"))
	if kind == "grain" and piece.get_meta("source", "player") != "player":
		joe_grain_load_cache[side] = maxf(0.0, float(joe_grain_load_cache[side]) - value)
	kind_count_cache[kind] = maxi(0, int(kind_count_cache.get(kind, 0)) - 1)
	if kind == "rock":
		rock_count_cache[side] = maxi(0, int(rock_count_cache[side]) - 1)
		if int(piece.get_meta("hardness", 0)) > 0:
			untreated_rock_count_cache[side] = maxi(0, int(untreated_rock_count_cache[side]) - 1)
	if bool(piece.get_meta("landed", false)):
		var side_columns: Dictionary = pile_columns[side]
		if side_columns.has(column):
			(side_columns[column] as Array).erase(piece)
			if (side_columns[column] as Array).is_empty():
				side_columns.erase(column)
		var heights: Dictionary = pile_heights[side]
		heights[column] = maxf(0.0, float(heights.get(column, 0.0)) - height)
	else:
		var reserved: Dictionary = reserved_heights[side]
		reserved[column] = maxf(0.0, float(reserved.get(column, 0.0)) - height)

func _index_move_column(piece: PilePiece, target_column: int) -> void:
	_index_remove_piece(piece)
	piece.set_meta("column", target_column)
	_index_add_piece(piece)

func _rebuild_pile_index(side_filter: String = "") -> void:
	if side_filter.is_empty():
		_reset_pile_index()
	else:
		pile_columns[side_filter] = {}
		pile_heights[side_filter] = {}
		reserved_heights[side_filter] = {}
		pile_load_cache[side_filter] = 0.0
		pile_visual_load_cache[side_filter] = 0.0
		pile_mass_columns[side_filter] = {}
		pile_revision[side_filter] = int(pile_revision.get(side_filter, 0)) + 1
		joe_grain_load_cache[side_filter] = 0.0
		rock_count_cache[side_filter] = 0
		untreated_rock_count_cache[side_filter] = 0
		kind_count_cache = {"grain":0, "rock":0, "impurity":0, "bacteria":0}
		for other_side in ["left", "right"]:
			if other_side == side_filter:
				continue
			for stack_value in (pile_columns[other_side] as Dictionary).values():
				for piece_value in stack_value:
					var existing := piece_value as PilePiece
					var existing_kind := str(existing.get_meta("kind", "grain"))
					kind_count_cache[existing_kind] = int(kind_count_cache.get(existing_kind, 0)) + 1
	for piece in loose_chunks:
		if not is_instance_valid(piece) or not piece.alive:
			continue
		if side_filter.is_empty() or piece.get_meta("side", "right") == side_filter:
			_index_add_piece(piece)

func _column_height(side: String, column: int, ignore: PilePiece = null) -> float:
	var height := float((pile_heights[side] as Dictionary).get(column, 0.0))
	var stack: Array = (pile_columns[side] as Dictionary).get(column, [])
	if ignore and stack.has(ignore):
		height -= float(ignore.get_meta("height", GRAIN_HEIGHT))
	return maxf(0.0, height)

func _reserved_column_height(side: String, column: int, ignore: PilePiece = null) -> float:
	var height := float((reserved_heights[side] as Dictionary).get(column, 0.0))
	if ignore and not bool(ignore.get_meta("landed", false)) and int(ignore.get_meta("column", 0)) == column and height > 0.0:
		height -= float(ignore.get_meta("height", GRAIN_HEIGHT))
	return maxf(0.0, height)

func _terrain_height(side: String, column: int) -> float:
	return _column_height(side, column) + _reserved_column_height(side, column)

func _constrain_column(side: String, column: int) -> int:
	if side == "right" and column < RIGHT_WALL_COLUMN:
		column = RIGHT_WALL_COLUMN + (RIGHT_WALL_COLUMN - column)
	elif side == "left" and column > LEFT_WALL_COLUMN:
		column = LEFT_WALL_COLUMN - (column - LEFT_WALL_COLUMN)
	var limit := _pile_radius_limit(side)
	return clampi(column, -limit, limit)

func _pile_radius_limit(side: String) -> int:
	var radius_cap := FOSSA_GALLERY_RADIUS if int(levels.get("fossa_depth", 0)) > 0 else FOSSA_BASE_RADIUS
	if side == "right":
		var free_width := maxf(18.0 * GRAIN_SPACING, _box_x() - PILE_BOX_MARGIN - _pile_center(side))
		return clampi(floori(free_width / GRAIN_SPACING), 18, radius_cap)
	var left_edge := 180.0 if septum_open else maxf(180.0, camera_x - 100.0)
	return clampi(floori((_pile_center(side) - left_edge) / GRAIN_SPACING), 18, radius_cap)

func _fossa_capacity(side: String = active_side) -> float:
	if int(levels.get("fossa_depth", 0)) <= 0:
		return FOSSA_BASE_CAPACITY
	var compression := clampi(int(levels.get("fossa_compression", 0)), 0, FOSSA_COMPRESSION_CAPACITIES.size() - 1)
	return float(FOSSA_COMPRESSION_CAPACITIES[compression])

func _fossa_visual_area_per_unit() -> float:
	var compression := clampi(int(levels.get("fossa_compression", 0)), 0, FOSSA_COMPRESSION_VISUAL_DIVISORS.size() - 1)
	return FOSSA_PIXEL_WORLD_AREA / float(FOSSA_COMPRESSION_VISUAL_DIVISORS[compression])

func _fossa_free_space(side: String = active_side) -> float:
	return maxf(0.0, _fossa_capacity(side) - _pile_load(side))

func _fossa_accepts(side: String, amount: float) -> float:
	return minf(maxf(0.0, amount), _fossa_free_space(side))

func _fossa_is_saturated(side: String = active_side) -> bool:
	return _fossa_free_space(side) <= 0.001

func _show_fossa_saturated(side: String = active_side) -> void:
	if Time.get_ticks_msec() * 0.001 < fossa_saturation_notice_clock:
		return
	fossa_saturation_notice_clock = Time.get_ticks_msec() * 0.001 + 1.4
	_show_toast("FOSA SATURADA  ·  RECOGE NIEVE O EXCAVA MÁS PROFUNDO", 3.4)
	_float_text("FOSA LLENA", Vector2(_pile_center(side), _ground_y() - 155.0))

func _return_powder_to_wall(side: String, amount: float) -> void:
	# Si Joe intenta echar más polvo en una fosa colmada, no se esfuma: vuelve a
	# quedar adherido a la pared. Así el límite es una decisión logística real.
	if side == "left":
		left_hp = minf(left_max, left_hp + maxf(0.0, amount))
	else:
		right_hp = minf(right_max, right_hp + maxf(0.0, amount))
	_update_world()

func _column_bounds(side: String, radius: int) -> Vector2i:
	return Vector2i(-radius, LEFT_WALL_COLUMN) if side == "left" else Vector2i(RIGHT_WALL_COLUMN, radius)

func _landing_position(piece: PilePiece) -> Vector2:
	var side: String = piece.get_meta("side", "right")
	var column: int = int(piece.get_meta("column", 0))
	var piece_height: float = float(piece.get_meta("height", GRAIN_HEIGHT))
	var stack_height := _column_height(side, column, piece)
	return Vector2(_pile_center(side) + float(column) * GRAIN_SPACING + float(piece.get_meta("x_jitter", 0.0)), _ground_y() - 5.0 - stack_height - piece_height * 0.5)

func _natural_drop_center(side: String, bounds: Vector2i) -> int:
	var band := int(_pile_load(side) / float(TERRAIN_BAND_SIZE)) % TERRAIN_ANCHORS.size()
	return roundi(lerpf(float(bounds.x), float(bounds.y), float(TERRAIN_ANCHORS[band])))

func _choose_landing_column(side: String, preferred_column: int = 999) -> int:
	var radius := mini(_pile_radius_limit(side), 2 + int(sqrt(_pile_load(side) / 2.8)))
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

func _movable_top_piece(side: String, column: int) -> PilePiece:
	var stack: Array = (pile_columns[side] as Dictionary).get(column, [])
	var top: PilePiece = stack.back() if not stack.is_empty() else null
	if top and top.get_meta("kind", "grain") == "rock":
		return null
	return top

func _settle_surface(side: String, max_moves: int) -> void:
	var bounds := _column_bounds(side, _pile_radius_limit(side))
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
		_index_move_column(grain, target_column)

func _top_pieces(side: String) -> Array[PilePiece]:
	var result: Array[PilePiece] = []
	for stack_value in (pile_columns[side] as Dictionary).values():
		var stack: Array = stack_value
		if not stack.is_empty():
			var piece := stack.back() as PilePiece
			if _piece_is_in_pile(piece, side):
				result.append(piece)
	result.sort_custom(func(a: PilePiece, b: PilePiece) -> bool: return a.position.y < b.position.y)
	return result

func _claim_top_pieces(side: String, capacity: int, pawn: Sprite2D) -> Array:
	var cargo: Array = []
	var remaining_storage := _storage_claim_space()
	var specialist := bool(pawn.get_meta("specialist", false))
	while cargo.size() < capacity:
		var collectable: Array[PilePiece] = []
		var handler := bool(pawn.get_meta("handler", false))
		# Para los cascos azules no existe el plan B de llevar nieve normal. Busca
		# únicamente apelmazados ya abiertos, incluso si la superficie los ha
		# cubierto parcialmente; los demás peones continúan usando la cima.
		var candidates: Array = loose_chunks if specialist else _top_pieces(side)
		for candidate_value in candidates:
			var candidate := candidate_value as PilePiece
			if not _piece_is_in_pile(candidate, side):
				continue
			var kind: String = candidate.get_meta("kind", "grain")
			if specialist and kind != "rock": continue
			if kind == "rock" and (not specialist or int(candidate.get_meta("hardness", 0)) > 0): continue
			if kind == "bacteria" and not handler: continue
			if kind == "impurity" and int(levels.detector) > 0 and not bool(pawn.get_meta("detector", false)): continue
			var stored_value := float(candidate.get_meta("value", 1.0)) * (_box_yield_multiplier() if kind == "grain" else 1.0)
			if kind != "impurity" and stored_value > remaining_storage + 0.001: continue
			collectable.append(candidate)
		if collectable.is_empty(): break
		var preferred: Array[PilePiece] = []
		if handler:
			preferred = collectable.filter(func(item: PilePiece) -> bool: return item.get_meta("kind", "grain") == "bacteria")
		elif bool(pawn.get_meta("detector", false)):
			preferred = collectable.filter(func(item: PilePiece) -> bool: return item.get_meta("kind", "grain") == "impurity")
		elif specialist:
			preferred = collectable.filter(func(item: PilePiece) -> bool: return item.get_meta("kind", "grain") == "rock")
		var source := preferred if not preferred.is_empty() else collectable
		if specialist and source.is_empty():
			break
		var piece := source[randi_range(0, mini(6, source.size() - 1))]
		var piece_kind: String = piece.get_meta("kind", "grain")
		_index_remove_piece(piece)
		# La carga del peón se representa después como una única mini-pila. Ocultar
		# aquí la pieza evita que un fotograma muestre bolitas arrancadas del polvo.
		piece.visible = false
		_set_piece_carried(piece, true)
		if piece_kind != "impurity":
			remaining_storage -= float(piece.get_meta("value", 1.0)) * (_box_yield_multiplier() if piece_kind == "grain" else 1.0)
		piece.z_index = 20
		cargo.append(piece)
	pawn.set_meta("cargo", cargo)
	_refresh_pawn_cargo_visual(pawn)
	_settle_surface(side, maxi(2, _transport_capacity()))
	_restack_pile(side)
	return cargo

func _surface_piece_at(world_pos: Vector2) -> PilePiece:
	var side := "left" if world_pos.x < SEPTUM_X else "right"
	if side == "left" and not septum_open:
		return null
	# La silueta ya no se deriva de las posiciones de las piezas lógicas. Si el
	# clic cae dentro del polvo renderizado, cualquier grano superior sirve como
	# representación exacta de la masa que se está retirando.
	if powder_surface and world_pos.y >= powder_surface.surface_y_at(side, world_pos.x) and world_pos.y <= _ground_y() + 5.0:
		var powder := _collectable_powder_near_x(side, world_pos.x)
		if powder:
			return powder
	var nearest: PilePiece = null
	var nearest_x := INF
	for piece in _top_pieces(side):
		if str(piece.get_meta("kind", "grain")) == "rock":
			continue
		var visual_height := maxf(6.0, float(piece.get_meta("height", GRAIN_HEIGHT)))
		var hit_width := maxf(GRAIN_SPACING * 1.35, piece.texture.get_width() * absf(piece.scale.x) * 0.55)
		var distance_x := absf(world_pos.x - piece.position.x)
		if distance_x <= hit_width and world_pos.y >= piece.position.y - visual_height and world_pos.y <= _ground_y() + 5.0 and distance_x < nearest_x:
			nearest = piece
			nearest_x = distance_x
	return nearest

func _collectable_powder_near_x(side: String, x: float) -> PilePiece:
	# La superficie es continua, pero los recursos siguen siendo datos discretos.
	# Buscamos nieve bajo el punto pulsado ignorando los apelmazados que pueda
	# haber más arriba en esa misma columna.
	var center_column := roundi((x - _pile_center(side)) / GRAIN_SPACING)
	var columns: Dictionary = pile_columns[side]
	var limit := _pile_radius_limit(side)
	for radius in range(limit * 2 + 1):
		var candidates := [center_column] if radius == 0 else [center_column - radius, center_column + radius]
		for column_value in candidates:
			var column := int(column_value)
			if not columns.has(column):
				continue
			var stack: Array = columns[column]
			for index in range(stack.size() - 1, -1, -1):
				var piece := stack[index] as PilePiece
				if not _piece_is_in_pile(piece, side):
					continue
				if str(piece.get_meta("kind", "grain")) not in ["rock", "bacteria"]:
					return piece
	return null

func _blocking_pile_piece_at(world_pos: Vector2) -> PilePiece:
	var side := "left" if world_pos.x < SEPTUM_X else "right"
	for value in loose_chunks:
		var piece := value as PilePiece
		if not _piece_is_in_pile(piece, side) or str(piece.get_meta("kind", "grain")) not in ["rock", "bacteria"]:
			continue
		var radius := maxf(7.0, minf(16.0, piece.texture.get_width() * absf(piece.scale.x) * 0.44))
		if world_pos.distance_squared_to(piece.position) <= radius * radius and _piece_opaque_at(piece, world_pos):
			return piece
	return null

func _piece_opaque_at(piece: PilePiece, world_pos: Vector2) -> bool:
	if not piece or not piece.texture or is_zero_approx(piece.scale.x) or is_zero_approx(piece.scale.y):
		return false
	var key := piece.texture.resource_path
	var image: Image = texture_image_cache.get(key)
	if not image:
		image = piece.texture.get_image()
		if not image or image.is_empty():
			return true
		texture_image_cache[key] = image
	var local := (world_pos - piece.position).rotated(-piece.rotation)
	var pixel := Vector2i(floori(local.x / piece.scale.x + float(image.get_width()) * 0.5), floori(local.y / piece.scale.y + float(image.get_height()) * 0.5))
	return pixel.x >= 0 and pixel.y >= 0 and pixel.x < image.get_width() and pixel.y < image.get_height() and image.get_pixelv(pixel).a > 0.08

func _direct_loose_piece_at(world_pos: Vector2) -> PilePiece:
	var side := "left" if world_pos.x < SEPTUM_X else "right"
	if side == "left" and not septum_open:
		return null
	var nearest: PilePiece = null
	var nearest_distance := INF
	var center_column := roundi((world_pos.x - _pile_center(side)) / GRAIN_SPACING)
	var columns: Dictionary = pile_columns[side]
	# Solo se consultan las cinco columnas cercanas; el clic sigue siendo barato
	# incluso con decenas de miles de granos renderizados por lotes.
	for column in range(center_column - 2, center_column + 3):
		if not columns.has(column): continue
		for value in columns[column]:
			var piece := value as PilePiece
			if not _piece_is_in_pile(piece, side): continue
			var kind: String = piece.get_meta("kind", "grain")
			if kind in ["rock", "bacteria"]: continue
			var radius := maxf(5.5, minf(9.0, piece.texture.get_width() * absf(piece.scale.x) * 0.72))
			var distance := world_pos.distance_squared_to(piece.position)
			if distance <= radius * radius and distance < nearest_distance:
				nearest = piece
				nearest_distance = distance
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
	if user_paused or not playing:
		return false
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
		_spawn_chunk(chunk.position - Vector2(0.0, 34.0), released, side, column, "detached")
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

func _manual_collect_at(world_pos: Vector2, _show_feedback: bool = true, continuous_stream: bool = false) -> bool:
	if user_paused or not playing:
		return false
	# Un grano visible y señalado con precisión gana al área de selección grande
	# del pedrusco. Así el apelmazado estorba, pero no secuestra los clics vecinos.
	# El apelmazado solo intercepta los píxeles opacos de su silueta; sus márgenes
	# transparentes ya no bloquean la nieve que se ve por debajo o entre bolas.
	var piece := _blocking_pile_piece_at(world_pos)
	if not piece:
		piece = _direct_loose_piece_at(world_pos)
	if not piece:
		piece = _surface_piece_at(world_pos)
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
	var stored_value := float(piece.get_meta("value", 1.0)) * (_box_yield_multiplier() if kind == "grain" else 1.0)
	if kind != "impurity" and stored_value > _manual_claim_space() + 0.001:
		_float_text("ALMACÃ‰N LLENO", world_pos)
		return true
	var side: String = piece.get_meta("side", "right")
	_index_remove_piece(piece)
	if kind == "grain":
		piece.visible = false
	_set_piece_carried(piece, true)
	piece.set_meta("manual_flying", true)
	_reserve_manual_piece(piece, stored_value)
	piece.z_index = 30
	_settle_surface(side, 3)
	_restack_pile(side)
	var start := piece.position
	var target := Vector2(_box_x() + 8.0, _ground_y() - 24.0)
	var control := (start + target) * 0.5 - Vector2(0.0, 85.0 + absf(target.x - start.x) * 0.08)
	var duration := MANUAL_DELIVERY_BASE_TIME + minf(0.28, start.distance_to(target) / 1500.0)
	if kind == "grain":
		_spawn_powder_stream(start, target, 1.5 if continuous_stream else 0.72)
	particle_motions.append({"kind":"manual", "piece":piece, "elapsed":0.0, "duration":duration, "start":start, "control":control, "target":target})
	return true

func _continuous_sweep_interval() -> float:
	return _continuous_sweep_interval_for(int(levels.get("continuous_sweep", 0)))

func _continuous_sweep_interval_for(level: int) -> float:
	return [INF, 0.22, 0.14, 0.09][clampi(level, 0, 3)]

func _update_continuous_sweep(delta: float) -> void:
	if not continuous_sweep_held or int(levels.get("continuous_sweep", 0)) == 0:
		return
	# Si se perdió el evento de soltar el ratón al salir de la ventana, no debe
	# seguir enviando nubes fantasma hacia la caja.
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		continuous_sweep_held = false
		return
	continuous_sweep_clock -= delta
	if continuous_sweep_clock > 0.0:
		return
	var screen_pos := get_viewport().get_mouse_position()
	if not stage_view.get_global_rect().has_point(screen_pos):
		continuous_sweep_held = false
		return
	var world_pos := stage.get_global_transform_with_canvas().affine_inverse() * screen_pos
	var piece := _surface_piece_at(world_pos)
	if not piece or box_jammed:
		continuous_sweep_clock = 0.05
		return
	var kind: String = piece.get_meta("kind", "grain")
	var stored_value := float(piece.get_meta("value", 1.0)) * (_box_yield_multiplier() if kind == "grain" else 1.0)
	if kind in ["rock", "bacteria"] or (kind != "impurity" and stored_value > _manual_claim_space() + 0.001):
		continuous_sweep_clock = 0.08
		return
	_manual_collect_at(world_pos, false, true)
	continuous_sweep_clock = _continuous_sweep_interval()

func _animate_manual_flight(progress: float, piece: Variant, start: Vector2, control: Vector2, target: Vector2) -> void:
	if not is_instance_valid(piece):
		return
	var sprite := piece as PilePiece
	if not sprite:
		return
	_release_manual_reservation(sprite)
	var inverse := 1.0 - progress
	sprite.position = start * inverse * inverse + control * 2.0 * inverse * progress + target * progress * progress
	sprite.rotation += 0.055
	var base_scale := float(sprite.get_meta("base_scale", 0.07))
	var flight_pop := 1.0 + sin(progress * PI) * 0.42 - progress * 0.24
	sprite.scale = Vector2.ONE * base_scale * flight_pop

func _finish_manual_delivery(piece: Variant) -> void:
	if not is_instance_valid(piece):
		return
	var sprite := piece as PilePiece
	if not sprite:
		return
	var kind: String = sprite.get_meta("kind", "grain")
	var value := float(sprite.get_meta("value", 1.0))
	var previous_contamination := contamination
	var delivered := 0.0
	if kind == "impurity":
		impurities_handled += 1
		contamination = clampf(contamination + _impurity_contamination(str(sprite.get_meta("material", "")), value), 0.0, 100.0)
		_float_text("LA CAJA SE ENSUCIA", _storage_feedback_position())
	else:
		var requested := value * _box_yield_multiplier()
		delivered = _store_cocaine(requested)
		if delivered <= 0.0:
			_set_piece_carried(sprite, false)
			sprite.set_meta("manual_flying", false)
			sprite.visible = true
			sprite.position = _landing_position(sprite)
			_index_add_piece(sprite)
			sprite.scale = Vector2.ONE * float(sprite.get_meta("base_scale", 0.07))
			_restack_pile(str(sprite.get_meta("side", "right")))
			_float_text("ALMACÉN LLENO", _storage_feedback_position())
			return
		var progress_value := value * delivered / maxf(0.001, requested)
		phase_work += progress_value
		if sprite.get_meta("source", "player") != "player":
			_improve_joe(progress_value)
		_float_text("+%s" % _number(delivered), _storage_feedback_position())
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
	var front := 1.0 if pawn.flip_h else -1.0
	return pawn.position + Vector2(front * 15.0 + (float(column) - float(columns - 1) * 0.5) * 5.0, -15.0 - float(row) * 5.0)

func _update_carried_pieces(pawn: Sprite2D) -> void:
	if _pawn_carries_powder_mound(pawn):
		_update_pawn_powder_mound(pawn)
		return
	var cargo: Array = pawn.get_meta("cargo", [])
	for piece_value in cargo:
		var piece := piece_value as PilePiece
		if is_instance_valid(piece):
			piece.position = _cargo_position(pawn, int(piece.get_meta("cargo_visual_index", 0)), _transport_capacity())

func _begin_deposit(pawn: Sprite2D) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	var mound := pawn.get_node_or_null("PowderMound") as Node2D
	if mound and mound.visible:
		mound.set_meta("deposit_start", mound.position)
		mound.set_meta("deposit_scale", mound.scale.x)
	for piece_value in cargo:
		var piece := piece_value as PilePiece
		if is_instance_valid(piece): piece.set_meta("deposit_start", piece.position)
	pawn.set_meta("state", "deposit")
	pawn.set_meta("timer", 0.0)

func _update_deposit(pawn: Sprite2D, progress: float) -> void:
	var cargo: Array = pawn.get_meta("cargo", [])
	var target := Vector2(_box_x() + 8.0, _ground_y() - 24.0)
	var mound := pawn.get_node_or_null("PowderMound") as Node2D
	if mound and mound.visible:
		var mound_start: Vector2 = mound.get_meta("deposit_start", mound.position)
		var local_target := pawn.to_local(target)
		var mound_progress := smoothstep(0.0, 1.0, progress)
		mound.position = mound_start.lerp(local_target, mound_progress)
		mound.scale = Vector2.ONE * lerpf(float(mound.get_meta("deposit_scale", mound.scale.x)), 0.22, mound_progress)
		return
	for index in range(cargo.size()):
		var piece := cargo[index] as PilePiece
		if not is_instance_valid(piece): continue
		var start: Vector2 = piece.get_meta("deposit_start", piece.position)
		var visual_index := int(piece.get_meta("cargo_visual_index", index))
		var delayed := clampf(progress * 1.35 - float(visual_index) * 0.08, 0.0, 1.0)
		piece.position = start.lerp(target, smoothstep(0.0, 1.0, delayed))
		var base_scale: float = float(piece.get_meta("base_scale", 0.07))
		var cargo_scale := float(piece.get_meta("cargo_visual_scale", 1.0))
		piece.scale = Vector2.ONE * lerpf(base_scale * cargo_scale, 0.015, delayed)

func _finish_delivery(pawn: Sprite2D) -> void:
	var delivered := 0.0
	var contamination_delta := 0.0
	var previous_contamination := contamination
	var cargo: Array = pawn.get_meta("cargo", [])
	for piece_value in cargo:
		var piece := piece_value as PilePiece
		if not is_instance_valid(piece): continue
		var value := float(piece.get_meta("value", 0.0))
		var kind: String = piece.get_meta("kind", "grain")
		var consumed := true
		if kind == "impurity":
			impurities_handled += 1
			if bool(pawn.get_meta("detector", false)):
				delivered += _store_automatic_cocaine(value * 0.15 * float(levels.detector))
				phase_work += 1.25 * float(levels.detector)
				contamination_delta -= 0.45 + float(levels.detector) * 0.15
				impurities_cleaned += 1
			else:
				contamination_delta += _impurity_contamination(str(piece.get_meta("material", "")), value)
		elif kind == "bacteria":
			if bool(pawn.get_meta("handler", false)):
				var accepted := _store_automatic_cocaine(value)
				if accepted > 0.0:
					delivered += accepted
					bacteria_handled += 1
					infection = maxf(0.0, infection - 3.5)
					_change_joe_high(-0.18)
					phase_work += 2.5
				else:
					consumed = false
			else:
				consumed = false
		else:
			var requested := value * _box_yield_multiplier()
			var accepted := _store_automatic_cocaine(requested)
			if accepted > 0.0:
				delivered += accepted
				var progress_value := value * accepted / maxf(0.001, requested)
				phase_work += progress_value
				if piece.get_meta("source", "player") != "player":
					_improve_joe(progress_value)
			else:
				consumed = false
		if consumed:
			loose_chunks.erase(piece)
			piece.queue_free()
		else:
			piece.visible = true
			_set_piece_carried(piece, false)
			piece.scale = Vector2.ONE * float(piece.get_meta("base_scale", 0.08))
			piece.position = _landing_position(piece)
			_index_add_piece(piece)
	contamination = clampf(contamination + contamination_delta, 0.0, 100.0)
	if contamination_delta > 0.0:
		_float_text("LA CAJA SE ENSUCIA", _storage_feedback_position())
	elif contamination_delta < 0.0:
		_float_text("LIMPIANDO", _storage_feedback_position())
	elif delivered > 0.0:
		_float_text("+%s" % _number(delivered), _storage_feedback_position())
	_update_contamination_warning(previous_contamination)
	pawn.set_meta("cargo", [])
	pawn.set_meta("state", "to_pile")
	pawn.set_meta("side", _choose_work_side(int(pawn.get_meta("index", 0))))
	_set_pawn_carrying(pawn, false)
	_restack_pile()
	_update_box()
	_box_bump()
	_check_phase_progress()

func _impurity_contamination(material: String, value: float) -> float:
	# La suciedad depende del bulto visual recogido, no del valor económico que
	# representa. Así una lluvia tardía ensucia más veces, pero no atasca de golpe.
	if material == "yeso": return 0.55
	if material == "tiza": return 0.45
	if material == "serrín": return 0.35
	return 0.45

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

func _specialist_rock_target(side: String, from: Vector2) -> PilePiece:
	var target: PilePiece = null
	var best_score := INF
	for value in loose_chunks:
		var candidate := value as PilePiece
		if not _piece_is_in_pile(candidate, side) or candidate.get_meta("kind", "grain") != "rock":
			continue
		# Abrir un pedrusco tiene prioridad absoluta. Entre rocas equivalentes,
		# el casco azul elige la más cercana para que el trayecto se lea fluido.
		var unopened_penalty := 0.0 if int(candidate.get_meta("hardness", 0)) > 0 else 1000000.0
		var score := unopened_penalty + from.distance_squared_to(candidate.position)
		if score < best_score:
			best_score = score
			target = candidate
	return target

func _chip_rock(rock: PilePiece, power: int = 1) -> void:
	if not is_instance_valid(rock): return
	var previous_hardness := int(rock.get_meta("hardness", 0))
	var hardness := maxi(0, previous_hardness - maxi(1, power))
	rock.set_meta("hardness", hardness)
	if previous_hardness > 0 and hardness == 0:
		rocks_opened += 1
		var side := str(rock.get_meta("side", "right"))
		untreated_rock_count_cache[side] = maxi(0, int(untreated_rock_count_cache[side]) - 1)
	var crack := rock.get_node_or_null("Crack") as Line2D
	if crack:
		crack.visible = true
		crack.modulate.a = 1.0 - float(hardness) / maxf(1.0, float(rock.get_meta("max_hardness", 1)))
	var tween := create_tween()
	tween.tween_property(rock, "rotation", rock.rotation + 0.12, 0.06)
	tween.tween_property(rock, "rotation", rock.rotation - 0.10, 0.06)
	tween.tween_property(rock, "rotation", 0.0, 0.08)
	_float_text("CRACK" if hardness > 0 else "LISTO", rock.position - Vector2(0.0, 18.0))
	_play_sfx(SFX_ROCK, -13.0, randf_range(0.88, 1.12))
	if hardness == 0:
		rock.modulate = Color("eef4e7")
		_spawn_impact_dust(rock.position, Color("eef4e7"), 5)

func _maybe_compact(side: String) -> void:
	if not _compaction_unlocked(): return
	if _rock_count(side) >= _compaction_rock_limit(): return
	var pressure_rate := _auto_hit_rate() + _special_extraction_rate(true)
	var interval := _compaction_interval()
	if _pile_load(side) < COMPACTION_THRESHOLD or int(compaction_steps.get(side, 0)) < interval: return
	var grains := _dense_grain_cluster(side)
	if grains.size() < COMPACTION_GRAINS: return
	var value := 0.0
	var source := "player"
	for grain in grains:
		value += float(grain.get_meta("value", 1.0))
		if grain.get_meta("source", "player") != "player":
			source = "joe"
		_index_remove_piece(grain)
		loose_chunks.erase(grain)
		grain.queue_free()
	compaction_steps[side] = 0
	_restack_pile(side)
	var hardness := clampi(2 + floori(log(maxf(1.0, pressure_rate + 1.0)) / log(4.0)), 2, 9)
	var rock := _create_piece("rock", side, value, hardness, _choose_landing_column(side), randf_range(0.17, 0.205), "", source)
	rock.rotation = randf_range(-0.18, 0.18)
	rock.scale = Vector2.ZERO
	var compact_tween := create_tween()
	compact_tween.tween_property(rock, "scale", Vector2.ONE * float(rock.get_meta("base_scale", 0.18)), 0.24).set_trans(Tween.TRANS_BACK)
	compact_tween.tween_callback(_align_compacted_rocks.bind(side))
	if not compaction_announced:
		compaction_announced = true
		_show_toast("EL POLVO SE APELMAZA  ·  NECESITAS UN CASCO AZUL", 4.2)
		_update_ui()
		call_deferred("_focus_required_upgrade")
		_save()

func _compaction_interval() -> int:
	var pressure_rate := _auto_hit_rate() + _special_extraction_rate(true)
	var interval := COMPACTION_INTERVAL_MAX - roundi(sqrt(maxf(0.0, pressure_rate)) * 1.4)
	var click_rate := _manual_mining_click_rate()
	if click_rate >= 4.0:
		interval -= 12
	elif click_rate >= 2.0:
		interval -= 6
	return clampi(interval, COMPACTION_INTERVAL_MIN, COMPACTION_INTERVAL_MAX)

func _compaction_unlocked() -> bool:
	# La primera rayita presenta el problema; el 70% lo convierte en presión constante.
	return current_phase >= 2 or another_line_events > 0

func _compaction_rock_limit() -> int:
	return 2 if current_phase == 1 else COMPACTION_ROCK_LIMIT

func _record_manual_mining_click() -> void:
	manual_mining_click_times.append(Time.get_ticks_msec() * 0.001)
	_prune_manual_mining_clicks()

func _manual_mining_click_rate() -> float:
	_prune_manual_mining_clicks()
	return float(manual_mining_click_times.size()) / COMPACTION_CLICK_WINDOW

func _prune_manual_mining_clicks() -> void:
	var cutoff := Time.get_ticks_msec() * 0.001 - COMPACTION_CLICK_WINDOW
	while not manual_mining_click_times.is_empty() and manual_mining_click_times[0] < cutoff:
		manual_mining_click_times.pop_front()

func _dense_grain_cluster(side: String) -> Array[PilePiece]:
	var grains: Array[PilePiece] = []
	for stack_value in (pile_columns[side] as Dictionary).values():
		var stack: Array = stack_value
		for index in range(maxi(0, stack.size() - 4), stack.size()):
			var piece := stack[index] as PilePiece
			if piece.get_meta("kind", "grain") == "grain":
				grains.append(piece)
	var spatial := {}
	for grain in grains:
		var cell := Vector2i(floori(grain.position.x / 22.0), floori(grain.position.y / 22.0))
		if not spatial.has(cell):
			spatial[cell] = []
		(spatial[cell] as Array).append(grain)
	for center in grains:
		var neighbours: Array[PilePiece] = []
		var center_cell := Vector2i(floori(center.position.x / 22.0), floori(center.position.y / 22.0))
		for offset_y in range(-1, 2):
			for offset_x in range(-1, 2):
				for candidate_value in spatial.get(center_cell + Vector2i(offset_x, offset_y), []):
					var candidate := candidate_value as PilePiece
					if candidate != center and center.position.distance_squared_to(candidate.position) <= 484.0:
						neighbours.append(candidate)
		if neighbours.size() >= COMPACTION_GRAINS - 1:
			neighbours.sort_custom(func(a: PilePiece, b: PilePiece) -> bool: return center.position.distance_squared_to(a.position) < center.position.distance_squared_to(b.position))
			var cluster: Array[PilePiece] = [center]
			cluster.append_array(neighbours.slice(0, COMPACTION_GRAINS - 1))
			return cluster
	return []

func _pile_load(side: String) -> float:
	return float(pile_load_cache.get(side, 0.0))

func _pile_visual_load(side: String) -> float:
	return float(pile_visual_load_cache.get(side, 0.0))

func _untreated_rock_count(side: String) -> int:
	return int(untreated_rock_count_cache.get(side, 0))

func _rock_count(side: String) -> int:
	return int(rock_count_cache.get(side, 0))

func _click_wall(side: String) -> void:
	if user_paused or not playing:
		return
	if (side == "left" and not septum_open) or _wall_hp(side) <= 0.0: return
	active_side = side
	if mucus_hp > 0.0:
		total_clicks += 1
		var mucus_hit := minf(_click_power(), mucus_hp)
		_damage_mucus(mucus_hit)
		_float_text("MOCO  -%s" % _number(mucus_hit), Vector2(_mine_x(side), _ground_y() - 235.0))
		return
	if spray_film_hp > 0.0:
		total_clicks += 1
		var spray_hit := minf(SPRAY_MANUAL_SCRAPE, spray_film_hp)
		_remove_spray_film(spray_hit)
		_float_text("SPRAY  -%s" % _number(spray_hit), Vector2(_mine_x(side), _ground_y() - 235.0))
		return
	for node in punchers.get_children():
		if not node is Sprite2D:
			continue
		var puncher := node as Sprite2D
		# Picar la misma pared no debe reiniciar la carrera automática. Antes cada
		# clic teletransportaba la cuadrilla a casa y la devolvía a estado idle.
		if str(puncher.get_meta("side", active_side)) == side:
			continue
		puncher.set_meta("side", side)
		_place_puncher(puncher)
	total_clicks += 1
	_record_manual_mining_click()
	var hit := minf(_click_power(), minf(_wall_hp(side), _fossa_free_space(side)))
	if hit <= 0.0:
		_show_fossa_saturated(side)
		return
	_damage_wall(hit, side)
	_spawn_chunk(Vector2(_mine_x(side), _ground_y() - randf_range(160.0, 310.0)), hit, side, 999, "player", true)
	_float_text("-%s" % _number(hit), Vector2(_mine_x(side), _ground_y() - 280.0))
	if int(levels.click_burst) > 0 and _wall_hp(side) > 0.0:
		manual_clicks_since_burst += 1
		var threshold := maxi(6, 10 - int(levels.click_rhythm))
		if manual_clicks_since_burst >= threshold:
			manual_clicks_since_burst = 0
			var repeats := int(levels.click_burst)
			var burst := minf(float(repeats) * _click_power(), minf(_wall_hp(side), _fossa_free_space(side)))
			if burst > 0.0:
				_damage_wall(burst, side)
				_spawn_extraction_payload(side, burst, _mine_x(side), repeats)
				_float_text("¡RÁFAGA!  -%s" % _number(burst), Vector2(_mine_x(side), _ground_y() - 245.0))
			else:
				_show_fossa_saturated(side)

func _damage_wall(amount: float, side: String = active_side) -> void:
	var extracted := minf(maxf(0.0, amount), _wall_hp(side))
	if extracted <= 0.0:
		return
	mined_since_line += extracted
	_improve_joe(extracted, true)
	if side == "left":
		if left_hp <= 0.0: return
		var previous_ratio := clampf(left_hp / left_max, 0.0, 1.0)
		left_hp = maxf(0.0, left_hp - amount)
		_update_world()
		left_hp = maxf(0.0, left_hp - _wall_damage_feedback(side, previous_ratio, clampf(left_hp / left_max, 0.0, 1.0), left_hp))
		if left_hp <= 0.0 and left_cleared == 0:
			left_cleared = 1
			_change_joe_high(-3.0, true)
			_show_toast("PARED IZQUIERDA AGOTADA")
	else:
		if right_hp <= 0.0: return
		var previous_ratio := clampf(right_hp / right_max, 0.0, 1.0)
		right_hp = maxf(0.0, right_hp - amount)
		_update_world()
		right_hp = maxf(0.0, right_hp - _wall_damage_feedback(side, previous_ratio, clampf(right_hp / right_max, 0.0, 1.0), right_hp))
		if right_hp <= 0.0 and right_cleared == 0:
			right_cleared = 1
			_change_joe_high(-3.0, true)
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
			var chip := _make_powder_flake(Color("e8edf0"), randf_range(1.6, 3.4))
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
	# Esta puerta manual debe quedar siempre delante del montón y las unidades.
	chunk.z_as_relative = false
	chunk.z_index = 90 + slot
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
	if septum_open or current_phase < TUNNEL_UNLOCK_PHASE: return
	septum_open = true
	active_side = "left"
	camera_goal = maxf(0.0, SEPTUM_X - _visible_world_width() * 0.72)
	_update_world()
	_rebuild_pawns()
	_rebuild_punchers()
	_rebuild_infrastructure()
	_rebuild_transporters()
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
	break_button.visible = not septum_open and current_phase >= TUNNEL_UNLOCK_PHASE
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
	box.position.x = _box_x() - box.size.x * 0.35 if int(levels.get("fossa_depth", 0)) > 0 else BASE_BOX_LEFT
	box.pivot_offset = Vector2(box.size.x * 0.5, box.size.y)
	# Antes de comprar almacenamiento solo hay un cajón diminuto de 500 unidades.
	box.scale = Vector2.ONE * (0.72 if _storage_tier() == 0 else 1.0)
	box.modulate = Color("5e3428").lerp(Color("8c5130"), sin(Time.get_ticks_msec() * 0.012) * 0.5 + 0.5) if box_jammed else Color.WHITE.lerp(Color("ad7f43"), contamination / 100.0)
	box.rotation = sin(Time.get_ticks_msec() * 0.025) * 0.012 if box_jammed else 0.0
	_update_storage_visual()

func _rebuild_pawns() -> void:
	for child in pawns.get_children(): child.queue_free()
	for piece in loose_chunks:
		if is_instance_valid(piece) and bool(piece.get_meta("carried", false)):
			_set_piece_carried(piece, false)
			piece.visible = true
			piece.position = _landing_position(piece)
			piece.scale = Vector2.ONE * float(piece.get_meta("base_scale", 0.07))
	_rebuild_pile_index()
	_restack_pile()
	# La partida comienza sin ayudantes. Cada rama compra sus propias unidades;
	# ninguna adaptación sustituye silenciosamente un peón ya pagado.
	var count: int = mini(int(levels.pawn) + int(levels.breaker) + int(levels.detector) + int(levels.handlers), 26)
	var handler_count := mini(int(levels.handlers), count)
	var detector_count := mini(int(levels.detector), count - handler_count)
	var specialist_count := mini(int(levels.breaker), count - handler_count - detector_count)
	for index in range(count):
		var pawn := Sprite2D.new()
		pawn.scale = Vector2(0.047, 0.047)
		pawn.z_index = 8 + index % 3
		pawn.set_meta("index", index)
		pawn.set_meta("lane_x", float(index % 5 - 2) * 7.0)
		var handler := handler_count > 0 and index >= count - handler_count
		var detector := not handler and detector_count > 0 and index >= count - handler_count - detector_count
		var specialist := not handler and not detector and index < specialist_count
		pawn.set_meta("handler", handler)
		pawn.set_meta("detector", detector)
		pawn.set_meta("specialist", specialist)
		pawn.modulate = Color.WHITE
		if not handler and not detector and not specialist and int(levels.get("pawn_renaissance", 0)) > 0:
			var compact_badge := Polygon2D.new()
			compact_badge.name = "CompactionRenaissance"
			compact_badge.polygon = PackedVector2Array([Vector2(-58, 55), Vector2(0, 22), Vector2(58, 55), Vector2(42, 112), Vector2(-42, 112)])
			compact_badge.color = Color("f2c94c") if int(levels.pawn_renaissance) == 1 else Color("71e2e8")
			compact_badge.z_index = 4
			pawn.add_child(compact_badge)
		_set_pawn_carrying(pawn, false)
		pawn.set_meta("state", "to_pile")
		pawn.set_meta("cargo", [])
		pawn.set_meta("side", _choose_work_side(index))
		pawn.position = Vector2(_box_x() - float(index) * 18.0, _ground_y() - 14.0)
		pawns.add_child(pawn)

func _rebuild_punchers() -> void:
	for child in punchers.get_children():
		child.queue_free()
	for index in range(_puncher_count()):
		var rank := clampi(int(levels.punch_power), 0, PUGILIST_DAMAGE.size() - 1)
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
		glove.color = [Color("f05261"), Color("f58b45"), Color("9d63d5"), Color("ffd447")][rank]
		glove.scale = Vector2.ONE * [1.0, 1.08, 1.18, 1.32][rank]
		glove.z_index = 2
		puncher.add_child(glove)
		var headband := Polygon2D.new()
		headband.name = "AutoHeadband"
		headband.polygon = PackedVector2Array([Vector2(-150, -218), Vector2(136, -218), Vector2(158, -180), Vector2(-164, -180)])
		headband.color = [Color("51c8e8"), Color("f2d06b"), Color("ef5b57"), Color("fff1c7")][rank]
		headband.z_index = 2
		puncher.add_child(headband)
		if int(levels.get("punch_training", 0)) > 0:
			var wrist_wrap := Polygon2D.new()
			wrist_wrap.name = "ProteinWrap"
			wrist_wrap.polygon = PackedVector2Array([Vector2(-202, 104), Vector2(-158, 93), Vector2(-149, 126), Vector2(-194, 139)])
			wrist_wrap.color = Color("64d6d0")
			wrist_wrap.z_index = 3
			puncher.add_child(wrist_wrap)
		if int(levels.get("punch_collective", 0)) > 0:
			var union_pin := Polygon2D.new()
			union_pin.name = "UnionPin"
			union_pin.polygon = PackedVector2Array([Vector2(112, -168), Vector2(148, -150), Vector2(140, -110), Vector2(100, -118)])
			union_pin.color = Color("77d7f0")
			union_pin.z_index = 3
			puncher.add_child(union_pin)
		if int(levels.get("bronchial_rage", 0)) > 0:
			var rage_patch := Polygon2D.new()
			rage_patch.name = "BronchialPatch"
			rage_patch.polygon = PackedVector2Array([Vector2(72, -164), Vector2(142, -148), Vector2(130, -82), Vector2(62, -94)])
			rage_patch.color = Color("dd5b9b")
			rage_patch.z_index = 3
			puncher.add_child(rage_patch)
		if int(levels.get("punch_combo", 0)) > 0:
			var combo_mark := Polygon2D.new()
			combo_mark.name = "ComboMark"
			combo_mark.polygon = PackedVector2Array([Vector2(-54, -230), Vector2(-12, -268), Vector2(30, -230), Vector2(-12, -205)])
			combo_mark.color = Color("ffd447")
			combo_mark.z_index = 3
			puncher.add_child(combo_mark)
		if int(levels.get("uranium_wraps", 0)) > 0:
			var uranium_wrap := Polygon2D.new()
			uranium_wrap.name = "UraniumWrap"
			uranium_wrap.polygon = PackedVector2Array([Vector2(-218, 72), Vector2(-163, 66), Vector2(-149, 126), Vector2(-204, 139)])
			uranium_wrap.color = Color("a9f05e")
			uranium_wrap.z_index = 4
			puncher.add_child(uranium_wrap)
		if rank >= 1:
			var belt := Polygon2D.new()
			belt.name = "RankBelt"
			belt.polygon = PackedVector2Array([Vector2(-170, 100), Vector2(170, 100), Vector2(155, 148), Vector2(-155, 148)])
			belt.color = Color("e8c96f") if rank < 3 else Color("fff1a8")
			belt.z_index = 2
			puncher.add_child(belt)
		if rank >= 2:
			var badge := Polygon2D.new()
			badge.name = "RankBadge"
			badge.polygon = PackedVector2Array([Vector2(0, 104), Vector2(32, 124), Vector2(0, 147), Vector2(-32, 124)])
			badge.color = Color("472042")
			badge.z_index = 3
			puncher.add_child(badge)
		if rank >= 3:
			var aura := Line2D.new()
			aura.name = "ChampionAura"
			aura.points = PackedVector2Array([Vector2(-205, 100), Vector2(-245, 10), Vector2(-205, -80), Vector2(-105, -255), Vector2(0, -290), Vector2(115, -250), Vector2(205, -75), Vector2(245, 20), Vector2(205, 110)])
			aura.width = 24.0
			aura.default_color = Color("ffd447", 0.82)
			aura.z_index = -1
			puncher.add_child(aura)
		var renaissance := int(levels.get("punch_renaissance", 0))
		if renaissance > 0:
			var pension_aura := Line2D.new()
			pension_aura.name = "PensionAura"
			pension_aura.points = PackedVector2Array([Vector2(-226, 96), Vector2(-260, -42), Vector2(-148, -258), Vector2(0, -304), Vector2(150, -258), Vector2(260, -42), Vector2(226, 96)])
			pension_aura.width = 32.0 if renaissance == 1 else 48.0
			pension_aura.default_color = Color("7fe6ee", 0.78) if renaissance == 1 else Color("ff77d4", 0.88)
			pension_aura.z_index = -2
			puncher.add_child(pension_aura)
		punchers.add_child(puncher)
		_place_puncher(puncher)
	_add_special_extractors()

func _place_puncher(puncher: Sprite2D) -> void:
	var side: String = puncher.get_meta("side", active_side)
	_set_puncher_facing(puncher, side == "left")
	puncher.position = _puncher_home_position(puncher)
	puncher.rotation = 0.0
	puncher.set_meta("state", "idle")
	puncher.set_meta("strike_target", Vector2.ZERO)
	puncher.set_meta("home_target", puncher.position)

func _set_puncher_facing(puncher: Sprite2D, faces_right: bool) -> void:
	_set_pawn_facing(puncher, faces_right)
	for layer_name in ["BoxingGlove", "ProteinWrap", "UnionPin", "BronchialPatch", "UraniumWrap"]:
		var directional_layer := puncher.get_node_or_null(layer_name) as Polygon2D
		if directional_layer:
			var width := absf(directional_layer.scale.x)
			directional_layer.scale.x = -width if faces_right else width

func _wall_free_x(side: String) -> float:
	var visual := left_visual if side == "left" else right_visual
	var button := left_button if side == "left" else right_button
	return button.position.x + (visual.size.x * (1.0 - visual.scale.x) if side == "left" else visual.size.x * visual.scale.x)

func _pile_outer_x(side: String) -> float:
	var outer_column := -2 if side == "left" else 2
	for column_value in (pile_columns[side] as Dictionary).keys():
		var column := int(column_value)
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
	var rank := clampi(int(levels.punch_power), 0, PUGILIST_INTERVALS.size() - 1)
	var result := float(PUGILIST_INTERVALS[rank]) * (0.625 if int(levels.punch_speed) > 0 else 1.0)
	if int(levels.get("uranium_wraps", 0)) > 0: result *= 0.75
	return result

func _punch_output() -> int:
	var output := float(PUGILIST_DAMAGE[clampi(int(levels.punch_power), 0, PUGILIST_DAMAGE.size() - 1)])
	if int(levels.get("punch_training", 0)) > 0: output *= 3.0
	if int(levels.get("bronchial_rage", 0)) > 0: output *= 2.0
	if int(levels.get("punch_collective", 0)) > 0: output *= 3.0
	output *= float(PUNCH_RENAISSANCE_MULTIPLIERS[clampi(int(levels.get("punch_renaissance", 0)), 0, PUNCH_RENAISSANCE_MULTIPLIERS.size() - 1)])
	return roundi(output)

func _puncher_count() -> int:
	return mini(8, int(levels.puncher) + (2 if int(levels.punch_union) > 0 else 0) + (2 if int(levels.get("punch_reserves", 0)) > 0 else 0))

func _punch_evolution_locked() -> bool:
	# El púgil base pertenece a la fase 1. Cada descenso posterior del colocón
	# autoriza exactamente una evolución adicional de toda la cuadrilla.
	var allowed_level := clampi(current_phase - 1, 0, PUGILIST_DAMAGE.size() - 1)
	return int(levels.punch_power) >= allowed_level

func _wall_mining_blocked() -> bool:
	return mucus_hp > 0.0 or spray_film_hp > 0.0

func _auto_hit_rate() -> float:
	if _puncher_count() == 0 or box_jammed or _wall_mining_blocked() or _nearest_fallen_wall_chunk(active_side):
		return 0.0
	var combo_average := 4.0 / 3.0 if int(levels.get("punch_combo", 0)) > 0 else 1.0
	return float(_puncher_count()) * float(_punch_output()) * combo_average / _punch_interval()

func _update_punchers(delta: float) -> void:
	if _puncher_count() == 0:
		return
	if box_jammed:
		return
	if _wall_mining_blocked() or _nearest_fallen_wall_chunk(active_side):
		_recall_punchers(delta)
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

func _recall_punchers(delta: float) -> void:
	for node in punchers.get_children():
		var puncher := node as Sprite2D
		if not puncher:
			continue
		var state: String = puncher.get_meta("state", "idle")
		if state != "idle" and state != "returning":
			puncher.rotation = 0.0
			puncher.set_meta("home_target", _puncher_home_position(puncher))
			puncher.set_meta("state", "returning")
	_update_puncher_motion(delta)
	punch_clock = maxf(punch_clock, 0.35)

func _perform_punch_round(debut: bool) -> void:
	punch_round_count += 1
	var combo_round := int(levels.get("punch_combo", 0)) > 0 and punch_round_count % 3 == 0
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
		puncher.set_meta("combo_round", combo_round)
		puncher.set_meta("strike_target", _puncher_strike_position(puncher))
		puncher.set_meta("state", "to_wall")

func _punchers_idle() -> bool:
	for node in punchers.get_children():
		if node is Sprite2D and node.get_meta("state", "idle") != "idle":
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
			var home := _puncher_home_position(puncher)
			if puncher.position.distance_to(home) > 0.5:
				_set_puncher_facing(puncher, home.x > puncher.position.x)
			puncher.position = puncher.position.move_toward(home, speed * delta)
			puncher.rotation = move_toward(puncher.rotation, 0.0, delta * 0.8)
		elif state == "to_wall":
			var strike: Vector2 = puncher.get_meta("strike_target", _puncher_strike_position(puncher))
			_set_puncher_facing(puncher, strike.x > puncher.position.x)
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
				puncher.set_meta("home_target", _puncher_home_position(puncher))
				puncher.set_meta("state", "returning")
		elif state == "returning":
			var home: Vector2 = puncher.get_meta("home_target", _puncher_home_position(puncher))
			_set_puncher_facing(puncher, home.x > puncher.position.x)
			puncher.position = puncher.position.move_toward(home, speed * delta)
			if puncher.position.distance_to(home) < 0.5:
				puncher.position = home
				_set_puncher_facing(puncher, puncher.get_meta("side", active_side) == "left")
				puncher.set_meta("state", "idle")
		else:
			_place_puncher(puncher)

func _resolve_punch(puncher: Sprite2D) -> void:
	var side: String = puncher.get_meta("side", active_side)
	if _wall_hp(side) <= 0.0:
		return
	var debut := bool(puncher.get_meta("debut", false))
	var combo_round := bool(puncher.get_meta("combo_round", false))
	var output := mini(_punch_output() * (2 if combo_round else 1), mini(ceili(_wall_hp(side)), ceili(_fossa_free_space(side))))
	if output <= 0:
		_show_fossa_saturated(side)
		return
	_damage_wall(float(output), side)
	total_clicks += output
	var direction := -1.0 if side == "left" else 1.0
	var impact_x := _wall_free_x(side) + direction * 4.0
	_spawn_extraction_payload(side, float(output), impact_x, PUGILIST_GRAINS_PER_HIT)
	_spawn_impact_dust(Vector2(impact_x, _ground_y() - 10.0), Color("d6b8bc"), 14 if debut else 4)
	if debut:
		_spawn_debut_powder_burst(side, Vector2(impact_x, _ground_y() - 18.0), 1.0)
		unit_debuts_seen["pugilist"] = true
	_impact_shake(5.5 if debut else (3.0 if combo_round else 1.6))
	_play_sfx(SFX_PUNCH, -7.0 if combo_round else -9.0, randf_range(0.86, 1.08))
	var impact_label := "¡¡COMBO!!  -" if combo_round else ("¡¡PUM!!  -" if debut else "¡PUM!  -")
	_float_text(impact_label + _number(output), Vector2(impact_x, _ground_y() - 95.0))
	if debut:
		_show_toast("DEBUT DEL PÚGIL  ·  ESO SÍ HA SIDO UN PUÑETAZO")
	puncher.set_meta("debut", false)
	_update_world()

func _add_special_extractors() -> void:
	if int(levels.ram) > 0:
		_add_special_extractor("ram", RAM_TEXTURE, 0.07, _special_extractor_interval("ram"))
	if int(levels.elephant) > 0:
		_add_special_extractor("elephant", ELEPHANT_TEXTURE, 0.115, ELEPHANT_INTERVAL)
	if int(levels.hammer) > 0:
		_add_special_extractor("hammer", HAMMER_TEXTURE, 0.065, HAMMER_INTERVAL)
	if int(levels.plasma_cannon) > 0:
		_add_special_extractor("plasma", PLASMA_CANNON_TEXTURE, 0.08, CANNON_INTERVAL)
	if int(levels.meteor) > 0:
		_add_special_extractor("meteor", METEOR_TEXTURE, 0.075, METEOR_INTERVAL)
	if int(levels.supersaiyan) > 0:
		_add_special_extractor("supersaiyan", SUPERSAIYAN_TEXTURE, 0.09, SUPERSAIYAN_INTERVAL)

func _add_special_extractor(kind: String, texture: Texture2D, scale_factor: float, interval: float) -> void:
	var root := Node2D.new()
	root.name = kind.capitalize()
	root.set_meta("extraction_kind", kind)
	root.set_meta("state", "idle")
	root.set_meta("timer", minf(3.0, interval * 0.2))
	root.set_meta("step_clock", 0.0)
	root.set_meta("side", active_side)
	var sprite := Sprite2D.new()
	sprite.name = "Sprite"
	sprite.texture = texture
	sprite.scale = Vector2.ONE * scale_factor
	sprite.z_index = 5
	root.add_child(sprite)
	punchers.add_child(root)
	_place_special_extractor(root)

func _special_home_position(kind: String, side: String) -> Vector2:
	var direction := -1.0 if side == "left" else 1.0
	# Las unidades pesadas ocupan carriles propios; el salto tras Leucofante
	# evita que Leucomartillo nazca visualmente dentro del almacén inicial.
	var distances := {"ram":220.0, "elephant":360.0, "hammer":600.0, "plasma":760.0, "meteor":930.0, "supersaiyan":1110.0}
	var distance := float(distances.get(kind, 640.0))
	return Vector2(_pile_outer_x(side) + direction * distance, _ground_y())

func _place_special_extractor(root: Node2D) -> void:
	var kind: String = root.get_meta("extraction_kind", "")
	var side: String = root.get_meta("side", active_side)
	root.position = _special_home_position(kind, side)
	root.rotation = 0.0
	var sprite := root.get_node_or_null("Sprite") as Sprite2D
	if sprite:
		sprite.flip_h = side == "left"
		_anchor_special_sprite(kind, sprite)

func _anchor_special_sprite(kind: String, sprite: Sprite2D, bob: float = 0.0) -> void:
	var foot_pixels := float(SPECIAL_SPRITE_FOOT_PIXELS.get(kind, 0.0))
	sprite.position.y = -foot_pixels * sprite.scale.y + bob

func _special_extractor_interval(kind: String) -> float:
	if kind == "ram": return RAM_INTERVAL * (0.75 if int(levels.ram_speed) > 0 else 1.0)
	if kind == "elephant": return ELEPHANT_INTERVAL
	if kind == "hammer": return HAMMER_INTERVAL
	if kind == "plasma": return CANNON_INTERVAL
	if kind == "meteor": return METEOR_INTERVAL
	return SUPERSAIYAN_INTERVAL

func _special_extractor_damage(kind: String) -> float:
	if kind == "ram": return float(RAM_DAMAGE[clampi(int(levels.ram_power), 0, RAM_DAMAGE.size() - 1)])
	if kind == "elephant": return float(ELEPHANT_DAMAGE[clampi(int(levels.elephant_power), 0, ELEPHANT_DAMAGE.size() - 1)])
	if kind == "hammer": return float(HAMMER_DAMAGE[clampi(int(levels.hammer_power), 0, HAMMER_DAMAGE.size() - 1)])
	if kind == "plasma": return float(PLASMA_DAMAGE[clampi(int(levels.plasma_power), 0, PLASMA_DAMAGE.size() - 1)])
	if kind == "meteor": return float(METEOR_DAMAGE[clampi(int(levels.meteor_power), 0, METEOR_DAMAGE.size() - 1)])
	return float(SUPERSAIYAN_DAMAGE[clampi(int(levels.supersaiyan_power), 0, SUPERSAIYAN_DAMAGE.size() - 1)])

func _special_extraction_rate(theoretical: bool = false) -> float:
	if not theoretical and (box_jammed or _wall_mining_blocked() or _nearest_fallen_wall_chunk(active_side)):
		return 0.0
	var result := 0.0
	if int(levels.ram) > 0: result += _special_extractor_damage("ram") / _special_extractor_interval("ram")
	if int(levels.elephant) > 0: result += _special_extractor_damage("elephant") / ELEPHANT_INTERVAL
	if int(levels.hammer) > 0: result += _special_extractor_damage("hammer") / HAMMER_INTERVAL
	if int(levels.plasma_cannon) > 0: result += _special_extractor_damage("plasma") / CANNON_INTERVAL
	if int(levels.meteor) > 0: result += _special_extractor_damage("meteor") / METEOR_INTERVAL
	if int(levels.supersaiyan) > 0: result += _special_extractor_damage("supersaiyan") / SUPERSAIYAN_INTERVAL
	return result

func _update_special_extractors(delta: float) -> void:
	for child in punchers.get_children():
		if not child is Node2D or str(child.get_meta("extraction_kind", "")).is_empty(): continue
		var root := child as Node2D
		var kind: String = root.get_meta("extraction_kind", "")
		var state: String = root.get_meta("state", "idle")
		if state == "idle" and root.get_meta("side", active_side) != active_side:
			root.set_meta("side", active_side)
			_place_special_extractor(root)
		var sprite := root.get_node_or_null("Sprite") as Sprite2D
		if not sprite: continue
		var blocked := box_jammed or _wall_mining_blocked() or _nearest_fallen_wall_chunk(active_side)
		if kind in ["ram", "elephant", "hammer"]:
			_update_charge_extractor(root, sprite, delta, blocked)
		elif kind == "meteor":
			_update_meteor_extractor(root, sprite, delta, blocked)
		else:
			root.position = _special_home_position(kind, str(root.get_meta("side", active_side)))
			var timer := float(root.get_meta("timer", 0.0))
			if not blocked: timer -= delta
			root.set_meta("timer", timer)
			if kind == "supersaiyan":
				var charge := clampf(1.0 - timer / 3.0, 0.0, 1.0)
				sprite.modulate = Color.WHITE.lerp(Color("fff39a"), charge * (0.45 + sin(Time.get_ticks_msec() * 0.02) * 0.12))
				sprite.scale = Vector2.ONE * 0.09 * (1.0 + charge * 0.08)
			_anchor_special_sprite(kind, sprite)
			if timer <= 0.0 and not blocked:
				root.set_meta("timer", _special_extractor_interval(kind))
				if kind == "plasma": _fire_plasma_cannon(root)
				else: _fire_supersaiyan(root)

func _update_charge_extractor(root: Node2D, sprite: Sprite2D, delta: float, blocked: bool) -> void:
	var state: String = root.get_meta("state", "idle")
	var kind: String = root.get_meta("extraction_kind", "elephant")
	var side: String = root.get_meta("side", active_side)
	var direction := -1.0 if side == "left" else 1.0
	var home := _special_home_position(kind, side)
	var strike_distance := 52.0 if kind == "ram" else (76.0 if kind == "elephant" else 104.0)
	var strike := Vector2(_wall_free_x(side) + direction * strike_distance, _ground_y())
	var base_scale := 0.07 if kind == "ram" else (0.115 if kind == "elephant" else 0.065)
	var attack_speed := 150.0 if kind == "ram" else (82.0 if kind == "elephant" else 220.0)
	var return_speed := 180.0 if kind == "ram" else (105.0 if kind == "elephant" else 240.0)
	if state == "idle":
		root.position = home
		_anchor_special_sprite(kind, sprite)
		var timer := float(root.get_meta("timer", 0.0))
		if not blocked: timer -= delta
		root.set_meta("timer", timer)
		if timer <= 0.0 and not blocked:
			root.set_meta("state", "winding" if kind == "ram" else "to_wall")
	elif state == "winding":
		if blocked: return
		var windup := home + Vector2(direction * 42.0, 0.0)
		sprite.flip_h = windup.x > root.position.x
		root.position = root.position.move_toward(windup, 72.0 * delta)
		_anchor_special_sprite(kind, sprite, -absf(sin(Time.get_ticks_msec() * 0.026)) * 2.0)
		if root.position.distance_to(windup) < 1.0:
			root.position = windup
			root.set_meta("state", "to_wall")
	elif state == "to_wall":
		if blocked: return
		sprite.flip_h = strike.x > root.position.x
		root.position = root.position.move_toward(strike, attack_speed * delta)
		var gait := Time.get_ticks_msec() * 0.025
		sprite.rotation = sin(gait) * 0.025
		var bounce := -2.0 if kind == "ram" else (-3.0 if kind == "elephant" else -7.0)
		_anchor_special_sprite(kind, sprite, absf(sin(gait)) * bounce)
		var step_clock := float(root.get_meta("step_clock", 0.0)) - delta
		if step_clock <= 0.0:
			step_clock = 0.34
			_spawn_impact_dust(root.position + Vector2(-direction * 28.0, -2.0), Color("75464d"), 2)
		root.set_meta("step_clock", step_clock)
		if root.position.distance_to(strike) < 1.0:
			root.position = strike
			root.set_meta("state", "impact")
			root.set_meta("timer", 0.42 if kind == "hammer" else 0.55)
			_special_extraction_hit(kind, root.position)
			_anchor_special_sprite(kind, sprite)
			var impact_tween := create_tween()
			impact_tween.tween_property(sprite, "scale", Vector2(base_scale * 1.13, base_scale * 0.84), 0.10).set_trans(Tween.TRANS_BACK)
			impact_tween.tween_property(sprite, "scale", Vector2.ONE * base_scale, 0.24)
	elif state == "impact":
		_anchor_special_sprite(kind, sprite)
		var timer := float(root.get_meta("timer", 0.0)) - delta
		root.set_meta("timer", timer)
		if timer <= 0.0: root.set_meta("state", "returning")
	elif state == "returning":
		sprite.flip_h = home.x > root.position.x
		root.position = root.position.move_toward(home, return_speed * delta)
		sprite.rotation = sin(Time.get_ticks_msec() * 0.021) * 0.018
		_anchor_special_sprite(kind, sprite, absf(sin(Time.get_ticks_msec() * 0.021)) * -2.0)
		if root.position.distance_to(home) < 1.0:
			root.position = home
			sprite.rotation = 0.0
			sprite.flip_h = side == "left"
			root.set_meta("state", "idle")
			root.set_meta("timer", _special_extractor_interval(kind))

func _arc_position(start: Vector2, finish: Vector2, progress: float, lift: float) -> Vector2:
	var control := (start + finish) * 0.5 - Vector2(0.0, lift)
	var inverse := 1.0 - progress
	return start * inverse * inverse + control * 2.0 * inverse * progress + finish * progress * progress

func _update_meteor_extractor(root: Node2D, sprite: Sprite2D, delta: float, blocked: bool) -> void:
	var state: String = root.get_meta("state", "idle")
	var side: String = root.get_meta("side", active_side)
	var direction := -1.0 if side == "left" else 1.0
	var home := _special_home_position("meteor", side)
	var target := Vector2(_wall_free_x(side) + direction * 92.0, _ground_y() - 24.0)
	if state == "idle":
		root.position = home
		sprite.flip_h = side == "left"
		sprite.rotation = 0.0
		_anchor_special_sprite("meteor", sprite, -absf(sin(Time.get_ticks_msec() * 0.008)) * 3.0)
		var timer := float(root.get_meta("timer", 0.0))
		if not blocked:
			timer -= delta
		root.set_meta("timer", timer)
		if timer <= 0.0 and not blocked:
			root.set_meta("state", "launching")
			root.set_meta("flight", 0.0)
			_play_sfx(SFX_CANNON, -9.0, 1.35)
	elif state == "launching":
		var progress := minf(1.0, float(root.get_meta("flight", 0.0)) + delta / 0.86)
		root.set_meta("flight", progress)
		root.position = _arc_position(home, target, progress, 150.0)
		sprite.rotation = sin(progress * PI) * (-0.12 * direction)
		sprite.scale = Vector2.ONE * 0.075 * (1.0 + sin(progress * PI) * 0.08)
		_anchor_special_sprite("meteor", sprite)
		if progress >= 1.0:
			root.position = target
			root.set_meta("state", "impact")
			root.set_meta("timer", 0.26)
			_special_extraction_hit("meteor", root.position)
	elif state == "impact":
		var timer := float(root.get_meta("timer", 0.0)) - delta
		root.set_meta("timer", timer)
		sprite.scale = Vector2.ONE * 0.075 * (0.82 + maxf(0.0, timer) * 0.7)
		_anchor_special_sprite("meteor", sprite)
		if timer <= 0.0:
			root.set_meta("state", "returning")
			root.set_meta("flight", 0.0)
			sprite.flip_h = side == "right"
	elif state == "returning":
		var progress := minf(1.0, float(root.get_meta("flight", 0.0)) + delta / 1.22)
		root.set_meta("flight", progress)
		root.position = _arc_position(target, home, progress, 215.0)
		sprite.rotation = sin(progress * PI) * (0.08 * direction)
		sprite.scale = Vector2.ONE * 0.075
		_anchor_special_sprite("meteor", sprite)
		if progress >= 1.0:
			root.set_meta("state", "idle")
			root.set_meta("timer", METEOR_INTERVAL)
			_place_special_extractor(root)
	else:
		root.set_meta("state", "idle")
		root.set_meta("timer", METEOR_INTERVAL)
		_place_special_extractor(root)

func _plasma_disc(radius: float, points := 12) -> PackedVector2Array:
	var polygon := PackedVector2Array()
	for index in range(points):
		var angle := TAU * float(index) / float(points)
		polygon.append(Vector2(cos(angle), sin(angle)) * radius)
	return polygon

func _fire_plasma_cannon(root: Node2D) -> void:
	var side: String = root.get_meta("side", active_side)
	var projectile := Node2D.new()
	projectile.name = "PlasmaOrb"
	projectile.position = root.position + Vector2(-58.0 if side == "right" else 58.0, -52.0)
	var outer := Polygon2D.new()
	outer.name = "OuterGlow"
	outer.polygon = _plasma_disc(19.0, 14)
	outer.color = Color("27cfe5", 0.84)
	projectile.add_child(outer)
	var core := Polygon2D.new()
	core.name = "Core"
	core.polygon = _plasma_disc(10.0, 12)
	core.color = Color("e9ffff")
	core.z_index = 2
	projectile.add_child(core)
	var trail := Line2D.new()
	trail.points = PackedVector2Array([Vector2(90.0 if side == "right" else -90.0, 0.0), Vector2.ZERO])
	trail.width = 16.0
	trail.default_color = Color("3c8cff", 0.68)
	trail.z_index = -1
	projectile.add_child(trail)
	effects.add_child(projectile)
	_spawn_energy_ring(projectile.position, Color("53efff"), 14.0)
	_play_sfx(SFX_CANNON, -5.0)
	_spawn_impact_dust(root.position + Vector2(0.0, -5.0), Color("397ca3"), 6)
	var recoil := create_tween()
	recoil.tween_property(root, "scale", Vector2(1.14, 0.88), 0.08).set_trans(Tween.TRANS_BACK)
	recoil.tween_property(root, "scale", Vector2.ONE, 0.22).set_trans(Tween.TRANS_ELASTIC)
	var target := Vector2(_wall_free_x(side), _ground_y() - 70.0)
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(projectile, "position", target, 0.48).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(projectile, "scale", Vector2.ONE * 1.35, 0.48)
	tween.chain().tween_callback(_finish_plasma_shot.bind(projectile, root.position))

func _finish_plasma_shot(projectile: Node2D, origin: Vector2) -> void:
	if is_instance_valid(projectile): projectile.queue_free()
	_special_extraction_hit("plasma", origin)

func _fire_supersaiyan(root: Node2D) -> void:
	var side: String = root.get_meta("side", active_side)
	var beam := Line2D.new()
	beam.width = 28.0
	beam.default_color = Color("8bf4ff")
	beam.points = PackedVector2Array([root.position + Vector2(-45.0 if side == "right" else 45.0, -65.0), Vector2(_wall_free_x(side), _ground_y() - 65.0)])
	beam.z_index = 20
	effects.add_child(beam)
	var inner := Line2D.new()
	inner.width = 9.0
	inner.default_color = Color.WHITE
	inner.points = beam.points
	inner.z_index = 21
	effects.add_child(inner)
	_spawn_energy_ring(root.position + Vector2(0.0, -62.0), Color("8bf4ff"), 18.0)
	_spawn_energy_ring(root.position + Vector2(0.0, -62.0), Color("fff39a"), 11.0)
	_play_sfx(SFX_KAMEHAMEHA, -3.0)
	_special_extraction_hit("supersaiyan", root.position)
	var tween := create_tween().set_parallel()
	tween.tween_property(beam, "modulate:a", 0.0, 0.55)
	tween.tween_property(inner, "modulate:a", 0.0, 0.55)
	tween.chain().tween_callback(beam.queue_free)
	tween.chain().tween_callback(inner.queue_free)

func _special_extraction_hit(kind: String, origin: Vector2) -> void:
	var side := "left" if origin.x < SEPTUM_X else "right"
	if _wall_hp(side) <= 0.0: return
	var debut := bool(unit_debut_pending.get(kind, false))
	if debut:
		unit_debut_pending.erase(kind)
		unit_debuts_seen[kind] = true
	var damage := minf(_special_extractor_damage(kind), minf(_wall_hp(side), _fossa_free_space(side)))
	if damage <= 0.0:
		_show_fossa_saturated(side)
		return
	_damage_wall(damage, side)
	total_clicks += roundi(damage)
	var impact_x := _wall_free_x(side)
	_spawn_extraction_payload(side, damage, impact_x, 24)
	var dust_color := Color("64d9ed") if kind in ["plasma", "meteor"] else (Color("e5b94d") if kind == "hammer" else Color("eef4e7"))
	_spawn_impact_dust(Vector2(impact_x, _ground_y() - 8.0), dust_color, (26 if debut else (14 if kind in ["ram", "elephant", "hammer", "meteor"] else 10)))
	if debut:
		var debut_intensity := {"ram":1.25, "elephant":1.65, "hammer":1.85, "plasma":2.1, "meteor":2.35, "supersaiyan":2.6}
		_spawn_debut_powder_burst(side, Vector2(impact_x, _ground_y() - 20.0), float(debut_intensity.get(kind, 1.4)))
	if kind == "ram":
		_play_sfx(SFX_PUNCH, -4.0, 0.76)
		_impact_shake(4.0)
	elif kind == "elephant":
		_play_sfx(SFX_ELEPHANT, -3.0)
		_impact_shake(8.0)
	elif kind == "hammer":
		_play_sfx(SFX_PUNCH, -2.0, 0.58)
		_impact_shake(6.0)
	elif kind == "plasma":
		_impact_shake(5.0)
	elif kind == "meteor":
		_play_sfx(SFX_CANNON, -2.0, 0.74)
		_impact_shake(10.0)
	else:
		_impact_shake(12.0)
	var titles := {"ram":"¡¡¡EMBESTIDA!!!", "elephant":"¡¡¡CABEZAZO!!!", "hammer":"¡¡¡MARTILLAZO!!!", "plasma":"¡¡PLASMA NASAL!!", "meteor":"¡¡¡IMPACTO METEORITO!!!", "supersaiyan":"¡¡¡KAMEHAMEHA LEUCOCITARIO!!!"}
	var title := str(titles.get(kind, "¡¡¡IMPACTO!!!"))
	_float_text("%s  -%s" % [title, _number(damage)], Vector2(impact_x, _ground_y() - 145.0))
	var impact_toast := "%s  ·  %s UNIDADES DE DAÑO" % [title, _number(damage)]
	_show_toast(("DEBUT  ·  " if debut else "") + impact_toast)
	_update_world()

func _queue_special_debut(kind: String) -> void:
	if bool(unit_debuts_seen.get(kind, false)):
		return
	unit_debut_pending[kind] = true
	var names := {"ram":"LEUCOCARNERO", "elephant":"LEUCOFANTE", "hammer":"LEUCOMARTILLO", "plasma":"CAÑÓN DE PLASMA", "meteor":"NEUTRÓFILO METEORITO", "supersaiyan":"LEUCOCITO SUPERSAIYAN"}
	_show_toast("%s  ·  PREPARANDO SU PRIMER GOLPE" % str(names.get(kind, "NUEVA UNIDAD")), 3.8)

func _spawn_extraction_payload(side: String, amount: float, impact_x: float, visuals: int) -> void:
	if amount <= 0.0: return
	var count := maxi(1, visuals)
	var value := amount / float(count)
	for index in range(count):
		_spawn_chunk(Vector2(impact_x + randf_range(-10.0, 10.0), _ground_y() - randf_range(185.0, 320.0)), value, side, 999, "player", true)

func _click_power() -> float:
	return _click_power_for(int(levels.nails))

func _click_power_for(level: int) -> float:
	return float(CLICK_POWER_TIERS[clampi(level, 0, CLICK_POWER_TIERS.size() - 1)])

func _rate() -> float:
	if box_jammed:
		return 0.0
	var distance := absf(_box_x() - _pile_center(active_side))
	var cycle := distance * 2.0 / maxf(1.0, _pawn_speed()) + 0.8 + _deposit_duration()
	var result := float(int(levels.pawn)) * float(_transport_capacity() * _smart_clump_size()) / cycle * _box_yield_multiplier()
	if int(levels.get("cart", 0)) > 0:
		result += _cart_capacity() / (distance * 2.0 / _ground_transport_speed(CART_SPEED) + 1.1)
	if int(levels.get("ox_convoy", 0)) > 0:
		result += _ox_capacity() / (distance * 2.0 / _ground_transport_speed(OX_SPEED) + 1.1)
	if int(levels.get("train", 0)) > 0 and septum_open:
		var available := _pile_load("left") + _pile_load("right")
		var surface_trip := (absf(PLANT_X + 165.0 - LEFT_TUNNEL_X) + absf(RIGHT_TUNNEL_X - _pile_center("right") - 106.0)) * 2.0 / _train_speed()
		result += minf(available, _storage_claim_space()) / (surface_trip + TRAIN_TUNNEL_TIME * 2.0 + 1.2)
	return result

func _emergency_detector_available(upgrade: Dictionary, level: int) -> bool:
	return str(upgrade.get("id", "")) == "detector" and level == 0 and box_jammed

func _upgrade_cost(upgrade: Dictionary, level: int) -> float:
	if _emergency_detector_available(upgrade, level):
		return 0.0
	return ceil(float(upgrade.base) * pow(float(upgrade.growth), level))

func _buy(id: String) -> void:
	var upgrade := _upgrade(id)
	if upgrade.is_empty() or not _upgrade_available(upgrade): return
	var level: int = int(levels[id])
	var emergency_detector := _emergency_detector_available(upgrade, level)
	var cost := _upgrade_cost(upgrade, level)
	if upgrade.kind == "auto_power" and _punch_evolution_locked(): return
	if cells < cost or level >= int(upgrade.get("max", 999)): return
	cells -= cost
	levels[id] = level + 1
	if upgrade.kind in ["pawn", "coordination", "specialist", "detector", "handler"]: _rebuild_pawns()
	elif upgrade.kind in ["smart_clump", "pawn_renaissance"]:
		_rebuild_pawns()
		_show_toast("APELMAZADO INTELIGENTE  ·  %d GRANOS POR BOLA DE CARGA" % _smart_clump_size())
	elif upgrade.kind == "speed":
		_rebuild_pawns()
		_show_toast("AUTOVÍA PEATONAL  ·  LOS PEONES ACELERAN UN 50%")
	elif upgrade.kind == "autoclicker":
		_rebuild_punchers()
		if level == 0 and not bool(unit_debuts_seen.get("pugilist", false)):
			puncher_debut_pending = true
			puncher_debut_clock = 1.35
			punch_clock = _punch_interval()
			_show_toast("EL NUEVO PÚGIL ESTÁ CALENTANDO EL BRAZO...")
	elif upgrade.kind in ["auto_power", "punch_training", "punch_multiplier", "punch_reserves", "punch_combo", "punch_late_speed", "punch_collective", "punch_renaissance"]:
		_rebuild_punchers()
		var punch_message := "LA CUADRILLA PÚGIL HA EVOLUCIONADO" if upgrade.kind == "auto_power" else "LA CUADRILLA PÚGIL SE HA PUESTO SERIA"
		if upgrade.kind == "punch_reserves": punch_message = "DOS BECARIOS PÚGILES SE INCORPORAN AL TURNO"
		elif upgrade.kind == "punch_combo": punch_message = "COMBO APRENDIDO  ·  CADA TERCERA RONDA PEGA DOBLE"
		elif upgrade.kind == "punch_late_speed": punch_message = "VENDAS DE URANIO  ·  DESCANSO REDUCIDO UN 25%"
		_show_toast(punch_message)
	elif upgrade.kind == "punch_union":
		_rebuild_punchers()
		_show_toast("SINDICATO DEL PUÑO  ·  +2 PÚGILES")
	elif upgrade.kind == "storage":
		_rebuild_infrastructure()
		_rebuild_transporters()
		_rebuild_pawns()
	elif upgrade.kind in ["fossa_depth", "fossa_compression"]:
		_rebuild_infrastructure()
		_rebuild_transporters()
		_rebuild_pawns()
		_rebuild_adaptations()
		var fossa_message := "FOSA SUBMUCOSA ABIERTA  ·  CABEN 600K DE NIEVE" if upgrade.kind == "fossa_depth" else "PRENSA DEL SUMIDERO  ·  ESPACIO TOTAL %s" % _number(_fossa_capacity(active_side))
		_show_toast(fossa_message, 5.0)
	elif upgrade.kind in ["transport_cart", "transport_capacity", "transport_ox", "transport_ox_capacity", "transport_speed", "transport_train", "train_speed", "cart_renaissance"]:
		_rebuild_transporters()
	elif upgrade.kind == "platelet": _rebuild_platelets()
	elif upgrade.kind in ["ram", "ram_power", "ram_speed", "elephant", "elephant_power", "hammer", "hammer_power", "plasma_cannon", "plasma_power", "meteor", "meteor_power", "supersaiyan", "supersaiyan_power"]:
		_rebuild_punchers()
		if level == 0:
			var debut_kind := {"ram":"ram", "elephant":"elephant", "hammer":"hammer", "plasma_cannon":"plasma", "meteor":"meteor", "supersaiyan":"supersaiyan"}
			if debut_kind.has(str(upgrade.kind)):
				_queue_special_debut(str(debut_kind[upgrade.kind]))
	elif upgrade.kind in ["sponge", "sponge_power", "catapult", "catapult_power"]: _rebuild_adaptations()
	if emergency_detector:
		contamination = minf(contamination, 85.0)
		contamination_band = int(contamination / 25.0)
		box_jammed = false
		_update_box()
		_show_toast("QUIMIORRECEPTOR DE URGENCIAS  ·  LA CAJA VUELVE A TRAGAR", 5.2)
	if level + 1 >= int(upgrade.get("max", 1)) and id in pinned_upgrade_ids:
		_remove_upgrade_pin(id)
	_update_ui()
	_check_phase_progress()
	_save()

func _phase() -> Dictionary:
	return PHASES[clampi(current_phase - 1, 0, PHASES.size() - 1)]

func _debug_set_phase(next_phase: int) -> void:
	joe_dialog.hide()
	phase_event_pending = false
	pending_phase_debut = 0
	playing = true
	current_phase = clampi(next_phase, 1, PHASES.size())
	phase_work = 0.0
	phase_events = {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
	joe_high = minf(96.0, float(PHASE_HIGH_THRESHOLDS[current_phase - 1]) + 4.0)
	joe_high_display = joe_high
	contamination = 0.0 if current_phase < 3 else 42.0
	contamination_band = int(contamination / 25.0)
	box_jammed = false
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	another_line_clock = ANOTHER_LINE_INTERVAL
	another_line_wave = 0
	another_line_drop_clock = 0.0
	another_line_spawn_index = 0
	another_line_events = 0
	another_line_warned = false
	mined_since_line = 0.0
	pending_line_grains = int(ANOTHER_LINE_GRAIN_TIERS[0])
	current_line_grains = 0
	last_line_grains = int(ANOTHER_LINE_GRAIN_TIERS[0])
	chalk_clock = CHALK_INTERVAL
	spray_clock = SPRAY_INTERVAL
	spray_followup_clock = 0.0
	spray_pending = false
	spray_film_hp = 0.0
	spray_film_max = 0.0
	spray_feedback_clock = 0.0
	scratch_clock = SCRATCH_INTERVAL
	mucus_clock = MUCUS_INTERVAL
	mucus_hp = 0.0
	mucus_max_hp = 0.0
	catapult_clock = 0.0
	puncher_unlocked = current_phase >= 2 or int(levels.puncher) > 0
	puncher_debut_pending = false
	puncher_debut_clock = 0.0
	manual_clicks_since_burst = 0
	continuous_sweep_held = false
	continuous_sweep_clock = 0.0
	manual_mining_click_times.clear()
	rocks_opened = 0
	impurities_cleaned = 0
	tissue_repaired = 0.0
	compaction_steps = {"left":0, "right":0}
	if current_phase < 2:
		compaction_announced = false
	tissue_damage = 0.0 if current_phase < 5 else 48.0
	infection = 38.0 if current_phase >= 5 else 0.0
	_rebuild_pawns()
	_rebuild_punchers()
	_rebuild_adaptations()
	_rebuild_infrastructure()
	_rebuild_transporters()
	_rebuild_joe_event_visuals()
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
	var removed: Array[PilePiece] = []
	for piece in loose_chunks.duplicate():
		if not is_instance_valid(piece): continue
		var kind: String = piece.get_meta("kind", "grain")
		var remove := (current_phase < 2 and kind == "rock") or (current_phase < 3 and kind == "impurity") or (current_phase < 5 and kind == "bacteria")
		if remove:
			removed.append(piece)
	_erase_loose_pieces(removed)
	_restack_pile()

func _restack_pile(side_filter: String = "") -> void:
	var sides := [side_filter] if not side_filter.is_empty() else ["left", "right"]
	for side_value in sides:
		var side := str(side_value)
		for column_value in (pile_columns[side] as Dictionary).keys():
			var column := int(column_value)
			var stack: Array = (pile_columns[side] as Dictionary)[column]
			stack.sort_custom(func(a: PilePiece, b: PilePiece) -> bool: return a.position.y > b.position.y)
			var accumulated := 0.0
			for piece_value in stack:
				var piece := piece_value as PilePiece
				var height := float(piece.get_meta("height", GRAIN_HEIGHT))
				piece.position = Vector2(_pile_center(side) + float(column) * GRAIN_SPACING + float(piece.get_meta("x_jitter", 0.0)), _ground_y() - 5.0 - accumulated - height * 0.5)
				accumulated += height
		_align_compacted_rocks(side)

func _align_compacted_rocks(side: String) -> void:
	if not powder_surface:
		return
	var rocks: Array[PilePiece] = []
	for value in loose_chunks:
		var rock := value as PilePiece
		if _piece_is_in_pile(rock, side) and str(rock.get_meta("kind", "grain")) == "rock" and bool(rock.get_meta("landed", true)):
			rocks.append(rock)
	rocks.sort_custom(func(a: PilePiece, b: PilePiece) -> bool: return a.position.x < b.position.x if side == "right" else a.position.x > b.position.x)
	var previous_x := -INF if side == "right" else INF
	var bounds := _column_bounds(side, _pile_radius_limit(side))
	var min_x := _pile_center(side) + float(bounds.x) * GRAIN_SPACING
	var max_x := _pile_center(side) + float(bounds.y) * GRAIN_SPACING
	for rock in rocks:
		var diameter := maxf(22.0, rock.texture.get_width() * absf(rock.scale.x) * 0.82)
		var x := clampf(rock.position.x, min_x + diameter * 0.5, max_x - diameter * 0.5)
		if side == "right" and previous_x > -INF and x < previous_x + diameter:
			x = minf(max_x - diameter * 0.5, previous_x + diameter)
		elif side == "left" and previous_x < INF and x > previous_x - diameter:
			x = maxf(min_x + diameter * 0.5, previous_x - diameter)
		# El sprite del apelmazado comparte un PNG con mucho margen transparente;
		# se apoya usando su último píxel visible, no la altura del archivo.
		var visible_bottom := maxf(4.0, _texture_opaque_bottom(rock.texture) * absf(rock.scale.y))
		rock.position = Vector2(x, powder_surface.surface_y_at(side, x) - visible_bottom + ROCK_SURFACE_INSET)
		pile_renderer.refresh_group(rock)
		previous_x = x

func _update_another_line(delta: float) -> void:
	if another_line_wave > 0:
		another_line_clock = maxf(0.0, another_line_clock - delta)
		another_line_drop_clock -= delta
		if another_line_drop_clock <= 0.0:
			another_line_drop_clock = ANOTHER_LINE_DROP_INTERVAL
			var batch := mini(5, another_line_wave)
			another_line_wave -= batch
			for grain in range(batch):
				var wave_total := maxi(1, current_line_grains)
				var projected_load := _pile_load(active_side) + float(another_line_wave)
				var previous_load := maxf(0.0, projected_load - float(wave_total))
				var reach := mini(_pile_radius_limit(active_side), 18 + current_phase * 2 + int(sqrt(previous_load / 12.0)))
				var bounds := _column_bounds(active_side, reach)
				var band_size := ceili(float(wave_total) / float(ANOTHER_LINE_ANCHORS.size()))
				var band := mini(ANOTHER_LINE_ANCHORS.size() - 1, int(another_line_spawn_index / band_size))
				var event_index := maxi(0, another_line_events - 1) % ANOTHER_LINE_SHIFTS.size()
				var anchor := clampf(float(ANOTHER_LINE_ANCHORS[band]) + float(ANOTHER_LINE_SHIFTS[event_index]), 0.05, 0.95)
				var center := roundi(lerpf(float(bounds.x), float(bounds.y), anchor))
				another_line_spawn_index += 1
				var rain_x := _pile_center(active_side) + float(center) * GRAIN_SPACING
				_spawn_line_piece(Vector2(rain_x + randf_range(-7.0, 7.0), _ground_y() - randf_range(300.0, 430.0)), active_side, center, another_line_spawn_index)
			if another_line_wave == 0:
				_finish_another_line()
				current_line_grains = 0
		return
	another_line_clock -= delta
	if another_line_clock <= ANOTHER_LINE_WARNING and not another_line_warned:
		another_line_warned = true
		pending_line_grains = _another_line_grain_count(mined_since_line)
		_show_toast("JOE PREPARA OTRA RAYITA  ·  CAERÁN %s DE POLVO" % _number(pending_line_grains))
	if another_line_clock <= 0.0:
		_start_another_line("normal")

func _another_line_grain_count(recent_mining: float) -> int:
	for index in range(ANOTHER_LINE_MINING_THRESHOLDS.size()):
		if recent_mining < float(ANOTHER_LINE_MINING_THRESHOLDS[index]):
			return int(ANOTHER_LINE_GRAIN_TIERS[index])
	return int(ANOTHER_LINE_GRAIN_TIERS.back())

func _start_another_line(source: String) -> void:
	var grain_count := last_line_grains
	if source == "normal":
		grain_count = pending_line_grains if another_line_warned else _another_line_grain_count(mined_since_line)
		last_line_grains = grain_count
		mined_since_line = 0.0
		pending_line_grains = int(ANOTHER_LINE_GRAIN_TIERS[0])
		another_line_clock = ANOTHER_LINE_INTERVAL
		another_line_warned = false
	if another_line_wave == 0:
		another_line_spawn_index = 0
		current_line_grains = 0
	another_line_wave += grain_count
	current_line_grains += grain_count
	another_line_drop_clock = 0.0
	another_line_events += 1
	if source == "normal": phase_events.line = int(phase_events.line) + 1
	if source == "normal":
		if ANOTHER_LINE_HIGH_GAIN > 0.0:
			_change_joe_high(ANOTHER_LINE_HIGH_GAIN, true)
		_play_sfx(SFX_JOE_INHALE, -13.0, 1.12)
	var source_text := "RAYITA CON SERRÍN" if source == "adulterated" else "OTRA RAYITA"
	_show_toast("%s  ·  +%s DE POLVO" % [source_text, _number(grain_count)])
	_float_text("+%s DE POLVO" % _number(grain_count), Vector2(_pile_center(active_side), _ground_y() - 250.0))
	# La cortina anticipa las mismas zonas que recibirá la dosis. Así el terreno
	# crece bajo los copos que el jugador ha visto, no en un montículo arbitrario.
	var preview_bounds := _column_bounds(active_side, mini(_pile_radius_limit(active_side), 18 + current_phase * 2))
	for anchor_value in ANOTHER_LINE_ANCHORS:
		var preview_column := roundi(lerpf(float(preview_bounds.x), float(preview_bounds.y), float(anchor_value)))
		var preview_x := _pile_center(active_side) + float(preview_column) * GRAIN_SPACING
		_spawn_powder_fall(Vector2(preview_x, _ground_y() - randf_range(380.0, 440.0)), active_side, 4, 1.25, preview_column)

func _spawn_line_piece(origin: Vector2, side: String, column: int, index: int) -> void:
	var value := 1.0
	if _fossa_accepts(side, value) < value:
		_return_powder_to_wall(side, value)
		_show_fossa_saturated(side)
		return
	var impurity_stride := maxi(5, 5 + int(levels.sorting))
	if current_phase >= 3 and index % impurity_stride == 0:
		var adulterant := "serrín" if another_line_events % 2 == 1 else "yeso"
		var piece := _create_piece("impurity", side, value, 0, _choose_landing_column(side, column), randf_range(0.078, 0.09), adulterant, "joe")
		_drop_piece(piece, origin)
	else:
		_spawn_chunk(origin, value, side, column, "joe", index % 10 == 0)

func _finish_another_line() -> void:
	if puncher_unlocked:
		return
	puncher_unlocked = true
	_update_ui()
	call_deferred("_focus_required_upgrade")
	if compaction_announced and int(levels.breaker) == 0:
		_show_toast("EL POLVO SE HA APELMAZADO  ·  NECESITAS UN CASCO AZUL", 4.2)
	else:
		_show_toast("NUEVA ADAPTACIÓN  ·  CÉLULA PÚGIL EN PRÁCTICAS", 3.6)
	_save()

func _update_joe_events(delta: float) -> void:
	if current_phase >= 3:
		chalk_clock -= delta
		if chalk_clock <= 0.0:
			chalk_clock = CHALK_INTERVAL
			_trigger_chalk()
	if current_phase >= 4:
		if spray_pending:
			spray_followup_clock -= delta
			if spray_followup_clock <= 0.0:
				_resolve_spray_line()
		else:
			spray_clock -= delta
			if spray_clock <= 0.0:
				spray_clock = SPRAY_INTERVAL
				_trigger_spray()
		if spray_film_hp > 0.0 and int(levels.sponge) > 0 and not box_jammed:
			_absorb_spray_film(delta)
		mucus_clock -= delta
		if mucus_clock <= 0.0:
			mucus_clock = MUCUS_INTERVAL
			_trigger_mucus()
	if current_phase >= 5:
		scratch_clock -= delta
		if scratch_clock <= 0.0:
			scratch_clock = SCRATCH_INTERVAL
			_trigger_scratch()
	if mucus_hp > 0.0 and int(levels.catapult) > 0 and not box_jammed:
		catapult_clock -= delta
		if catapult_clock <= 0.0:
			catapult_clock = CATAPULT_INTERVAL
			_launch_catapults()

func _trigger_chalk() -> void:
	phase_events.chalk = int(phase_events.chalk) + 1
	var visuals := 60
	var value := CHALK_UNITS / float(visuals)
	for index in range(visuals):
		var column := _choose_landing_column(active_side)
		var piece := _create_piece("impurity", active_side, value, 0, column, randf_range(0.078, 0.092), "tiza")
		_drop_piece(piece, Vector2(_pile_center(active_side) + float(column) * GRAIN_SPACING + randf_range(-8.0, 8.0), _ground_y() - randf_range(300.0, 440.0)))
	_change_joe_high(CHALK_UNITS * JOE_HIGH_PER_COCAINE_UNIT, true)
	_play_sfx(SFX_ROCK, -7.0, 0.72)
	_show_toast("JOE SE HA METIDO TIZA  ·  +%s UNIDADES" % _number(CHALK_UNITS))

func _trigger_spray() -> void:
	phase_events.spray = int(phase_events.spray) + 1
	spray_pending = true
	spray_followup_clock = SPRAY_FOLLOWUP
	spray_side = active_side
	spray_film_hp += SPRAY_FILM_UNITS
	spray_film_max += SPRAY_FILM_UNITS
	spray_feedback_clock = 0.0
	for index in range(22):
		_spawn_spray_drop(index)
	_add_spray_coat()
	_pulse_adaptation("sponge")
	_play_sfx(SFX_MUCUS, -8.0, 1.35)
	_show_toast("SPRAY NASAL DEL BAZAR  ·  PARED BLOQUEADA POR %s UNIDADES" % _number(spray_film_hp))

func _spawn_spray_drop(index: int) -> void:
	var drop := Polygon2D.new()
	drop.polygon = PackedVector2Array([Vector2(0, -8), Vector2(-5, 0), Vector2(-3, 6), Vector2(0, 9), Vector2(3, 6), Vector2(5, 0)])
	drop.color = Color("57bce8")
	drop.z_index = 8
	drop.position = Vector2(_wall_center_x(spray_side) + randf_range(-72.0, 72.0), 28.0 + float(index % 5) * 24.0)
	drop.set_meta("event_kind", "spray")
	joe_events.add_child(drop)
	var duration := randf_range(1.0, 1.7)
	var tween := create_tween().set_parallel()
	tween.tween_property(drop, "position:y", _ground_y() - randf_range(5.0, 80.0), duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(drop, "modulate:a", 0.2, duration)
	tween.chain().tween_callback(drop.queue_free)

func _add_spray_coat() -> void:
	for child in joe_events.get_children():
		if child.get_meta("event_kind", "") == "spray_coat": child.queue_free()
	for index in range(7):
		var coat := Polygon2D.new()
		coat.polygon = PackedVector2Array([Vector2(-23, 11), Vector2(-19, -22), Vector2(-5, -31), Vector2(20, -23), Vector2(25, 9), Vector2(12, 27), Vector2(-13, 25)])
		coat.color = Color(0.25, 0.72, 0.95, 0.54)
		coat.z_index = 8
		coat.position = Vector2(_wall_center_x(spray_side) + randf_range(-25.0, 25.0), _ground_y() - 44.0 - float(index) * 46.0)
		coat.rotation = randf_range(-0.18, 0.18)
		coat.set_meta("event_kind", "spray_coat")
		joe_events.add_child(coat)

func _resolve_spray_line() -> void:
	spray_pending = false
	var remaining_ratio := clampf(spray_film_hp / maxf(1.0, spray_film_max), 0.0, 1.0)
	var attempted := SPRAY_RECOAT_UNITS * remaining_ratio
	var maximum := left_max if spray_side == "left" else right_max
	var current := left_hp if spray_side == "left" else right_hp
	var restored := minf(attempted, maxf(0.0, maximum - current))
	if spray_side == "left": left_hp += restored
	else: right_hp += restored
	_update_world()
	_show_toast("RAYITA SOLIDIFICADA  ·  PARED +%s  ·  PELÍCULA RESTANTE %s" % [_number(restored), _number(spray_film_hp)])

func _sponge_absorb_rate() -> float:
	return float(levels.sponge) * 40.0 * pow(1.8, int(levels.sponge_power))

func _remove_spray_film(amount: float) -> float:
	var removed := minf(spray_film_hp, maxf(0.0, amount))
	if removed <= 0.0:
		return 0.0
	spray_film_hp -= removed
	_update_spray_coat_visuals()
	if spray_film_hp > 0.0:
		return removed
	spray_film_hp = 0.0
	spray_film_max = 0.0
	for child in joe_events.get_children():
		if child.get_meta("event_kind", "") == "spray_coat":
			child.queue_free()
	_show_toast("PELÍCULA DE SPRAY RETIRADA  ·  LA PARED VUELVE A MINARSE")
	return removed

func _absorb_spray_film(delta: float) -> void:
	var absorbed := _remove_spray_film(_sponge_absorb_rate() * delta)
	if absorbed <= 0.0: return
	phase_work += absorbed * 0.12
	spray_feedback_clock -= delta
	if spray_feedback_clock <= 0.0:
		spray_feedback_clock = 1.0
		_float_text("ESPONJAS  -%s SPRAY" % _number(_sponge_absorb_rate()), Vector2(_wall_center_x(spray_side), _ground_y() - 170.0))
		_pulse_adaptation("sponge")

func _update_spray_coat_visuals() -> void:
	var ratio := clampf(spray_film_hp / maxf(1.0, spray_film_max), 0.0, 1.0)
	for child in joe_events.get_children():
		if child.get_meta("event_kind", "") == "spray_coat":
			child.modulate.a = 0.24 + ratio * 0.76
			child.scale = Vector2.ONE * (0.75 + ratio * 0.25)

func _trigger_scratch() -> void:
	phase_events.scratch = int(phase_events.scratch) + 1
	_play_sfx(SFX_ROCK, -5.0, 0.62)
	tissue_damage = clampf(tissue_damage + SCRATCH_DAMAGE, 0.0, 100.0)
	_change_joe_high(SCRATCH_HIGH_GAIN, true)
	for index in range(3):
		_spawn_scratch_wound(index)
	_show_toast("RASCADO DE PRECISIÓN  ·  DAÑO +%s  ·  COLOCÓN +%s" % [_number(SCRATCH_DAMAGE), _number(SCRATCH_HIGH_GAIN)])
	_float_text("DAÑO +%s" % _number(SCRATCH_DAMAGE), Vector2(_pile_center(active_side) + 90.0, _ground_y() - 80.0))

func _spawn_scratch_wound(index: int) -> void:
	var wound := Line2D.new()
	wound.width = 7.0
	wound.default_color = Color("d83a50")
	wound.points = PackedVector2Array([Vector2(-26, 0), Vector2(-12, -10), Vector2(-3, 2), Vector2(9, -12), Vector2(27, 0)])
	wound.position = Vector2(_pile_center(active_side) + 120.0 + float(index) * 58.0 + randf_range(-12.0, 12.0), _ground_y() - 5.0)
	wound.set_meta("event_kind", "wound")
	joe_events.add_child(wound)
	var flash := create_tween()
	flash.tween_property(wound, "modulate", Color(1.6, 1.1, 1.1, 1.0), 0.08)
	flash.tween_property(wound, "modulate", Color.WHITE, 0.18)
	var wounds := joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "wound")
	if wounds.size() > 9:
		(wounds[0] as Node).queue_free()

func _trigger_mucus() -> void:
	phase_events.mucus = int(phase_events.mucus) + 1
	_play_sfx(SFX_MUCUS, -4.0, 0.82)
	mucus_hp += MUCUS_STRENGTH
	mucus_max_hp += MUCUS_STRENGTH
	_add_mucus_patches()
	catapult_clock = 0.25
	_update_mucus_visuals()
	_show_toast("MOCO AGLUTINANTE  ·  PARED BLOQUEADA  ·  %s RESISTENCIA" % _number(mucus_hp))

func _add_mucus_patches() -> void:
	for index in range(5):
		var patch := Polygon2D.new()
		patch.polygon = PackedVector2Array([Vector2(-18, 5), Vector2(-14, -12), Vector2(-2, -19), Vector2(14, -13), Vector2(20, 2), Vector2(10, 16), Vector2(-8, 17)])
		patch.color = Color("77bf69")
		patch.z_index = 9
		patch.position = Vector2(_wall_center_x(active_side) + randf_range(-34.0, 34.0), _ground_y() - 58.0 - float(index) * 57.0)
		patch.rotation = randf_range(-0.3, 0.3)
		patch.set_meta("event_kind", "mucus")
		joe_events.add_child(patch)

func _rebuild_joe_event_visuals() -> void:
	for child in joe_events.get_children(): child.queue_free()
	if spray_film_hp > 0.0:
		_add_spray_coat()
		_update_spray_coat_visuals()
	if mucus_hp > 0.0:
		_add_mucus_patches()
		_update_mucus_visuals()

func _damage_mucus(amount: float) -> void:
	if mucus_hp <= 0.0 or amount <= 0.0: return
	var damage := minf(amount, mucus_hp)
	mucus_hp -= damage
	_update_mucus_visuals()
	if mucus_hp > 0.0: return
	mucus_hp = 0.0
	mucus_max_hp = 0.0
	for child in joe_events.get_children():
		if child.get_meta("event_kind", "") == "mucus": child.queue_free()
	_show_toast("MOCO DESPEJADO  ·  LA PARED VUELVE A ESTAR LIBRE")

func _update_mucus_visuals() -> void:
	var ratio := clampf(mucus_hp / maxf(1.0, mucus_max_hp), 0.0, 1.0)
	for child in joe_events.get_children():
		if child.get_meta("event_kind", "") == "mucus":
			child.modulate.a = 0.25 + ratio * 0.75
			child.scale = Vector2.ONE * (0.72 + ratio * 0.28)

func _launch_catapults() -> void:
	var damage := CATAPULT_BASE_DAMAGE * pow(2.0, int(levels.catapult_power))
	for root in adaptations.get_children():
		if root.get_meta("adaptation_kind", "") != "catapult": continue
		var projectile := Sprite2D.new()
		projectile.texture = PAWN_EMPTY
		projectile.scale = Vector2.ONE * 0.035
		projectile.position = root.position + Vector2(-18.0, -25.0)
		adaptations.add_child(projectile)
		var start := projectile.position
		var target := Vector2(_wall_center_x(active_side), _ground_y() - 115.0)
		var tween := create_tween()
		tween.tween_method(_animate_catapult_projectile.bind(projectile, start, target), 0.0, 1.0, 0.72).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(_catapult_hit.bind(projectile, damage))

func _animate_catapult_projectile(progress: float, projectile: Sprite2D, start: Vector2, target: Vector2) -> void:
	if not is_instance_valid(projectile): return
	projectile.position = start.lerp(target, progress) - Vector2(0.0, sin(progress * PI) * 105.0)
	projectile.rotation += 0.16

func _catapult_hit(projectile: Sprite2D, damage: float) -> void:
	if is_instance_valid(projectile): projectile.queue_free()
	if mucus_hp <= 0.0: return
	var actual := minf(damage, mucus_hp)
	_damage_mucus(actual)
	_play_sfx(SFX_MUCUS, -11.0, 1.18)
	_spawn_impact_dust(Vector2(_wall_center_x(active_side), _ground_y() - 70.0), Color("77bf69"), 4)
	_float_text("CATAPULTA  -%s MOCO" % _number(actual), Vector2(_wall_center_x(active_side), _ground_y() - 155.0))

func _update_crisis(delta: float) -> void:
	if current_phase >= 5:
		var bleed_rate := 0.18 + float(current_phase - 4) * 0.08
		var repair_rate := 0.0 if box_jammed else _platelet_repair_rate()
		tissue_repaired += maxf(0.0, repair_rate - bleed_rate) * delta
		tissue_damage = clampf(tissue_damage + (bleed_rate - repair_rate) * delta, 0.0, 100.0)
		phase_work += repair_rate * delta * 0.35
		blood_drop_clock -= delta
		if blood_drop_clock <= 0.0 and tissue_damage > 1.0:
			blood_drop_clock = lerpf(0.72, 0.2, tissue_damage / 100.0)
			_spawn_blood_drop()
		for wound in joe_events.get_children():
			if wound.get_meta("event_kind", "") != "wound": continue
			wound.modulate.a = clampf(tissue_damage / 30.0, 0.12, 1.0)
			if tissue_damage <= 0.5: wound.queue_free()
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

func _platelet_repair_rate() -> float:
	var count := float(mini(12, int(levels.platelets) * 2))
	var rank := clampi(int(levels.repair), 0, PLATELET_REPAIR_MULTIPLIERS.size() - 1)
	return count * 0.22 * float(PLATELET_REPAIR_MULTIPLIERS[rank]) * (1.0 + float(levels.signals) * 0.1)

func _platelet_rate_for(repair_rank: int) -> float:
	var count := float(mini(12, int(levels.platelets) * 2))
	var rank := clampi(repair_rank, 0, PLATELET_REPAIR_MULTIPLIERS.size() - 1)
	return count * 0.22 * float(PLATELET_REPAIR_MULTIPLIERS[rank]) * (1.0 + float(levels.signals) * 0.1)

func _future_special_damage(kind: String, owned_level: int) -> float:
	if owned_level <= 0: return 0.0
	if kind == "ram": return float(RAM_DAMAGE[clampi(int(levels.ram_power), 0, RAM_DAMAGE.size() - 1)])
	if kind == "elephant": return float(ELEPHANT_DAMAGE[clampi(int(levels.elephant_power), 0, ELEPHANT_DAMAGE.size() - 1)])
	if kind == "hammer": return float(HAMMER_DAMAGE[clampi(int(levels.hammer_power), 0, HAMMER_DAMAGE.size() - 1)])
	if kind == "plasma": return float(PLASMA_DAMAGE[clampi(int(levels.plasma_power), 0, PLASMA_DAMAGE.size() - 1)])
	if kind == "meteor": return float(METEOR_DAMAGE[clampi(int(levels.meteor_power), 0, METEOR_DAMAGE.size() - 1)])
	return float(SUPERSAIYAN_DAMAGE[clampi(int(levels.supersaiyan_power), 0, SUPERSAIYAN_DAMAGE.size() - 1)])

func _improve_joe(clean_units: float, mining_feedback := false) -> void:
	var efficiency := _cleaning_efficiency()
	var reduction := clean_units * efficiency
	_change_joe_high(-reduction, mining_feedback)
	if mining_feedback:
		_show_mining_feedback(clean_units, reduction)

func _cleaning_efficiency() -> float:
	var phase_index := clampi(current_phase - 1, 0, PHASE_CLEANING_EFFICIENCY.size() - 1)
	var efficiency := float(PHASE_CLEANING_EFFICIENCY[phase_index])
	if current_phase <= 1 or current_phase >= PHASES.size():
		return efficiency
	# Cada fase empieza conservando parte del impulso anterior y retira esa ayuda
	# de forma gradual. Así el jugador puede comprar el primer escalón nuevo sin
	# quedarse inmóvil, pero necesita completar la cadena para alcanzar el umbral.
	var phase_top := float(PHASE_HIGH_THRESHOLDS[phase_index])
	var phase_bottom := float(PHASE_HIGH_THRESHOLDS[phase_index + 1])
	var transition := clampf((joe_high - phase_bottom) / maxf(0.001, phase_top - phase_bottom), 0.0, 1.0)
	return efficiency * lerpf(1.0, float(PHASE_TRANSITION_MULTIPLIERS[phase_index]), transition)

func _show_mining_feedback(extracted: float, reduction: float) -> void:
	joe_high_feedback_clock = 0.9
	var decimals := 4 if reduction < 0.01 else 2
	var reduction_text := ("%." + str(decimals) + "f") % reduction
	joe_high_feedback.text = "-%s COCAÍNA  ·  -%s%%" % [_number(extracted), reduction_text]
	joe_high_feedback.modulate = Color("79d5e8")
	joe_high_panel.pivot_offset = joe_high_panel.size * 0.5
	if joe_high_feedback_tween and joe_high_feedback_tween.is_valid():
		joe_high_feedback_tween.kill()
	joe_high_panel.scale = Vector2(1.012, 1.08)
	joe_high_progress.modulate = Color("79d5e8")
	joe_high_feedback_tween = create_tween().set_parallel()
	joe_high_feedback_tween.tween_property(joe_high_panel, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_BACK)
	joe_high_feedback_tween.tween_property(joe_high_progress, "modulate", Color.WHITE, 0.46)
	joe_high_feedback_tween.tween_property(joe_high_feedback, "modulate", Color("d9f8ff"), 0.46)

func _change_joe_high(amount: float, pulse: bool = false) -> void:
	joe_high = clampf(joe_high + amount, 0.0, 100.0)
	# Los cambios discretos (minado, rayitas y eventos) se reflejan al instante.
	# Así la barra nunca sigue subiendo por una animación antigua mientras el
	# jugador está picando y reduciendo ya el valor real.
	joe_high_display = joe_high
	if joe_high >= 100.0:
		_trigger_overdose()
	elif joe_high <= 0.0 and not victory_reached:
		_trigger_victory()
	if not pulse or not is_instance_valid(joe_portrait):
		return
	joe_portrait.modulate = Color("ff69ad") if amount > 0.0 else Color("79d5e8")
	create_tween().tween_property(joe_portrait, "modulate", Color.WHITE, 0.48)

func _trigger_overdose() -> void:
	if overdose_active: return
	overdose_active = true
	playing = false
	joe_high = 100.0
	joe_high_display = 100.0
	_play_sfx(SFX_OVERDOSE, -2.0)
	_update_ui()
	overdose_dialog.popup_centered(Vector2i(560, 240))

func _reload_after_overdose() -> void:
	overdose_dialog.hide()
	overdose_active = false
	if FileAccess.file_exists(save_path):
		_load()
		_begin_game()
	else:
		_new_game()

func _return_to_menu_after_overdose() -> void:
	overdose_dialog.hide()
	overdose_active = false
	playing = false
	start_screen.show()
	_update_start_screen()

func _trigger_victory() -> void:
	if victory_active or victory_reached:
		return
	victory_active = true
	victory_reached = true
	joe_high = 0.0
	joe_high_display = 0.0
	_update_ui()
	# Guardamos el hito antes de pausar para que cerrar la ventana no lo pierda.
	_save()
	playing = false
	victory_dialog.popup_centered(Vector2i(600, 240))

func _continue_after_victory() -> void:
	victory_dialog.hide()
	victory_active = false
	playing = true

func _return_to_menu_after_victory() -> void:
	victory_dialog.hide()
	victory_active = false
	playing = false
	start_screen.show()
	_update_start_screen()

func _update_joe_high(delta: float) -> void:
	joe_high_feedback_clock = maxf(0.0, joe_high_feedback_clock - delta)
	var pile_rise := _joe_powder_pressure()
	var contamination_rise := contamination / 100.0 * 0.010 if current_phase >= 3 else 0.0
	var jam_rise := 0.08 if box_jammed else 0.0
	var tissue_rise := tissue_damage / 100.0 * 0.015 if current_phase >= 5 else 0.0
	var infection_rise := infection / 100.0 * 0.018 if current_phase >= 5 else 0.0
	joe_high = clampf(joe_high + (pile_rise + contamination_rise + jam_rise + tissue_rise + infection_rise) * delta, 0.0, 100.0)
	joe_high_display = move_toward(joe_high_display, joe_high, delta * 9.0)
	if joe_high >= 100.0:
		_trigger_overdose()

func _joe_powder_pressure() -> float:
	# La cocaína arrancada por el jugador ya ha reducido el colocón al salir de
	# la pared. Solo el polvo que añade Joe puede ejercer presión desde el suelo.
	var joe_burden := float(joe_grain_load_cache.left) + float(joe_grain_load_cache.right)
	# Una rayita completa sin atender devuelve exactamente 1,5 puntos por minuto,
	# sea cual sea su tamaño. Retirar la mitad de sus granos corta la presión a la
	# mitad, de modo que el evento no se vuelve decorativo en el late game.
	var untreated_wave := maxf(1.0, float(last_line_grains))
	return clampf(joe_burden / untreated_wave, 0.0, 1.0) * ANOTHER_LINE_MAX_PRESSURE

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
	return int(kind_count_cache.get(kind, 0))

func _check_phase_progress() -> void:
	if phase_event_pending or pending_phase_debut > 0 or current_phase >= PHASES.size(): return
	var next_threshold := float(PHASE_HIGH_THRESHOLDS[current_phase])
	if joe_high <= next_threshold: _advance_phase()

func _advance_phase() -> void:
	current_phase = mini(PHASES.size(), current_phase + 1)
	phase_work = 0.0
	phase_events = {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	if current_phase == 2: rocks_opened = 0
	if current_phase == 3: impurities_cleaned = 0
	if current_phase == 5: tissue_repaired = 0.0
	if current_phase == 5: tissue_damage = maxf(tissue_damage, 28.0)
	if current_phase == 5: infection = maxf(infection, 24.0)
	phase_event_pending = false
	pending_phase_debut = current_phase
	_rebuild_pawns()
	_rebuild_platelets()
	_rebuild_adaptations()
	_rebuild_infrastructure()
	_rebuild_transporters()
	_update_world()
	_update_ui()
	call_deferred("_focus_required_upgrade")
	_show_toast("JOE ESTÁ MOLESTO  ·  LE ESTÁS BAJANDO EL COLOCÓN", 4.6)
	get_tree().create_timer(4.7).timeout.connect(_run_phase_debut.bind(current_phase))
	_save()

func _show_phase_event() -> void:
	# El prólogo conserva su explicación inicial. Los umbrales posteriores jamás
	# detienen la partida: Joe protesta en pantalla y el loop continúa.
	if phase_event_pending and current_phase == 1:
		var phase := _phase()
		joe_dialog.title = "BIG NOSE JOE  ·  %s" % phase.title
		joe_dialog.dialog_text = "%s\n\n%s" % [phase.joe, phase.problem]
		joe_dialog.popup_centered(Vector2i(590, 220))
		return
	phase_event_pending = false
	playing = true
	_show_toast("JOE ESTÁ MOLESTO  ·  LE ESTÁS BAJANDO EL COLOCÓN", 4.6)

func _resume_after_joe() -> void:
	phase_event_pending = false
	playing = true
	pending_phase_debut = current_phase
	_run_phase_debut(current_phase)
	_update_ui()
	_save()

func _run_phase_debut(phase_number: int) -> void:
	if pending_phase_debut != phase_number or current_phase != phase_number:
		return
	pending_phase_debut = 0
	_trigger_phase_debut()
	call_deferred("_focus_required_upgrade")
	_check_phase_progress()

func _trigger_phase_debut() -> void:
	if current_phase == 3:
		_start_another_line("adulterated")
		_change_joe_high(8.0, true)
	elif current_phase == 4:
		_trigger_spray()
		mucus_clock = 60.0
	elif current_phase == 5:
		_trigger_scratch()

func _rebuild_platelets() -> void:
	for child in platelets.get_children():
		child.queue_free()
	if current_phase < 5:
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

func _update_platelets(delta: float) -> void:
	if box_jammed:
		return
	var now := Time.get_ticks_msec() * 0.001
	var wounds := joe_events.get_children().filter(func(node: Node) -> bool: return node.get_meta("event_kind", "") == "wound")
	for child in platelets.get_children():
		var platelet := child as Sprite2D
		if not platelet: continue
		var index := int(platelet.get_meta("index", 0))
		var side := -1.0 if index % 2 == 0 else 1.0
		var idle := Vector2(SEPTUM_X + side * (92.0 + float(index / 2) * 19.0), _ground_y() - 8.0)
		var target := idle
		if not wounds.is_empty():
			var wound := wounds[index % wounds.size()] as Node2D
			target = wound.position + Vector2(float(index % 3 - 1) * 9.0, -3.0)
		var direction := signf(target.x - platelet.position.x)
		if not is_zero_approx(direction):
			# La plaqueta, a diferencia del peón, está dibujada mirando a la derecha.
			platelet.flip_h = direction < 0.0
		platelet.position = platelet.position.move_toward(target, (95.0 + float(levels.repair) * 12.0) * delta)
		platelet.position.y = _ground_y() - 8.0
		var working := platelet.position.distance_to(target) < 3.0 and not wounds.is_empty()
		platelet.rotation = sin(now * (5.5 if working else 1.6) + index) * (0.08 if working else 0.025)
		platelet.scale = Vector2(0.094, 0.082) if working and sin(now * 8.0 + index) > 0.0 else Vector2.ONE * 0.088
	platelet_feedback_clock -= delta
	if platelet_feedback_clock <= 0.0 and tissue_damage > 0.0 and int(levels.platelets) > 0:
		platelet_feedback_clock = 3.0
		_float_text("PLAQUETAS  +%s TEJIDO/S" % _number(_platelet_repair_rate()), Vector2(SEPTUM_X, _ground_y() - 90.0))

func _rebuild_infrastructure() -> void:
	for child in infrastructure.get_children(): child.queue_free()
	box.visible = int(levels.get("container", 0)) == 0
	if int(levels.get("silo", 0)) > 0:
		var silo_scale := 0.25 if int(levels.get("vault_reserve", 0)) > 0 else (0.23 if int(levels.get("vault_capacity", 0)) > 0 else (0.20 if int(levels.get("vault", 0)) > 0 else (0.17 if int(levels.get("silo_capacity", 0)) > 0 else 0.14)))
		var silo_title := "RESERVA ESTRATOSFÉRICA DE NAPIA" if int(levels.get("vault_reserve", 0)) > 0 else ("BÓVEDA DE NIEVE HIPERBÁRICA" if int(levels.get("vault_capacity", 0)) > 0 else ("BÓVEDA DE NIEVE PRESURIZADA" if int(levels.get("vault", 0)) > 0 else ("SILO DE ALTO TONELAJE" if int(levels.get("silo_capacity", 0)) > 0 else "SILO DE NIEVE ESTRATÉGICA")))
		_add_infrastructure_sprite(SILO_TEXTURE, Vector2(_box_x(), _ground_y() - 80.0), silo_scale, silo_title)
	elif int(levels.get("container", 0)) > 0:
		var container_scale := 0.145 if int(levels.get("warehouse", 0)) > 0 else (0.13 if int(levels.get("container_capacity", 0)) > 0 else 0.115)
		var container_title := "ALMACÉN ALVEOLAR MODULAR" if int(levels.get("warehouse", 0)) > 0 else ("CONTENEDOR CON DOBLE FONDO" if int(levels.get("container_capacity", 0)) > 0 else "CONTENEDOR DE EMERGENCIA")
		_add_infrastructure_sprite(CONTAINER_TEXTURE, Vector2(_box_x(), _ground_y() - 43.0), container_scale, container_title)
	if int(levels.get("plant", 0)) > 0:
		var plant_scale := 0.21 if int(levels.get("plant_capacity", 0)) > 0 else (0.19 if int(levels.get("plant_buffer", 0)) > 0 else 0.17)
		var plant_title := "PLANTA DE FUSIÓN SUPERSAIYAN" if int(levels.get("plant_capacity", 0)) > 0 else ("PLANTA CON TOLVAS DE CATARRO" if int(levels.get("plant_buffer", 0)) > 0 else "PLANTA DE NIEVE INDUSTRIAL")
		_add_infrastructure_sprite(PLANT_TEXTURE, Vector2(PLANT_X, _ground_y() - 62.0), plant_scale, plant_title)
	if int(levels.get("train", 0)) > 0 and septum_open:
		_add_train_tunnels()
	_add_storage_readout()
	_update_storage_visual()

func _storage_feedback_position() -> Vector2:
	var heights := [82.0, 155.0, 155.0, 155.0, 200.0, 200.0, 220.0, 235.0, 245.0, 255.0, 265.0, 275.0, 285.0, 295.0, 305.0]
	var height: float = float(heights[clampi(_storage_tier(), 0, heights.size() - 1)])
	return Vector2(_box_x(), _ground_y() - height)

func _add_storage_readout() -> void:
	var root := Node2D.new()
	root.name = "StorageReadout"
	root.position = _storage_feedback_position()
	root.z_index = 24
	root.set_meta("storage_readout", true)
	var label := Label.new()
	label.name = "Value"
	label.position = Vector2(-110.0, -12.0)
	label.size = Vector2(220.0, 23.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 13)
	label.add_theme_color_override("font_color", Color("fff1c7"))
	label.add_theme_color_override("font_outline_color", Color("160b1b"))
	label.add_theme_constant_override("outline_size", 5)
	root.add_child(label)
	infrastructure.add_child(root)

func _add_infrastructure_sprite(texture: Texture2D, position: Vector2, scale_factor: float, caption: String) -> void:
	var root := Node2D.new()
	root.position = position
	root.z_index = 2
	root.set_meta("storage_visual", true)
	var sprite := Sprite2D.new()
	sprite.texture = texture
	sprite.scale = Vector2.ONE * scale_factor
	root.add_child(sprite)
	var label := Label.new()
	label.position = Vector2(-155.0, -82.0)
	label.size = Vector2(310.0, 24.0)
	label.text = caption
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", Color("e8c99a"))
	root.add_child(label)
	infrastructure.add_child(root)

func _add_train_tunnels() -> void:
	for tunnel_x in [LEFT_TUNNEL_X, RIGHT_TUNNEL_X]:
		var root := Node2D.new()
		root.name = "TúnelIzquierdo" if tunnel_x == LEFT_TUNNEL_X else "TúnelDerecho"
		root.position = Vector2(tunnel_x, _ground_y())
		root.z_index = 1
		root.set_meta("train_tunnel", true)
		var arch_points := PackedVector2Array()
		for step in range(17):
			var angle := PI + PI * float(step) / 16.0
			arch_points.append(Vector2(cos(angle) * 92.0, sin(angle) * 78.0))
		var opening := Polygon2D.new()
		opening.polygon = arch_points
		opening.color = Color("130b19")
		root.add_child(opening)
		var rim := Line2D.new()
		rim.points = arch_points
		rim.width = 11.0
		rim.default_color = Color("6e344e")
		rim.joint_mode = Line2D.LINE_JOINT_ROUND
		root.add_child(rim)
		var inner := Line2D.new()
		inner.points = arch_points
		inner.width = 4.0
		inner.default_color = Color("dc7966")
		inner.joint_mode = Line2D.LINE_JOINT_ROUND
		root.add_child(inner)
		var label := Label.new()
		label.position = Vector2(-100.0, -112.0)
		label.size = Vector2(200.0, 22.0)
		label.text = "TÚNEL LINFÁTICO"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 10)
		label.add_theme_color_override("font_color", Color("e8c99a"))
		root.add_child(label)
		infrastructure.add_child(root)

func _update_storage_visual() -> void:
	var ratio := clampf(cells / maxf(1.0, _storage_capacity()), 0.0, 1.0)
	var tint := Color.WHITE.lerp(Color("ffc66d"), ratio * 0.22)
	tint = tint.lerp(Color("8c5130"), contamination / 100.0 * 0.55)
	if box_jammed:
		tint = tint.lerp(Color("70342f"), sin(Time.get_ticks_msec() * 0.012) * 0.22 + 0.48)
	for child in infrastructure.get_children():
		if bool(child.get_meta("storage_visual", false)):
			child.modulate = tint
		if bool(child.get_meta("storage_readout", false)):
			var label := child.get_node_or_null("Value") as Label
			if label:
				label.text = "ALMACÉN  %s / %s" % [_number(cells), _number(_storage_capacity())]
	box.modulate = tint

func _rebuild_transporters() -> void:
	for child in transporters.get_children():
		_release_transport_cargo(child)
		child.queue_free()
	if int(levels.get("cart", 0)) > 0:
		_add_ground_transporter("cart", _cart_capacity(), _ground_transport_speed(CART_SPEED))
	if int(levels.get("ox_convoy", 0)) > 0:
		_add_ground_transporter("ox", _ox_capacity(), _ground_transport_speed(OX_SPEED))
	if int(levels.get("train", 0)) > 0 and septum_open:
		_add_train()
	_restack_pile()

func _cart_capacity() -> float:
	var renaissance := clampi(int(levels.get("cart_renaissance", 0)), 0, CART_RENAISSANCE_CAPACITIES.size() - 1)
	if renaissance > 0: return float(CART_RENAISSANCE_CAPACITIES[renaissance])
	if int(levels.get("cart_tanker", 0)) > 0: return CART_TANKER_CAPACITY
	if int(levels.get("cart_bulk", 0)) > 0: return CART_BULK_CAPACITY
	if int(levels.get("cart_freight", 0)) > 0: return CART_FREIGHT_CAPACITY
	if int(levels.get("cart_upgrade", 0)) > 0: return CART_TRAILER_CAPACITY
	if int(levels.get("cart_reinforced", 0)) > 0: return CART_REINFORCED_CAPACITY
	return CART_CAPACITY

func _ox_capacity(level := -1) -> float:
	var resolved_level := int(levels.get("ox_capacity", 0)) + int(levels.get("ox_heavy_capacity", 0)) if level < 0 else level
	if level < 0 and int(levels.get("ox_plasma_capacity", 0)) > 0:
		resolved_level = 8 + clampi(int(levels.ox_plasma_capacity), 1, 3)
	elif level < 0 and int(levels.get("ox_vault_capacity", 0)) > 0:
		resolved_level = 4 + clampi(int(levels.ox_vault_capacity), 1, 4)
	return float(OX_CAPACITIES[clampi(resolved_level, 0, OX_CAPACITIES.size() - 1)])

func _add_ground_transporter(kind: String, capacity: float, speed: float) -> void:
	var root := Node2D.new()
	root.name = kind.capitalize()
	root.position = Vector2(_box_x(), _ground_y())
	root.z_index = 5
	root.set_meta("transport_kind", kind)
	root.set_meta("capacity", capacity)
	root.set_meta("speed", speed)
	root.set_meta("state", "to_pile")
	root.set_meta("side", active_side)
	root.set_meta("cargo", [])
	root.set_meta("timer", 0.0)
	if kind == "cart":
		var cart := Sprite2D.new()
		cart.name = "Vehicle"
		cart.texture = CART_TEXTURE
		cart.scale = Vector2.ONE * 0.075
		cart.position = Vector2(8.0, -16.5)
		root.add_child(cart)
		var puller := Sprite2D.new()
		puller.name = "Puller"
		puller.texture = PAWN_EMPTY
		puller.scale = Vector2.ONE * 0.036
		puller.offset = Vector2(0.0, PAWN_FOOT_DEPTH / puller.scale.y - PAWN_EMPTY.get_height() * 0.5)
		# El conjunto está dibujado para avanzar hacia la izquierda; al volver,
		# la escala del conjunto invierte a la vez célula, enganche y carro.
		puller.position = Vector2(-38.0, -14.0)
		puller.z_index = 2
		root.add_child(puller)
		var renaissance := int(levels.get("cart_renaissance", 0))
		if renaissance > 0:
			var quantum_coil := Line2D.new()
			quantum_coil.name = "QuantumCoil"
			quantum_coil.points = PackedVector2Array([Vector2(-4, -43), Vector2(8, -55), Vector2(20, -43), Vector2(32, -55), Vector2(44, -43)])
			quantum_coil.width = 4.0 if renaissance == 1 else 7.0
			quantum_coil.default_color = Color("72dce8") if renaissance == 1 else Color("ff70cf")
			quantum_coil.z_index = 4
			root.add_child(quantum_coil)
	else:
		var wagons := Sprite2D.new()
		wagons.name = "Vehicle"
		wagons.texture = CONVOY_TEXTURE
		wagons.scale = Vector2.ONE * 0.09
		wagons.position = Vector2(48.0, -10.0)
		root.add_child(wagons)
		var ox := Sprite2D.new()
		ox.name = "Puller"
		ox.texture = LEUKOX_TEXTURE
		ox.scale = Vector2.ONE * 0.085
		ox.position = Vector2(-82.0, -27.5)
		ox.z_index = 2
		root.add_child(ox)
	_add_transport_load_readout(root)
	transporters.add_child(root)

func _add_transport_load_readout(root: Node2D) -> void:
	var label := Label.new()
	label.name = "LoadReadout"
	label.position = Vector2(-70.0, -66.0)
	label.size = Vector2(140.0, 22.0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("fff1c7"))
	label.add_theme_color_override("font_outline_color", Color("160b1b"))
	label.add_theme_constant_override("outline_size", 5)
	root.add_child(label)
	_update_transport_load_readout(root)

func _update_transport_load_readout(root: Node2D) -> void:
	var label := root.get_node_or_null("LoadReadout") as Label
	if not label: return
	var load := 0.0
	for value in root.get_meta("cargo", []):
		var piece := value as PilePiece
		if is_instance_valid(piece): load += float(piece.get_meta("value", 1.0))
	label.text = "CARGA  %s / %s" % [_number(load), _number(float(root.get_meta("capacity", 0.0)))]
	label.scale.x = root.scale.x

func _add_train() -> void:
	var root := Node2D.new()
	root.name = "LeukocyteExpress"
	root.position = Vector2(PLANT_X + 165.0, _ground_y() - 10.0)
	root.z_index = 7
	root.set_meta("transport_kind", "train")
	root.set_meta("state", "waiting")
	root.set_meta("side", "right")
	root.set_meta("cargo", [])
	root.set_meta("timer", 1.2)
	var train := Sprite2D.new()
	train.name = "Vehicle"
	train.texture = TRAIN_TEXTURE
	train.scale = Vector2.ONE * 0.13
	train.position = Vector2(0.0, -12.0)
	root.add_child(train)
	transporters.add_child(root)

func _update_transporters(delta: float) -> void:
	for child in transporters.get_children():
		var root := child as Node2D
		if not root: continue
		if root.get_meta("transport_kind", "") == "train":
			_update_train(root, delta)
		else:
			_update_ground_transporter(root, delta)

func _update_ground_transporter(root: Node2D, delta: float) -> void:
	_update_transport_load_readout(root)
	if box_jammed: return
	var state: String = root.get_meta("state", "to_pile")
	var side: String = root.get_meta("side", active_side)
	var speed := float(root.get_meta("speed", CART_SPEED))
	var timer := maxf(0.0, float(root.get_meta("timer", 0.0)) - delta)
	root.set_meta("timer", timer)
	if state == "to_pile":
		if _storage_claim_space() <= 0.0 or _nearest_fallen_wall_chunk(side):
			return
		var target := _pile_access_point(side) + Vector2(46.0, 14.0)
		_move_transport_root(root, target, speed, delta)
		if root.position.distance_to(target) <= 1.0:
			var cargo := _claim_transport_cocaine(side, float(root.get_meta("capacity", 1.0)), false)
			root.set_meta("cargo", cargo)
			root.set_meta("state", "to_storage" if not cargo.is_empty() else "waiting")
			root.set_meta("timer", 0.55)
	elif state == "waiting":
		if timer <= 0.0: root.set_meta("state", "to_pile")
	else:
		var depot := Vector2(_box_x(), _ground_y())
		_move_transport_root(root, depot, speed, delta)
		if root.position.distance_to(depot) <= 1.0:
			_deliver_transport_cargo(root, depot)
			root.set_meta("side", active_side)
			root.set_meta("state", "to_pile")

func _move_transport_root(root: Node2D, target: Vector2, speed: float, delta: float) -> void:
	var direction := signf(target.x - root.position.x)
	if not is_zero_approx(direction): root.scale.x = 1.0 if direction < 0.0 else -1.0
	var load_readout := root.get_node_or_null("LoadReadout") as Label
	if load_readout: load_readout.scale.x = root.scale.x
	root.position = root.position.move_toward(target, speed * delta)
	root.position.y = _ground_y()

func _claim_transport_cocaine(side: String, capacity: float, take_all: bool) -> Array:
	var cargo: Array = []
	var remaining := minf(capacity, _storage_claim_space())
	var candidates: Array = loose_chunks.duplicate() if take_all else _top_pieces(side)
	for value in candidates:
		var piece := value as PilePiece
		if not _piece_is_in_pile(piece, side) or piece.get_meta("kind", "grain") != "grain": continue
		var piece_value := float(piece.get_meta("value", 1.0))
		if piece_value > remaining + 0.001: continue
		piece.visible = false
		_set_piece_carried(piece, true)
		cargo.append(piece)
		remaining -= piece_value
		if remaining <= 0.001: break
	_rebuild_pile_index(side)
	_settle_surface(side, 5)
	_restack_pile(side)
	return cargo

func _deliver_transport_cargo(root: Node2D, at: Vector2) -> void:
	var delivered := 0.0
	var clean_progress := 0.0
	var joe_clean_progress := 0.0
	var available_storage := _manual_claim_space()
	var side: String = root.get_meta("side", active_side)
	var consumed_pieces: Array[PilePiece] = []
	for value in root.get_meta("cargo", []):
		var piece := value as PilePiece
		if not is_instance_valid(piece): continue
		var piece_value := float(piece.get_meta("value", 1.0))
		var requested := piece_value * _box_yield_multiplier()
		if requested <= available_storage + 0.001:
			delivered += requested
			available_storage -= requested
			clean_progress += piece_value
			if piece.get_meta("source", "player") != "player":
				joe_clean_progress += piece_value
			consumed_pieces.append(piece)
		else:
			piece.visible = true
			_set_piece_carried(piece, false)
			piece.position = _landing_position(piece)
	if consumed_pieces.is_empty():
		_rebuild_pile_index(side)
	else:
		_erase_loose_pieces(consumed_pieces)
	if delivered > 0.0:
		cells += delivered
		phase_work += clean_progress
		if joe_clean_progress > 0.0:
			_improve_joe(joe_clean_progress)
	root.set_meta("cargo", [])
	if delivered > 0.0:
		var title := "EXPRESO" if root.get_meta("transport_kind", "") == "train" else ("MUGIDÓFILO" if root.get_meta("transport_kind", "") == "ox" else "CARRITO")
		_float_text("%s  +%s" % [title, _number(delivered)], at - Vector2(0.0, 92.0))
	_restack_pile(side)
	_update_storage_visual()
	_update_ui()

func _release_transport_cargo(root: Node) -> void:
	for value in root.get_meta("cargo", []):
		var piece := value as PilePiece
		if not is_instance_valid(piece): continue
		piece.visible = true
		_set_piece_carried(piece, false)
		piece.position = _landing_position(piece)
	_rebuild_pile_index()

func _erase_loose_pieces(pieces: Array[PilePiece]) -> void:
	if pieces.is_empty():
		return
	var removed := {}
	for piece in pieces:
		if is_instance_valid(piece):
			removed[piece.get_instance_id()] = true
			piece.queue_free()
	var survivors: Array[PilePiece] = []
	for piece in loose_chunks:
		if is_instance_valid(piece) and not removed.has(piece.get_instance_id()):
			survivors.append(piece)
	loose_chunks = survivors
	_rebuild_pile_index()

func _update_train(root: Node2D, delta: float) -> void:
	if box_jammed: return
	var state: String = root.get_meta("state", "waiting")
	if state == "waiting":
		var timer := maxf(0.0, float(root.get_meta("timer", 0.0)) - delta)
		root.set_meta("timer", timer)
		if timer > 0.0 or _storage_claim_space() <= 0.0: return
		if _nearest_fallen_wall_chunk("right"): return
		root.set_meta("side", "right")
		root.set_meta("state", "empty_to_left_tunnel")
		return
	if state == "empty_to_left_tunnel":
		if _move_train_ground(root, LEFT_TUNNEL_X, delta):
			root.visible = false
			root.set_meta("state", "empty_tunnel")
			root.set_meta("timer", TRAIN_TUNNEL_TIME)
		return
	if state == "empty_tunnel":
		var timer := maxf(0.0, float(root.get_meta("timer", 0.0)) - delta)
		root.set_meta("timer", timer)
		if timer <= 0.0:
			root.position = Vector2(RIGHT_TUNNEL_X, _ground_y() - 10.0)
			root.visible = true
			root.set_meta("state", "to_pile")
			_float_text("¡EXPRESO VACÍO!", root.position - Vector2(0.0, 80.0))
		return
	if state == "to_pile":
		if _nearest_fallen_wall_chunk("right"): return
		var target := _pile_access_point("right") + Vector2(72.0, 14.0)
		if _move_train_ground(root, target.x, delta):
			root.set_meta("state", "waiting_at_pile")
			root.set_meta("timer", 0.0)
		return
	if state == "waiting_at_pile":
		var timer := maxf(0.0, float(root.get_meta("timer", 0.0)) - delta)
		root.set_meta("timer", timer)
		if timer > 0.0 or _nearest_fallen_wall_chunk("right"): return
		var cargo := _claim_transport_cocaine("right", _storage_claim_space(), true)
		root.set_meta("cargo", cargo)
		if cargo.is_empty():
			root.set_meta("timer", 1.0)
		else:
			root.set_meta("state", "loaded_to_right_tunnel")
		return
	if state == "loaded_to_right_tunnel":
		if _nearest_fallen_wall_chunk("right"): return
		if _move_train_ground(root, RIGHT_TUNNEL_X, delta):
			root.visible = false
			root.set_meta("state", "loaded_tunnel")
			root.set_meta("timer", TRAIN_TUNNEL_TIME)
			_float_text("CARGAMENTO AL TÚNEL", root.position - Vector2(0.0, 80.0))
		return
	if state == "loaded_tunnel":
		var timer := maxf(0.0, float(root.get_meta("timer", 0.0)) - delta)
		root.set_meta("timer", timer)
		if timer <= 0.0:
			root.position = Vector2(LEFT_TUNNEL_X, _ground_y() - 10.0)
			root.visible = true
			root.set_meta("state", "to_plant")
			_float_text("¡CARGAMENTO RECIBIDO!", root.position - Vector2(0.0, 80.0))
		return
	if state == "to_plant" and _move_train_ground(root, PLANT_X + 165.0, delta):
		_deliver_transport_cargo(root, Vector2(PLANT_X + 165.0, _ground_y()))
		root.set_meta("state", "waiting")
		root.set_meta("timer", 1.2)

func _move_train_ground(root: Node2D, target_x: float, delta: float) -> bool:
	var direction := signf(target_x - root.position.x)
	if not is_zero_approx(direction):
		root.scale.x = 1.0 if direction < 0.0 else -1.0
	root.rotation = 0.0
	root.position.x = move_toward(root.position.x, target_x, _train_speed() * delta)
	root.position.y = _ground_y() - 10.0
	return is_equal_approx(root.position.x, target_x)

func _rebuild_adaptations() -> void:
	for child in adaptations.get_children(): child.queue_free()
	_rebuild_surveyor()
	for index in range(int(levels.sponge)):
		var root := _adaptation_root("sponge", index, Vector2(_box_x() - 80.0 - float(index) * 52.0, _ground_y() - 14.0))
		var sponge := Sprite2D.new()
		sponge.name = "Accessory"
		sponge.texture = SPONGE_TEXTURE
		sponge.scale = Vector2.ONE * 0.027 * (1.0 + float(levels.sponge_power) * 0.09)
		sponge.position = Vector2(0.0, -15.0)
		sponge.z_index = -1
		root.add_child(sponge)
		var body := Sprite2D.new()
		body.name = "Body"
		body.texture = PAWN_EMPTY
		body.scale = Vector2.ONE * 0.048
		body.offset = Vector2(0.0, PAWN_FOOT_DEPTH / body.scale.y - PAWN_EMPTY.get_height() * 0.5)
		root.add_child(body)
	for index in range(int(levels.catapult)):
		var root := _adaptation_root("catapult", index, Vector2(_box_x() - 300.0 - float(index) * 92.0, _ground_y()))
		var machine := Sprite2D.new()
		machine.name = "Machine"
		machine.texture = CATAPULT_TEXTURE
		machine.scale = Vector2.ONE * 0.072
		machine.position = Vector2(0.0, -22.0)
		machine.z_index = 4
		root.add_child(machine)

func _rebuild_surveyor() -> void:
	if int(levels.get("fossa_depth", 0)) <= 0:
		return
	# El Leucotopógrafo está montado por capas independientes: cuerpo, gorra,
	# chaleco, planos y teodolito se pueden retocar sin rehacer un sprite entero.
	var x := minf(_box_x() - 130.0, _pile_center("right") + 170.0)
	var root := _adaptation_root("surveyor", 0, Vector2(x, _ground_y() - 14.0))
	root.z_index = 11
	var body := Sprite2D.new()
	body.name = "WhiteCellBody"
	body.texture = PAWN_EMPTY
	body.scale = Vector2.ONE * 0.047
	body.offset = Vector2(0.0, PAWN_FOOT_DEPTH / body.scale.y - PAWN_EMPTY.get_height() * 0.5)
	root.add_child(body)
	var vest := Polygon2D.new()
	vest.name = "TweedVest"
	vest.polygon = PackedVector2Array([Vector2(-45, 4), Vector2(0, -14), Vector2(45, 4), Vector2(34, 76), Vector2(-34, 76)])
	vest.color = Color("936a50")
	vest.z_index = 3
	body.add_child(vest)
	var cap := Polygon2D.new()
	cap.name = "FlatCap"
	cap.polygon = PackedVector2Array([Vector2(-58, -93), Vector2(-32, -122), Vector2(24, -126), Vector2(62, -96), Vector2(47, -76), Vector2(-55, -76)])
	cap.color = Color("6e4e4f")
	cap.z_index = 5
	body.add_child(cap)
	var blueprint := Polygon2D.new()
	blueprint.name = "Blueprint"
	blueprint.polygon = PackedVector2Array([Vector2(35, 34), Vector2(98, 18), Vector2(108, 92), Vector2(45, 106)])
	blueprint.color = Color("7bc8dd")
	blueprint.z_index = 4
	body.add_child(blueprint)
	var tripod := Line2D.new()
	tripod.name = "BrassTheodoliteTripod"
	tripod.points = PackedVector2Array([Vector2(38, -42), Vector2(57, 0), Vector2(33, 34), Vector2(78, 34), Vector2(57, 0), Vector2(57, 43)])
	tripod.width = 3.0
	tripod.default_color = Color("c99c4e")
	tripod.joint_mode = Line2D.LINE_JOINT_ROUND
	root.add_child(tripod)
	var lens := Polygon2D.new()
	lens.name = "TheodoliteLens"
	lens.polygon = PackedVector2Array([Vector2(26, -54), Vector2(63, -61), Vector2(78, -47), Vector2(40, -40)])
	lens.color = Color("e4bd5d")
	lens.z_index = 2
	root.add_child(lens)
	var label := Label.new()
	label.name = "SurveyCaption"
	label.position = Vector2(-85, -88)
	label.size = Vector2(170, 18)
	label.text = "MIDIENDO ESPACIO DISPONIBLE"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 9)
	label.add_theme_color_override("font_color", Color("9be6ef"))
	root.add_child(label)

func _adaptation_root(kind: String, index: int, position: Vector2) -> Node2D:
	var root := Node2D.new()
	root.name = "%s_%d" % [kind.capitalize(), index]
	root.position = position
	root.set_meta("base_y", position.y)
	root.set_meta("adaptation_kind", kind)
	root.set_meta("index", index)
	root.z_index = 3
	adaptations.add_child(root)
	return root

func _update_adaptations(_delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	for root in adaptations.get_children():
		if not root is Node2D: continue
		var item := root as Node2D
		var kind: String = item.get_meta("adaptation_kind", "")
		var index := int(item.get_meta("index", 0))
		item.position.y = float(item.get_meta("base_y", item.position.y))
		item.rotation = 0.0
		if kind == "surveyor":
			item.position.y += sin(now * 1.8) * 0.8
			var lens := item.get_node_or_null("TheodoliteLens") as Polygon2D
			if lens: lens.rotation = sin(now * 1.15) * 0.035
			continue
		var accessory := item.get_node_or_null("Accessory") as Sprite2D
		if not accessory: continue
		if kind == "sponge":
			accessory.position.y = -15.0 + sin(now * 1.5 + index) * 0.7
			accessory.rotation = sin(now * 1.0 + index) * 0.012

func _pulse_adaptation(kind: String) -> void:
	for root in adaptations.get_children():
		if root.get_meta("adaptation_kind", "") != kind: continue
		var tween := create_tween()
		tween.tween_property(root, "scale", Vector2(1.22, 0.86), 0.10).set_trans(Tween.TRANS_BACK)
		tween.tween_property(root, "scale", Vector2.ONE, 0.24).set_trans(Tween.TRANS_ELASTIC)

func _update_crisis_visuals() -> void:
	var bleeding := current_phase >= 5
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
		pressure_label.text = "INFECCIÓN %d%%  ·  DAÑO %d%%  ·  BACTERIAS %d" % [roundi(infection), roundi(tissue_damage), _kind_count("bacteria")]
		pressure_label.modulate = Color("a9d38c") if infection < 35.0 and tissue_damage < 35.0 else Color("e9a1a0")
	elif current_phase >= 4:
		pressure_label.text = "SPRAY Y MOCO  ·  PARED BAJO CUSTODIA"
		pressure_label.modulate = Color("77bf69")
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
	var required_event := str(upgrade.get("requires_event", ""))
	if not required_event.is_empty() and int(phase_events.get(required_event, 0)) == 0:
		return false
	if bool(upgrade.get("requires_septum", false)) and not septum_open:
		return false
	if bool(upgrade.get("requires_puncher_unlock", false)) and not puncher_unlocked and current_phase == 1:
		return false
	if bool(upgrade.get("requires_compaction", false)) and not compaction_announced and current_phase == 1:
		return false
	var dependency := str(upgrade.get("requires_upgrade", ""))
	if not dependency.is_empty() and int(levels.get(dependency, 0)) == 0:
		return false
	var dependencies: Array = upgrade.get("requires_upgrades", [])
	for required_id in dependencies:
		if int(levels.get(str(required_id), 0)) == 0:
			return false
	var required_levels: Dictionary = upgrade.get("requires_levels", {})
	for required_id in required_levels:
		if int(levels.get(str(required_id), 0)) < int(required_levels[required_id]):
			return false
	var alternatives: Array = upgrade.get("requires_any_upgrades", [])
	if not alternatives.is_empty():
		var has_alternative := false
		for required_id in alternatives:
			if int(levels.get(str(required_id), 0)) > 0:
				has_alternative = true
				break
		if not has_alternative:
			return false
	if current_phase == phase and phase_work < float(upgrade.get("unlock_at", 0.0)) and int(levels[upgrade.id]) == 0:
		return false
	return true

func _upgrade_lock_reason(upgrade: Dictionary) -> String:
	if current_phase < int(upgrade.phase):
		return "SE DESBLOQUE CUANDO JOE COMETA MÁS LOCURAS"
	var required_event := str(upgrade.get("requires_event", ""))
	if not required_event.is_empty() and int(phase_events.get(required_event, 0)) == 0:
		return "JOE AÚN NO HA PROVOCADO ESTE PROBLEMA"
	if bool(upgrade.get("requires_septum", false)) and not septum_open:
		return "REQUIERE ABRIR EL TABIQUE"
	if bool(upgrade.get("requires_puncher_unlock", false)) and not puncher_unlocked and current_phase == 1:
		return "REQUIERE LA PRIMERA RAYITA DE JOE"
	if bool(upgrade.get("requires_compaction", false)) and not compaction_announced and current_phase == 1:
		return "REQUIERE QUE APAREZCA EL PRIMER PEDRUSCO"
	var dependency := str(upgrade.get("requires_upgrade", ""))
	if not dependency.is_empty() and int(levels.get(dependency, 0)) == 0:
		return "REQUIERE %s" % str(_upgrade(dependency).name)
	var missing: Array[String] = []
	for required_id in upgrade.get("requires_upgrades", []):
		if int(levels.get(str(required_id), 0)) == 0:
			missing.append(str(_upgrade(str(required_id)).name))
	if not missing.is_empty():
		return "REQUIERE " + " + ".join(missing)
	var missing_levels: Array[String] = []
	var required_levels: Dictionary = upgrade.get("requires_levels", {})
	for required_id in required_levels:
		var required_level := int(required_levels[required_id])
		if int(levels.get(str(required_id), 0)) < required_level:
			missing_levels.append("%s NV. %d" % [str(_upgrade(str(required_id)).name), required_level])
	if not missing_levels.is_empty():
		return "REQUIERE " + " + ".join(missing_levels)
	var alternatives: Array = upgrade.get("requires_any_upgrades", [])
	if not alternatives.is_empty():
		var names: Array[String] = []
		var satisfied := false
		for required_id in alternatives:
			if int(levels.get(str(required_id), 0)) > 0: satisfied = true
			names.append(str(_upgrade(str(required_id)).name))
		if not satisfied:
			return "REQUIERE " + " O ".join(names)
	if current_phase == int(upgrade.phase) and phase_work < float(upgrade.get("unlock_at", 0.0)) and int(levels[upgrade.id]) == 0:
		return "AÚN NO HAS EXTRAÍDO LO SUFICIENTE"
	return ""

func _quick_upgrade_effect(upgrade_id: String, level: int) -> String:
	match upgrade_id:
		"nails": return "CLIC %s → %s" % [_number(_click_power_for(level)), _number(_click_power_for(level + 1))]
		"continuous_sweep": return "BARRIDO %.2f → %.2f S" % [_continuous_sweep_interval_for(level), _continuous_sweep_interval_for(level + 1)]
		"pawn": return "+1 PEÓN RECOLECTOR"
		"pawn_capacity": return "CARGA %d → %d" % [_transport_capacity(), _transport_capacity() + 1]
		"smart_clump": return "%d → %d GRANOS POR BOLA  ·  %d → %d POR VIAJE" % [_smart_clump_size(level), _smart_clump_size(level + 1), _transport_capacity() * _smart_clump_size(level), _transport_capacity() * _smart_clump_size(level + 1)]
		"breaker": return "CASCOS %d → %d" % [level, level + 1]
		"detector": return "+1 QUIMIORRECEPTOR"
		"sponge_power":
			var count := maxf(1.0, float(levels.sponge))
			return "SPRAY %s → %s/S" % [_number(count * 40.0 * pow(1.8, level)), _number(count * 40.0 * pow(1.8, level + 1))]
		"repair": return "TEJIDO %s → %s/S" % [_number(_platelet_rate_for(level)), _number(_platelet_rate_for(level + 1))]
	return "MEJORA NUMÉRICA"

func _toggle_upgrade_pin(upgrade_id: String) -> void:
	if upgrade_id in pinned_upgrade_ids:
		_remove_upgrade_pin(upgrade_id)
		_show_toast("OBJETIVO RETIRADO")
	elif pinned_upgrade_ids.size() >= MAX_PINNED_UPGRADES:
		_show_toast("SOLO PUEDES FIJAR %d TECNOLOGÍAS" % MAX_PINNED_UPGRADES)
		return
	else:
		var upgrade := _upgrade(upgrade_id)
		if upgrade.is_empty() or int(levels.get(upgrade_id, 0)) >= int(upgrade.get("max", 1)):
			return
		pinned_upgrade_ids.append(upgrade_id)
		_create_pinned_button(upgrade_id)
		_show_toast("TECNOLOGÍA FIJADA  ·  %s" % str(upgrade.name))
	_update_ui()
	_save()

func _create_pinned_button(upgrade_id: String) -> void:
	if pinned_buttons.has(upgrade_id):
		return
	var row := HBoxContainer.new()
	row.name = "Pinned_" + upgrade_id
	row.add_theme_constant_override("separation", 4)
	var button := Button.new()
	button.custom_minimum_size = Vector2(0.0, 62.0)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 9)
	button.pressed.connect(_buy.bind(upgrade_id))
	var remove := Button.new()
	remove.custom_minimum_size = Vector2(28.0, 62.0)
	remove.text = "×"
	remove.tooltip_text = "Dejar de seguir esta tecnología"
	remove.pressed.connect(_toggle_upgrade_pin.bind(upgrade_id))
	row.add_child(button)
	row.add_child(remove)
	quick_list.add_child(row)
	quick_list.move_child(row, pinned_upgrade_ids.find(upgrade_id))
	pinned_buttons[upgrade_id] = {"row":row, "button":button, "remove":remove}

func _remove_upgrade_pin(upgrade_id: String) -> void:
	pinned_upgrade_ids.erase(upgrade_id)
	var entry: Dictionary = pinned_buttons.get(upgrade_id, {})
	var row := entry.get("row") as Control
	if is_instance_valid(row):
		row.queue_free()
	pinned_buttons.erase(upgrade_id)

func _restore_pinned_upgrades(data: Variant) -> void:
	for upgrade_id in pinned_buttons.keys():
		_remove_upgrade_pin(str(upgrade_id))
	pinned_upgrade_ids.clear()
	if typeof(data) != TYPE_ARRAY:
		return
	for value in data:
		var upgrade_id := str(value)
		var upgrade := _upgrade(upgrade_id)
		if upgrade.is_empty() or upgrade_id in pinned_upgrade_ids:
			continue
		if int(levels.get(upgrade_id, 0)) >= int(upgrade.get("max", 1)):
			continue
		pinned_upgrade_ids.append(upgrade_id)
		_create_pinned_button(upgrade_id)
		if pinned_upgrade_ids.size() >= MAX_PINNED_UPGRADES:
			break

func _update_pinned_access() -> int:
	var visible_count := 0
	for upgrade_id in pinned_upgrade_ids.duplicate():
		var upgrade := _upgrade(upgrade_id)
		var level := int(levels.get(upgrade_id, 0))
		if upgrade.is_empty() or level >= int(upgrade.get("max", 1)):
			_remove_upgrade_pin(upgrade_id)
			continue
		if not pinned_buttons.has(upgrade_id):
			_create_pinned_button(upgrade_id)
		var entry: Dictionary = pinned_buttons[upgrade_id]
		var button := entry.button as Button
		var available := _upgrade_available(upgrade)
		var cost := _upgrade_cost(upgrade, level)
		var status := "◆ %s COCAÍNA" % _number(cost)
		if not available:
			status = "BLOQUEADA  ·  " + _upgrade_lock_reason(upgrade)
		elif cells < cost:
			status += "  ·  FALTAN %s" % _number(cost - cells)
		else:
			status += "  ·  LISTA"
		button.text = "◆ %s  [NV. %d]\n%s" % [str(upgrade.name), level, status]
		button.tooltip_text = "%s\n%s" % [str(upgrade.get("desc", "")), status]
		button.disabled = not available or cells < cost
		button.modulate = Color("86d9e8") if available and cells >= cost else Color.WHITE
		visible_count += 1
	return visible_count

func _update_quick_access() -> void:
	var visible_count := _update_pinned_access()
	for upgrade_id in QUICK_UPGRADE_IDS:
		var button := quick_buttons.get(upgrade_id) as Button
		if not button: continue
		var upgrade := _upgrade(upgrade_id)
		var level := int(levels.get(upgrade_id, 0))
		var max_level := int(upgrade.get("max", 1))
		button.visible = upgrade_id not in pinned_upgrade_ids and level > 0 and level < max_level and _upgrade_available(upgrade)
		if not button.visible: continue
		visible_count += 1
		var cost := _upgrade_cost(upgrade, level)
		button.text = "%s  [NV. %d]\n%s\n◆ %s COCAÍNA" % [upgrade.name, level, _quick_upgrade_effect(upgrade_id, level), _number(cost)]
		button.disabled = cells < cost
	quick_title.text = "OBJETIVOS Y ACCESOS RÁPIDOS" if not pinned_upgrade_ids.is_empty() else "ACCESOS RÁPIDOS"
	quick_title.visible = visible_count > 0
	quick_scroll.visible = visible_count > 0

func _update_ui() -> void:
	var phase := _phase()
	_update_technology_lab()
	_update_quick_access()
	phase_label.text = "FASE %d/%d" % [current_phase, PHASES.size()]
	world_subtitle.text = "FASE %d  ·  %s" % [current_phase, phase.title]
	shop_subtitle.text = phase.joe
	phase_progress.max_value = 1.0
	phase_progress.value = _phase_adaptation_progress()
	phase_hint.text = _joe_intent_hint()
	joe_high_progress.value = joe_high_display
	if joe_high_feedback_clock <= 0.0:
		joe_high_progress.modulate = Color("7b67d8").lerp(Color("ffcc58"), joe_high_display / 100.0)
		if _joe_powder_pressure() > 0.0:
			joe_high_feedback.text = "EL POLVO DE JOE LO MANTIENE ARRIBA"
			joe_high_feedback.modulate = Color("e8b06b")
		else:
			joe_high_feedback.text = "MINA PARA BAJARLO"
			joe_high_feedback.modulate = Color("8bcbd1")
	joe_high_label.text = "COLOCÓN DE JOE  %.1f / 100" % joe_high_display
	cells_label.text = "COCAÍNA  %s / %s" % [_number(cells), _number(_storage_capacity())]
	rate_label.text = "%s / CLIC  ·  AUTO %s / S" % [_number(_click_power()), _number(_auto_hit_rate() + _special_extraction_rate())]
	var tunnel_ready := current_phase >= TUNNEL_UNLOCK_PHASE
	click_counter.text = "DOS FOSAS ACTIVAS" if septum_open else ("TUNELADORA DISPONIBLE" if tunnel_ready else "TUNELADORA  ·  TECNOLOGÍA BLOQUEADA")
	var hp := left_hp if active_side == "left" else right_hp
	var wall_side := "IZQUIERDA" if active_side == "left" else "DERECHA"
	wall_label.text = "PARED %s  ·  RESISTENCIA %s" % [wall_side, _number(maxf(0.0, hp)) if int(levels.wall_scan) > 0 else "???"]
	var required_upgrade := _required_upgrade_id()
	technology_button.text = "★ ADAPTACIÓN NECESARIA\nABRIR LABORATORIO" if not required_upgrade.is_empty() and int(levels.get(required_upgrade, 0)) == 0 else "ABRIR LABORATORIO\nUNIDADES Y TECNOLOGÍAS"
	var selected_unit := _catalog_unit(selected_technology_unit)
	var selected_unit_unlocked := not selected_unit.is_empty() and _technology_unit_unlocked(selected_unit)
	for upgrade in UPGRADES:
		var button := buttons[upgrade.id] as Button
		var pin_button := pin_buttons[upgrade.id] as Button
		var available := _upgrade_available(upgrade)
		button.visible = selected_unit_unlocked and _technology_unit_for_upgrade(str(upgrade.id)) == selected_technology_unit
		pin_button.visible = button.visible
		var level: int = int(levels[upgrade.id])
		var required: bool = str(upgrade.id) == _required_upgrade_id() and level == 0
		button.custom_minimum_size.y = 82.0
		_set_upgrade_halo(button, required)
		if not required: button.add_theme_color_override("font_disabled_color", Color("c4b1c2"))
		if not button.visible: continue
		var cost := _upgrade_cost(upgrade, level)
		var maxed: bool = level >= int(upgrade.get("max", 999))
		pin_button.text = "QUITAR" if str(upgrade.id) in pinned_upgrade_ids else "FIJAR"
		pin_button.disabled = maxed
		pin_button.tooltip_text = "Dejar de seguir esta tecnología" if str(upgrade.id) in pinned_upgrade_ids else "Mostrar esta tecnología junto a los accesos rápidos"
		var evolution_locked: bool = upgrade.kind == "auto_power" and _punch_evolution_locked() and not maxed
		var effect := "CLIC %s → %s" % [_number(_click_power_for(level)), _number(_click_power_for(level + 1))]
		if upgrade.kind == "pawn": effect = "+1 peón"
		elif upgrade.kind == "pawn_capacity": effect = "CARGA POR PEÓN  %d → %d" % [_transport_capacity(), _transport_capacity() + 1]
		elif upgrade.kind == "smart_clump": effect = "%d → %d GRANOS POR BOLA  ·  CARGA TOTAL %d → %d" % [_smart_clump_size(level), _smart_clump_size(level + 1), _transport_capacity() * _smart_clump_size(level), _transport_capacity() * _smart_clump_size(level + 1)]
		elif upgrade.kind == "pawn_renaissance": effect = "BOLA BLANDA  %d → %d GRANOS" % [_smart_clump_size(), SMART_CLUMP_RENAISSANCE_SIZES[clampi(level + 1, 0, SMART_CLUMP_RENAISSANCE_SIZES.size() - 1)]]
		elif upgrade.kind == "speed": effect = "VELOCIDAD DE PEONES +50%"
		elif upgrade.kind == "storage":
			var next_storage := float(upgrade.power)
			if str(upgrade.id) == "plant_buffer": next_storage = float(STORAGE_CAPACITIES[10 + clampi(level, 0, 1)])
			elif str(upgrade.id) == "plant_capacity": next_storage = float(STORAGE_CAPACITIES[12 + clampi(level, 0, 2)])
			effect = ("CAPACIDAD %s" if maxed else "NUEVO LÍMITE %s") % _number(next_storage)
		elif upgrade.kind == "transport_cart": effect = "12 GRANOS POR VIAJE  ·  NO MINA"
		elif upgrade.kind == "transport_capacity": effect = "CARGA DEL CARRITO  %s → %s" % [_number(_cart_capacity()), _number(float(upgrade.power))]
		elif upgrade.kind == "cart_renaissance": effect = "CARRITO CLÁSICO  %s → %s POR VIAJE" % [_number(_cart_capacity()), _number(float(CART_RENAISSANCE_CAPACITIES[clampi(level + 1, 0, CART_RENAISSANCE_CAPACITIES.size() - 1)]))]
		elif upgrade.kind == "transport_ox": effect = "%s GRANOS POR VIAJE  ·  NO MINA" % _number(_ox_capacity())
		elif upgrade.kind == "transport_ox_capacity":
			var next_ox_level := int(levels.get("ox_capacity", 0)) + int(levels.get("ox_heavy_capacity", 0)) + 1
			if str(upgrade.id) == "ox_vault_capacity": next_ox_level = 5 + level
			elif str(upgrade.id) == "ox_plasma_capacity": next_ox_level = 9 + level
			var next_ox_capacity := _ox_capacity(next_ox_level)
			effect = "CARGA DEL MUGIDÓFILO  %s → %s" % [_number(_ox_capacity()), _number(next_ox_capacity)]
		elif upgrade.kind == "transport_speed":
			var cart_upgrade := str(upgrade.id) == "cart_speed"
			var vehicle := "CARRITO" if cart_upgrade else "MUGIDÓFILO"
			var base_speed := CART_SPEED if cart_upgrade else OX_SPEED
			var step := 0.40 if cart_upgrade else 0.50
			var current_speed := _ground_transport_speed(base_speed)
			var next_speed := base_speed * (1.0 + step * float(level + 1))
			effect = "VELOCIDAD DEL %s  %s → %s" % [vehicle, _number(current_speed), _number(next_speed)]
		elif upgrade.kind == "transport_train": effect = "RECOGE TODO EL POLVO SUELTO  ·  NO MINA"
		elif upgrade.kind == "train_speed":
			var next_train_speed := TRAIN_SPEED * float([1.0, 1.6, 2.5][clampi(level + 1, 0, 2)])
			effect = "VELOCIDAD DEL EXPRESO  %s → %s" % [_number(_train_speed()), _number(next_train_speed)]
		elif upgrade.kind == "coordination": effect = "reparto entre fosas" if level == 0 else "prioridad a pedruscos"
		elif upgrade.kind == "specialist": effect = "+1 CASCO AZUL  ·  %d → %d ESPECIALISTAS" % [level, level + 1]
		elif upgrade.kind == "specialist_power": effect = "DAÑO AL PEDRUSCO  %d → %d" % [1 + level, 2 + level]
		elif upgrade.kind == "detector": effect = "NORMALES IGNORAN BASURA  ·  +1 FILTRADOR"
		elif upgrade.kind == "sorting": effect = "-8% de impurezas por nivel"
		elif upgrade.kind == "platelet": effect = "+2 plaquetas visibles"
		elif upgrade.kind == "repair": effect = "REPARACIÓN %s → %s TEJIDO/S" % [_number(_platelet_rate_for(level)), _number(_platelet_rate_for(level + 1))]
		elif upgrade.kind == "handler": effect = "+1 cuidador con guantes"
		elif upgrade.kind == "signals": effect = "+12% coordinación de crisis"
		elif upgrade.kind == "autoclicker": effect = "+1 púgil automático"
		elif upgrade.kind == "punch_union": effect = "+2 PÚGILES BÁSICOS  ·  50 DAÑO CADA UNO"
		elif upgrade.kind == "punch_training": effect = "DAÑO DE TODA LA CUADRILLA  ×3"
		elif upgrade.kind == "punch_multiplier": effect = "DAÑO DE TODA LA CUADRILLA  ×2"
		elif upgrade.kind == "punch_reserves": effect = "+2 PÚGILES BÁSICOS"
		elif upgrade.kind == "punch_combo": effect = "CADA TERCERA RONDA  ·  DAÑO ×2"
		elif upgrade.kind == "punch_late_speed": effect = "INTERVALO %.2f → %.2f S" % [_punch_interval(), _punch_interval() * 0.75]
		elif upgrade.kind == "punch_collective": effect = "DAÑO DE TODA LA CUADRILLA  ×3"
		elif upgrade.kind == "punch_renaissance": effect = "CUADRILLA CLÁSICA  ×%d → ×%d" % [PUNCH_RENAISSANCE_MULTIPLIERS[clampi(level, 0, PUNCH_RENAISSANCE_MULTIPLIERS.size() - 1)], PUNCH_RENAISSANCE_MULTIPLIERS[clampi(level + 1, 0, PUNCH_RENAISSANCE_MULTIPLIERS.size() - 1)]]
		elif upgrade.kind == "auto_power":
			if evolution_locked:
				effect = "SIGUIENTE EVOLUCIÓN EN FASE %d" % mini(PHASES.size(), level + 2)
			else:
				var training_multiplier := (3.0 if int(levels.get("punch_training", 0)) > 0 else 1.0) * (2.0 if int(levels.get("bronchial_rage", 0)) > 0 else 1.0) * (3.0 if int(levels.get("punch_collective", 0)) > 0 else 1.0)
				var current_ball := float(PUGILIST_DAMAGE[clampi(level, 0, PUGILIST_DAMAGE.size() - 1)]) * training_multiplier / float(PUGILIST_GRAINS_PER_HIT)
				var next_ball := float(PUGILIST_DAMAGE[clampi(level + 1, 0, PUGILIST_DAMAGE.size() - 1)]) * training_multiplier / float(PUGILIST_GRAINS_PER_HIT)
				effect = "%d BOLAS DE %s → %s" % [PUGILIST_GRAINS_PER_HIT, _number(current_ball), _number(next_ball)]
		elif upgrade.kind == "wall_scan": effect = "REVELA LA RESISTENCIA EXACTA"
		elif upgrade.kind == "auto_speed":
			var rank := clampi(int(levels.punch_power), 0, PUGILIST_INTERVALS.size() - 1)
			effect = "INTERVALO %.2f → %.2f S" % [float(PUGILIST_INTERVALS[rank]), float(PUGILIST_INTERVALS[rank]) * 0.625]
		elif upgrade.kind == "manual_sweep": effect = "MANTENER PULSADO  ·  %.2f S POR GRANO" % _continuous_sweep_interval_for(level + 1)
		elif upgrade.kind == "click_burst": effect = "RÁFAGA  %d BOLAS DE %s" % [level if maxed else level + 1, _number(_click_power())]
		elif upgrade.kind == "click_rhythm": effect = "-1 clic para provocar la ráfaga"
		elif upgrade.kind in ["sponge", "sponge_power"]:
			var future_sponges := level + 1 if upgrade.kind == "sponge" else int(levels.sponge)
			var future_foam := level + 1 if upgrade.kind == "sponge_power" else int(levels.sponge_power)
			effect = "ABSORBE %s UNIDADES DE SPRAY/S" % _number(float(future_sponges) * 40.0 * pow(1.8, future_foam))
		elif upgrade.kind == "ram": effect = "EMBESTIDA %s  ·  CADA 8 S" % _number(_future_special_damage("ram", level + 1))
		elif upgrade.kind == "ram_power": effect = "EMBESTIDA %s → %s" % [_number(float(RAM_DAMAGE[clampi(level, 0, RAM_DAMAGE.size() - 1)])), _number(float(RAM_DAMAGE[clampi(level + 1, 0, RAM_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "ram_speed": effect = "CARRERILLA  8 → 6 S"
		elif upgrade.kind == "elephant": effect = "CABEZAZO %s  ·  CADA 20 S" % _number(_future_special_damage("elephant", level + 1))
		elif upgrade.kind == "elephant_power": effect = "CABEZAZO %s → %s" % [_number(float(ELEPHANT_DAMAGE[clampi(level, 0, ELEPHANT_DAMAGE.size() - 1)])), _number(float(ELEPHANT_DAMAGE[clampi(level + 1, 0, ELEPHANT_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "hammer": effect = "MARTILLAZO %s  ·  CADA 4 S" % _number(_future_special_damage("hammer", level + 1))
		elif upgrade.kind == "hammer_power": effect = "MARTILLAZO %s → %s" % [_number(float(HAMMER_DAMAGE[clampi(level, 0, HAMMER_DAMAGE.size() - 1)])), _number(float(HAMMER_DAMAGE[clampi(level + 1, 0, HAMMER_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "plasma_cannon": effect = "DESCARGA %s  ·  CADA 14 S" % _number(_future_special_damage("plasma", level + 1))
		elif upgrade.kind == "plasma_power": effect = "PLASMA %s → %s" % [_number(float(PLASMA_DAMAGE[clampi(level, 0, PLASMA_DAMAGE.size() - 1)])), _number(float(PLASMA_DAMAGE[clampi(level + 1, 0, PLASMA_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "meteor": effect = "IMPACTO %s  ·  CADA 12 S" % _number(_future_special_damage("meteor", level + 1))
		elif upgrade.kind == "meteor_power": effect = "IMPACTO %s → %s" % [_number(float(METEOR_DAMAGE[clampi(level, 0, METEOR_DAMAGE.size() - 1)])), _number(float(METEOR_DAMAGE[clampi(level + 1, 0, METEOR_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "supersaiyan": effect = "KAMEHAMEHA %s  ·  CADA 50 S" % _number(_future_special_damage("supersaiyan", level + 1))
		elif upgrade.kind == "supersaiyan_power": effect = "KAMEHAMEHA %s → %s" % [_number(float(SUPERSAIYAN_DAMAGE[clampi(level, 0, SUPERSAIYAN_DAMAGE.size() - 1)])), _number(float(SUPERSAIYAN_DAMAGE[clampi(level + 1, 0, SUPERSAIYAN_DAMAGE.size() - 1)]))]
		elif upgrade.kind == "catapult": effect = "+1 LANZAMIENTO DE %s" % _number(CATAPULT_BASE_DAMAGE * pow(2.0, int(levels.catapult_power)))
		elif upgrade.kind == "catapult_power": effect = "IMPACTO %s → %s" % [_number(CATAPULT_BASE_DAMAGE * pow(2.0, level)), _number(CATAPULT_BASE_DAMAGE * pow(2.0, level + 1))]
		var emergency_detector := _emergency_detector_available(upgrade, level)
		var price_line := "◆ RESCATE DE URGENCIAS  ·  GRATIS" if emergency_detector else "◆ COSTE  %s COCAÍNA" % _number(cost)
		if maxed:
			price_line = "✓ MEJORA COMPLETA"
		elif not available:
			price_line = "🔒 " + _upgrade_lock_reason(upgrade)
		elif cells < cost:
			price_line += "  ·  FALTAN %s" % _number(cost - cells)
		var title_prefix := "★ NECESARIA  ·  " if required else ""
		button.text = "%s%s  [NV. %d]\n%s\n%s\n%s" % [title_prefix, upgrade.name, level, price_line, upgrade.desc, effect]
		button.disabled = not available or cells < cost or maxed or evolution_locked

func _high_state() -> String:
	if joe_high_display < 25.0: return "CASI SERENO"
	if joe_high_display < 50.0: return "ANIMADO"
	if joe_high_display < 75.0: return "FINO FILIPINO"
	if joe_high_display < 100.0: return "VIENDO SONIDOS"
	return "KO TÉCNICO"

func _joe_intent_hint() -> String:
	if current_phase >= PHASES.size():
		return "JOE ESTÁ COMPLETAMENTE DESATADO."
	var progress := _phase_adaptation_progress()
	if progress >= 0.82: return "JOE ESTÁ A PUNTO DE COMETER UNA LOCURA."
	if progress >= 0.42: return "JOE ESTÁ INQUIETO."
	return "JOE ESTÁ COLOCADO."

func _required_upgrade_id() -> String:
	if current_phase == 1:
		if compaction_announced and int(levels.breaker) == 0: return "breaker"
		if puncher_unlocked and int(levels.puncher) == 0: return "puncher"
		if int(levels.container) == 0 and phase_work >= 150.0: return "container"
		if int(levels.container) > 0 and int(levels.cart) == 0: return "cart"
		if int(levels.pawn) + int(levels.shift) == 0: return "pawn"
	if current_phase == 2:
		if int(levels.breaker) == 0: return "breaker"
		return ""
	if current_phase == 3: return "detector"
	if current_phase == 4: return "sponge" if int(levels.sponge) == 0 else "catapult"
	if current_phase == 5: return "platelets" if int(levels.platelets) == 0 else "handlers"
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
	var unit_id := _technology_unit_for_upgrade(required)
	if not unit_id.is_empty(): selected_technology_unit = unit_id
	_update_ui()
	var button := buttons.get(required) as Button
	if technology_lab.visible and button and button.visible:
		_scroll_to_required_upgrade(button)

func _scroll_to_required_upgrade(button: Button) -> void:
	if not technology_lab.visible: return
	await get_tree().process_frame
	upgrade_scroll.ensure_control_visible(button)
	var target := button.position.y + button.size.y - upgrade_scroll.size.y + 8.0
	upgrade_scroll.scroll_vertical = maxi(0, roundi(target))

func _phase_adaptation_progress() -> float:
	if current_phase >= PHASES.size(): return 1.0
	var phase_start := float(PHASE_HIGH_THRESHOLDS[current_phase - 1])
	var next_threshold := float(PHASE_HIGH_THRESHOLDS[current_phase])
	return clampf((phase_start - joe_high) / maxf(1.0, phase_start - next_threshold), 0.0, 1.0)

func _phase_requirement() -> String:
	if current_phase >= PHASES.size(): return "JOE SIGUE VIVO. DE MOMENTO."
	var threshold := float(PHASE_HIGH_THRESHOLDS[current_phase])
	return "SIGUIENTE LOCURA AL %d%%  ·  FALTAN %d PUNTOS" % [roundi(threshold), maxi(0, ceili(joe_high - threshold))]

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
	var target: Node2D
	for child in infrastructure.get_children():
		if bool(child.get_meta("storage_visual", false)):
			target = child as Node2D
			break
	if target:
		var tween := create_tween()
		tween.tween_property(target, "scale", Vector2(1.04, 0.96), 0.05)
		tween.tween_property(target, "scale", Vector2.ONE, 0.1)
	else:
		var tween := create_tween()
		tween.tween_property(box, "rotation", -0.025, 0.05)
		tween.tween_property(box, "rotation", 0.0, 0.1)

func _show_toast(message: String, duration := 3.8) -> void:
	if toast_tween and toast_tween.is_valid():
		toast_tween.kill()
	toast.text = message
	toast.modulate.a = 0.0
	toast_tween = create_tween()
	toast_tween.tween_property(toast, "modulate:a", 1.0, 0.15)
	toast_tween.tween_interval(maxf(1.0, duration))
	toast_tween.tween_property(toast, "modulate:a", 0.0, 0.3)

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

func _serialize_pile_compact() -> Array:
	var columns := {}
	for piece in loose_chunks:
		if not is_instance_valid(piece) or not piece.alive:
			continue
		var key := "%s:%d" % [piece.get_meta("side", "right"), int(piece.get_meta("column", 0))]
		if not columns.has(key):
			columns[key] = []
		(columns[key] as Array).append(piece)
	var data: Array = []
	for pieces_value in columns.values():
		var pieces: Array = pieces_value
		pieces.sort_custom(func(a: PilePiece, b: PilePiece) -> bool: return a.position.y > b.position.y)
		var first := pieces[0] as PilePiece
		var runs: Array = []
		for piece_value in pieces:
			var piece := piece_value as PilePiece
			var signature := [str(piece.get_meta("kind", "grain")), str(piece.get_meta("material", "")), str(piece.get_meta("source", "player")), float(piece.get_meta("value", 1.0)), int(piece.get_meta("hardness", 0)), int(piece.get_meta("max_hardness", 0))]
			if not runs.is_empty() and (runs.back() as Array).slice(0, 6) == signature:
				(runs.back() as Array)[6] = int((runs.back() as Array)[6]) + 1
			else:
				signature.append(1)
				runs.append(signature)
		data.append([str(first.get_meta("side", "right")), int(first.get_meta("column", 0)), runs])
	return data

func _serialize_fallen_wall_chunks() -> Array:
	var data: Array = []
	for chunk in fallen_wall_chunks:
		if is_instance_valid(chunk):
			data.append({"side":chunk.get_meta("side", "right"), "fracture":int(chunk.get_meta("fracture_number", 1)), "slot":int(chunk.get_meta("slot", 0)), "hp":float(chunk.get_meta("hp", WALL_CHUNK_HEALTH)), "max_hp":float(chunk.get_meta("max_hp", WALL_CHUNK_HEALTH)), "mass":float(chunk.get_meta("mass", WALL_CHUNK_MASS)), "max_mass":float(chunk.get_meta("max_mass", WALL_CHUNK_MASS))})
	return data

func _clear_pile() -> void:
	particle_motions.clear()
	manual_reserved_units = 0.0
	for piece in loose_chunks:
		if is_instance_valid(piece): piece.queue_free()
	loose_chunks.clear()
	_reset_pile_index()

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

func _restore_pile_compact(data: Variant) -> void:
	_clear_pile()
	if typeof(data) != TYPE_ARRAY:
		return
	for column_value in data:
		if typeof(column_value) != TYPE_ARRAY or (column_value as Array).size() < 3:
			continue
		var column_data: Array = column_value
		var side := str(column_data[0])
		var column := int(column_data[1])
		for run_value in column_data[2]:
			if typeof(run_value) != TYPE_ARRAY or (run_value as Array).size() < 7:
				continue
			var run: Array = run_value
			var kind := str(run[0])
			var hardness := int(run[4])
			var scale := 0.18 if kind == "rock" else (0.084 if kind == "impurity" else (0.078 if kind == "bacteria" else 0.072))
			for amount in range(maxi(0, int(run[6]))):
				var piece := _create_piece(kind, side, float(run[3]), int(run[5]), column, scale, str(run[1]), str(run[2]))
				piece.set_meta("hardness", hardness)
				if kind == "rock" and hardness == 0:
					piece.modulate = Color("eef4e7")
					var crack := piece.get_node_or_null("Crack") as Line2D
					if crack: crack.visible = true
	_rebuild_pile_index()
	_restack_pile()

func _save() -> void:
	if overdose_active or (not playing and not phase_event_pending): return
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify({
			"version":SAVE_VERSION, "cells":cells,
			"pinned_upgrades":pinned_upgrade_ids,
			"right_hp":right_hp, "right_max":right_max, "left_hp":left_hp, "left_max":left_max,
			"right_cleared":right_cleared, "left_cleared":left_cleared,
			"septum_open":septum_open, "active_side":active_side, "levels":levels,
			"total_clicks":total_clicks, "pile_compact":_serialize_pile_compact(), "fallen_wall_chunks":_serialize_fallen_wall_chunks(),
			"compaction_steps":compaction_steps, "compaction_announced":compaction_announced,
			"current_phase":current_phase, "phase_work":phase_work, "phase_events":phase_events, "joe_high":joe_high, "victory_reached":victory_reached,
			"contamination":contamination, "box_jammed":box_jammed, "tissue_damage":tissue_damage, "infection":infection,
			"impurities_handled":impurities_handled, "bacteria_handled":bacteria_handled,
			"rocks_opened":rocks_opened, "impurities_cleaned":impurities_cleaned, "tissue_repaired":tissue_repaired,
			"another_line_clock":another_line_clock, "another_line_wave":another_line_wave, "another_line_spawn_index":another_line_spawn_index, "another_line_events":another_line_events,
			"mined_since_line":mined_since_line, "pending_line_grains":pending_line_grains, "current_line_grains":current_line_grains, "last_line_grains":last_line_grains,
			"chalk_clock":chalk_clock, "spray_clock":spray_clock, "spray_pending":spray_pending, "spray_followup_clock":spray_followup_clock, "spray_side":spray_side,
			"spray_film_hp":spray_film_hp, "spray_film_max":spray_film_max,
			"scratch_clock":scratch_clock, "mucus_clock":mucus_clock, "mucus_hp":mucus_hp, "mucus_max_hp":mucus_max_hp, "catapult_clock":catapult_clock,
			"puncher_unlocked":puncher_unlocked, "puncher_debut_pending":puncher_debut_pending,
			"puncher_debut_clock":puncher_debut_clock, "unit_debuts_seen":unit_debuts_seen, "unit_debut_pending":unit_debut_pending,
			"punch_round_count":punch_round_count, "manual_clicks_since_burst":manual_clicks_since_burst,
			"phase_event_pending":phase_event_pending
		}))

func _load() -> void:
	if not FileAccess.file_exists(save_path): return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if typeof(data) != TYPE_DICTIONARY or int(data.get("version", 0)) != SAVE_VERSION:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		return
	cells = float(data.get("cells", 0.0))
	right_hp = float(data.get("right_hp", FIRST_WALL_HP))
	right_max = float(data.get("right_max", FIRST_WALL_HP))
	left_hp = float(data.get("left_hp", FIRST_LEFT_WALL_HP))
	left_max = float(data.get("left_max", FIRST_LEFT_WALL_HP))
	# Conserva exactamente el porcentaje excavado al ampliar la escala de las
	# paredes. Una partida anterior no recibe una pared curada ni una de papel.
	if right_max > 0.0 and right_max < FIRST_WALL_HP:
		right_hp = clampf(right_hp / right_max, 0.0, 1.0) * FIRST_WALL_HP
		right_max = FIRST_WALL_HP
	if left_max > 0.0 and left_max < FIRST_LEFT_WALL_HP:
		left_hp = clampf(left_hp / left_max, 0.0, 1.0) * FIRST_LEFT_WALL_HP
		left_max = FIRST_LEFT_WALL_HP
	right_cleared = int(data.get("right_cleared", 0))
	left_cleared = int(data.get("left_cleared", 0))
	total_clicks = int(data.get("total_clicks", 0))
	septum_open = bool(data.get("septum_open", false))
	active_side = str(data.get("active_side", "right"))
	levels = _empty_levels()
	var saved_levels: Dictionary = data.get("levels", {})
	for id in saved_levels:
		if levels.has(id): levels[id] = int(saved_levels[id])
	# Migración semántica: el antiguo cañón de púgiles se convierte en plasma
	# sin hacer perder una compra válida a quien continúe una partida reciente.
	if int(levels.plasma_cannon) == 0 and int(saved_levels.get("pugilist_cannon", 0)) > 0:
		levels.plasma_cannon = int(saved_levels.pugilist_cannon)
	if int(levels.plasma_power) == 0 and int(saved_levels.get("cannon_power", 0)) > 0:
		levels.plasma_power = int(saved_levels.cannon_power)
	var saved_pugilist_debut_pending := bool(data.get("puncher_debut_pending", false))
	unit_debuts_seen = {}
	var saved_debuts = data.get("unit_debuts_seen", {})
	if data.has("unit_debuts_seen") and typeof(saved_debuts) == TYPE_DICTIONARY:
		for kind in saved_debuts:
			unit_debuts_seen[str(kind)] = bool(saved_debuts[kind])
	else:
		# Una partida anterior ya ha visto las unidades que posee. Así el cambio de
		# versión no reproduce seis celebraciones seguidas al pulsar Continuar.
		unit_debuts_seen = {
			"pugilist":int(levels.puncher) > 0 and not saved_pugilist_debut_pending,
			"ram":int(levels.ram) > 0, "elephant":int(levels.elephant) > 0,
			"hammer":int(levels.hammer) > 0, "plasma":int(levels.plasma_cannon) > 0,
			"meteor":int(levels.meteor) > 0, "supersaiyan":int(levels.supersaiyan) > 0
		}
	unit_debut_pending = {}
	var saved_debut_pending = data.get("unit_debut_pending", {})
	if typeof(saved_debut_pending) == TYPE_DICTIONARY:
		for kind in saved_debut_pending:
			if bool(saved_debut_pending[kind]) and not bool(unit_debuts_seen.get(str(kind), false)):
				unit_debut_pending[str(kind)] = true
	_restore_pinned_upgrades(data.get("pinned_upgrades", []))
	_restore_pile_compact(data.get("pile_compact", []))
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
	phase_events = {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
	var saved_phase_events = data.get("phase_events", {})
	if typeof(saved_phase_events) == TYPE_DICTIONARY:
		for event_name in phase_events:
			phase_events[event_name] = maxi(0, int(saved_phase_events.get(event_name, 0)))
	var legacy_health := clampf(float(data.get("joe_health", 100.0 - JOE_STARTING_HIGH)), 0.0, 100.0)
	joe_high = clampf(float(data.get("joe_high", 100.0 - legacy_health)), 0.0, 100.0)
	joe_high_display = joe_high
	victory_reached = bool(data.get("victory_reached", false))
	victory_active = false
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
	mined_since_line = maxf(0.0, float(data.get("mined_since_line", 0.0)))
	pending_line_grains = maxi(1, int(data.get("pending_line_grains", ANOTHER_LINE_GRAIN_TIERS[0])))
	current_line_grains = maxi(another_line_wave, int(data.get("current_line_grains", another_line_wave)))
	last_line_grains = maxi(1, int(data.get("last_line_grains", ANOTHER_LINE_GRAIN_TIERS[0])))
	chalk_clock = clampf(float(data.get("chalk_clock", CHALK_INTERVAL)), 0.0, CHALK_INTERVAL)
	spray_clock = clampf(float(data.get("spray_clock", SPRAY_INTERVAL)), 0.0, SPRAY_INTERVAL)
	spray_pending = bool(data.get("spray_pending", false))
	spray_followup_clock = clampf(float(data.get("spray_followup_clock", 0.0)), 0.0, SPRAY_FOLLOWUP)
	spray_side = str(data.get("spray_side", active_side))
	spray_film_hp = maxf(0.0, float(data.get("spray_film_hp", 0.0)))
	spray_film_max = maxf(spray_film_hp, float(data.get("spray_film_max", spray_film_hp)))
	scratch_clock = clampf(float(data.get("scratch_clock", SCRATCH_INTERVAL)), 0.0, SCRATCH_INTERVAL)
	mucus_clock = clampf(float(data.get("mucus_clock", MUCUS_INTERVAL)), 0.0, MUCUS_INTERVAL)
	mucus_hp = maxf(0.0, float(data.get("mucus_hp", 0.0)))
	mucus_max_hp = maxf(mucus_hp, float(data.get("mucus_max_hp", mucus_hp)))
	catapult_clock = maxf(0.0, float(data.get("catapult_clock", 0.0)))
	puncher_unlocked = bool(data.get("puncher_unlocked", current_phase >= 2 or int(levels.puncher) > 0))
	puncher_debut_pending = saved_pugilist_debut_pending
	puncher_debut_clock = maxf(0.0, float(data.get("puncher_debut_clock", 0.0)))
	punch_round_count = maxi(0, int(data.get("punch_round_count", 0)))
	manual_clicks_since_burst = maxi(0, int(data.get("manual_clicks_since_burst", 0)))
	manual_mining_click_times.clear()
	another_line_warned = another_line_clock <= ANOTHER_LINE_WARNING
	another_line_drop_clock = 0.0
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	punch_round_count = 0
	# Las versiones antiguas podían guardar una ventana de fase pendiente. Las
	# transiciones actuales son mensajes no modales, así que nunca se restaura.
	phase_event_pending = false
	overdose_active = false
	victory_active = false

func _continue_game() -> void:
	_load()
	_begin_game()

func _discard_obsolete_save() -> void:
	if not FileAccess.file_exists(save_path):
		return
	var data = JSON.parse_string(FileAccess.get_file_as_string(save_path))
	if typeof(data) != TYPE_DICTIONARY or int(data.get("version", 0)) != SAVE_VERSION:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))

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
	_restore_pinned_upgrades([])
	compaction_steps = {"left":0, "right":0}
	compaction_announced = false
	current_phase = 1
	phase_work = 0.0
	phase_events = {"line":0, "chalk":0, "spray":0, "scratch":0, "mucus":0}
	joe_high = JOE_STARTING_HIGH
	joe_high_display = joe_high
	victory_active = false
	victory_reached = false
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
	bacteria_clock = 0.0
	blood_drop_clock = 0.0
	punch_clock = 0.0
	another_line_clock = ANOTHER_LINE_INTERVAL
	another_line_wave = 0
	another_line_drop_clock = 0.0
	another_line_spawn_index = 0
	another_line_events = 0
	another_line_warned = false
	mined_since_line = 0.0
	pending_line_grains = int(ANOTHER_LINE_GRAIN_TIERS[0])
	current_line_grains = 0
	last_line_grains = int(ANOTHER_LINE_GRAIN_TIERS[0])
	chalk_clock = CHALK_INTERVAL
	spray_clock = SPRAY_INTERVAL
	spray_followup_clock = 0.0
	spray_pending = false
	spray_film_hp = 0.0
	spray_film_max = 0.0
	spray_feedback_clock = 0.0
	scratch_clock = SCRATCH_INTERVAL
	mucus_clock = MUCUS_INTERVAL
	mucus_hp = 0.0
	mucus_max_hp = 0.0
	catapult_clock = 0.0
	puncher_unlocked = false
	puncher_debut_pending = false
	puncher_debut_clock = 0.0
	unit_debuts_seen = {}
	unit_debut_pending = {}
	manual_clicks_since_burst = 0
	manual_mining_click_times.clear()
	overdose_active = false
	phase_event_pending = true
	_clear_pile()
	_clear_fallen_wall_chunks()
	if FileAccess.file_exists(save_path): DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	_begin_game()

func _begin_game() -> void:
	overdose_active = false
	victory_active = false
	user_paused = false
	pause_overlay.hide()
	pause_button.text = "PAUSAR PARTIDA"
	continuous_sweep_held = false
	continuous_sweep_clock = 0.0
	playing = not phase_event_pending
	start_screen.hide()
	options_menu.hide()
	technology_lab.hide()
	shop.show()
	camera_x = _closed_camera_min()
	_rebuild_pawns()
	_rebuild_punchers()
	_rebuild_platelets()
	_rebuild_adaptations()
	_rebuild_infrastructure()
	_rebuild_transporters()
	_rebuild_joe_event_visuals()
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

func _manual_save() -> void:
	_save()
	_play_sfx(SFX_SAVE, -8.0)
	_update_start_screen()
	_show_toast("PARTIDA GUARDADA  ·  JOE SIGUE VIVO DE MOMENTO")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and not key.echo and (key.keycode == KEY_SPACE or key.physical_keycode == KEY_SPACE):
			# La barra espaciadora controla el ritmo de la partida, no la pared.
			# Se ignora mientras el jugador está navegando un panel superpuesto.
			if playing and not technology_lab.visible and not options_menu.visible:
				_toggle_pause()
				get_viewport().set_input_as_handled()
			return
	if not event is InputEventMouseButton:
		return
	var click := event as InputEventMouseButton
	if click.button_index != MOUSE_BUTTON_LEFT:
		return
	if not click.pressed:
		continuous_sweep_held = false
		return
	if user_paused or not playing or not stage_view.get_global_rect().has_point(click.position):
		return
	var world_pos := stage.get_global_transform_with_canvas().affine_inverse() * click.position
	if _manual_mine_fallen_wall_chunk(world_pos):
		continuous_sweep_held = false
		get_viewport().set_input_as_handled()
	elif _manual_collect_at(world_pos):
		continuous_sweep_held = int(levels.get("continuous_sweep", 0)) > 0
		continuous_sweep_clock = _continuous_sweep_interval()
		get_viewport().set_input_as_handled()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and (key.keycode == KEY_SPACE or key.physical_keycode == KEY_SPACE):
			return
	if playing and event.is_action_pressed("ui_cancel"):
		if technology_lab.visible: _close_technology_lab()
		elif options_menu.visible: _close_options_menu()
		else: _open_options_menu()
		get_viewport().set_input_as_handled()
		return
	if playing and not user_paused and event.is_action_pressed("ui_accept"): _click_wall(active_side)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save()
		get_tree().quit()
