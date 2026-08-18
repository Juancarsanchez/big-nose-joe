class_name PilePiece
extends RefCounted

var renderer
var render_key := ""
var render_slot := -1
var alive := true
var texture: Texture2D
var material: Material
var crack: Line2D

var position := Vector2.ZERO:
	set(value):
		position = value
		_mark_dirty()
var rotation := 0.0:
	set(value):
		rotation = value
		_mark_dirty()
var scale := Vector2.ONE:
	set(value):
		scale = value
		_mark_dirty()
var visible := true:
	set(value):
		visible = value
		if renderer:
			renderer.refresh_group(self)
var modulate := Color.WHITE:
	set(value):
		modulate = value
		_mark_dirty()
var z_index := 0:
	set(value):
		z_index = value
		_mark_dirty()

func _mark_dirty() -> void:
	if renderer:
		renderer.mark_dirty(self)

func add_child(node: Node) -> void:
	if node is Line2D and node.name == "Crack":
		crack = node as Line2D
		if renderer:
			renderer.attach_auxiliary(crack)

func get_node_or_null(path: NodePath) -> Node:
	return crack if str(path) == "Crack" and is_instance_valid(crack) else null

func queue_free() -> void:
	if not alive:
		return
	alive = false
	if renderer:
		renderer.remove_piece(self)
	if is_instance_valid(crack):
		crack.queue_free()
