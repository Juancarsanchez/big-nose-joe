class_name PileRenderer
extends Node

const INITIAL_CAPACITY := 512

var layer: CanvasItem
var groups := {}
var dirty := {}

func setup(target_layer: CanvasItem) -> void:
	layer = target_layer
	set_process(true)

func add_piece(piece: PilePiece) -> void:
	piece.renderer = self
	if not _should_render(piece):
		piece.render_key = ""
		piece.render_slot = -1
		return
	var key := _piece_key(piece)
	if not groups.has(key):
		groups[key] = _create_group(piece, key)
	var group: Dictionary = groups[key]
	var pieces: Array = group.pieces
	_ensure_capacity(group, pieces.size() + 1)
	piece.render_key = key
	piece.render_slot = pieces.size()
	pieces.append(piece)
	RenderingServer.multimesh_set_visible_instances(group.multimesh, pieces.size())
	_sync_piece(piece)
	if is_instance_valid(piece.crack):
		attach_auxiliary(piece.crack)

func refresh_group(piece: PilePiece) -> void:
	if not piece.alive:
		return
	var should_render := _should_render(piece)
	if piece.render_slot < 0:
		if should_render:
			add_piece(piece)
		return
	if not should_render:
		remove_piece(piece)
		piece.render_key = ""
		return
	var next_key := _piece_key(piece)
	if next_key == piece.render_key:
		return
	remove_piece(piece)
	add_piece(piece)

func remove_piece(piece: PilePiece) -> void:
	dirty.erase(piece.get_instance_id())
	if piece.render_key.is_empty() or not groups.has(piece.render_key):
		return
	var group: Dictionary = groups[piece.render_key]
	var pieces: Array = group.pieces
	var slot := piece.render_slot
	if slot < 0 or slot >= pieces.size():
		return
	var last: PilePiece = pieces.back()
	pieces[slot] = last
	pieces.pop_back()
	if last != piece:
		last.render_slot = slot
		_sync_piece(last)
	piece.render_slot = -1
	RenderingServer.multimesh_set_visible_instances(group.multimesh, pieces.size())

func mark_dirty(piece: PilePiece) -> void:
	if piece.alive and piece.render_slot >= 0:
		dirty[piece.get_instance_id()] = piece

func attach_auxiliary(node: Node) -> void:
	if layer and is_instance_valid(node) and node.get_parent() == null:
		layer.add_child(node)

func instance_count() -> int:
	var count := 0
	for group_value in groups.values():
		count += (group_value as Dictionary).pieces.size()
	return count

func batch_count() -> int:
	return groups.size()

func _process(_delta: float) -> void:
	if dirty.is_empty():
		return
	var pending := dirty.values()
	dirty.clear()
	for value in pending:
		var piece := value as PilePiece
		if piece and piece.alive and piece.render_slot >= 0:
			_sync_piece(piece)

func _piece_key(piece: PilePiece) -> String:
	var side := str(piece.get_meta("side", "right"))
	var kind := str(piece.get_meta("kind", "unknown"))
	if kind == "impurity":
		kind += "_" + str(piece.get_meta("material", "unknown"))
	return side + ":" + kind + (":cargo" if bool(piece.get_meta("carried", false)) else ":pile")

func _should_render(piece: PilePiece) -> bool:
	# El polvo asentado y las impurezas se funden en una única superficie. Solo
	# conservamos instancias para aquello que necesita una silueta jugable propia
	# o durante el breve trayecto por el aire.
	if bool(piece.get_meta("carried", false)):
		return piece.visible
	if not bool(piece.get_meta("landed", true)):
		# Los granos ya no se dibujan como canicas mientras caen: la montaña es
		# una superficie continua y sus vuelos se representan con polvo ligero en
		# la capa de efectos. Solo rocas y bacterias conservan una silueta propia;
		# las impurezas se leen como manchas cuando llegan a la superficie.
		return str(piece.get_meta("kind", "unknown")) in ["rock", "bacteria"]
	return str(piece.get_meta("kind", "unknown")) in ["rock", "bacteria"]

func _create_group(piece: PilePiece, key: String) -> Dictionary:
	var mesh := QuadMesh.new()
	mesh.size = Vector2(piece.texture.get_width(), piece.texture.get_height())
	var multimesh := RenderingServer.multimesh_create()
	RenderingServer.multimesh_allocate_data(multimesh, INITIAL_CAPACITY, RenderingServer.MULTIMESH_TRANSFORM_2D, true, false)
	RenderingServer.multimesh_set_mesh(multimesh, mesh.get_rid())
	RenderingServer.multimesh_set_visible_instances(multimesh, 0)
	var canvas_item := RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(canvas_item, layer.get_canvas_item())
	RenderingServer.canvas_item_set_z_index(canvas_item, 12 if bool(piece.get_meta("carried", false)) else 0)
	RenderingServer.canvas_item_add_multimesh(canvas_item, multimesh, piece.texture.get_rid())
	RenderingServer.canvas_item_set_custom_rect(canvas_item, true, Rect2(-1000.0, -1000.0, 10000.0, 4000.0))
	if piece.material:
		RenderingServer.canvas_item_set_material(canvas_item, piece.material.get_rid())
	return {"key":key, "pieces":[], "capacity":INITIAL_CAPACITY, "mesh":mesh, "multimesh":multimesh, "canvas_item":canvas_item}

func _ensure_capacity(group: Dictionary, required: int) -> void:
	if required <= int(group.capacity):
		return
	var capacity := int(group.capacity)
	while capacity < required:
		capacity *= 2
	group.capacity = capacity
	RenderingServer.multimesh_allocate_data(group.multimesh, capacity, RenderingServer.MULTIMESH_TRANSFORM_2D, true, false)
	RenderingServer.multimesh_set_mesh(group.multimesh, (group.mesh as Mesh).get_rid())
	for value in group.pieces:
		_sync_piece(value as PilePiece)
	RenderingServer.multimesh_set_visible_instances(group.multimesh, group.pieces.size())

func _sync_piece(piece: PilePiece) -> void:
	if not groups.has(piece.render_key) or piece.render_slot < 0:
		return
	var group: Dictionary = groups[piece.render_key]
	var draw_scale := piece.scale if piece.visible else Vector2.ZERO
	var transform := Transform2D(piece.rotation, draw_scale, 0.0, piece.position)
	RenderingServer.multimesh_instance_set_transform_2d(group.multimesh, piece.render_slot, transform)
	var color := piece.modulate
	if not piece.visible:
		color.a = 0.0
	RenderingServer.multimesh_instance_set_color(group.multimesh, piece.render_slot, color)
	if is_instance_valid(piece.crack):
		piece.crack.position = piece.position
		piece.crack.rotation = piece.rotation
		piece.crack.scale = piece.scale
		piece.crack.z_index = piece.z_index + 1
		piece.crack.modulate.a = color.a

func _exit_tree() -> void:
	for group_value in groups.values():
		var group: Dictionary = group_value
		RenderingServer.free_rid(group.canvas_item)
		RenderingServer.free_rid(group.multimesh)
	groups.clear()
	dirty.clear()
