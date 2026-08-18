extends SceneTree

var failures: Array[String] = []

func _check(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
		push_error(message)

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var packed := load("res://scenes/main.tscn") as PackedScene
	var game := packed.instantiate()
	root.add_child(game)
	await process_frame
	await process_frame
	game.save_path = "user://big_nose_joe_pinned_test.save"
	game._new_game()
	game.phase_event_pending = false
	game.joe_dialog.hide()
	game.playing = false

	game._toggle_upgrade_pin("nails")
	game._toggle_upgrade_pin("container")
	game._toggle_upgrade_pin("supersaiyan")
	game._toggle_upgrade_pin("wall_scan")
	_check(game.pinned_upgrade_ids == ["nails", "container", "supersaiyan"], "Only three chosen technologies may remain pinned.")
	_check(game.pinned_buttons.size() == 3, "Every pinned objective must own one compact access row.")
	var locked_button := (game.pinned_buttons.supersaiyan as Dictionary).button as Button
	_check(locked_button.disabled and "SE DESBLOQUE" in locked_button.text, "A future pinned technology must expose its blocking condition without being purchasable.")

	game.cells = 100000.0
	game.phase_work = 1000.0
	game._buy("nails")
	_check("nails" in game.pinned_upgrade_ids and int(game.levels.nails) == 1, "A repeatable technology must stay pinned after buying one level.")
	game._buy("container")
	_check("container" not in game.pinned_upgrade_ids and int(game.levels.container) == 1, "A completed one-off technology must disappear from pinned objectives.")
	game._toggle_upgrade_pin("puncher")
	_check("puncher" in game.pinned_upgrade_ids, "The freed pin slot must be reusable immediately.")

	game.playing = true
	game._save()
	var saved = JSON.parse_string(FileAccess.get_file_as_string(game.save_path))
	_check(saved.get("pinned_upgrades", []) == game.pinned_upgrade_ids, "Pinned objectives must persist in the save file.")
	if FileAccess.file_exists(game.save_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(game.save_path))
	if failures.is_empty():
		print("PINNED_TECHNOLOGY_SMOKE_OK")
		quit(0)
	else:
		quit(1)
