extends Node3D

const Rules = preload("res://scripts/oxygen_rules.gd")
const Submarine = preload("res://scripts/submarine.gd")

var submarine: AbyssSubmarine
var camera: Camera3D
var hud: Label
var collectibles: Array[MeshInstance3D] = []
var oxygen := 100.0
var collected := 0
var finished := false
var result := ""


func _ready() -> void:
	_setup_environment()
	_create_world()
	submarine = Submarine.new()
	submarine.position = Vector3(0, 3.0, 12.0)
	add_child(submarine)
	_create_collectibles()
	camera = Camera3D.new()
	camera.fov = 67.0
	camera.current = true
	add_child(camera)
	camera.global_position = Vector3(0, 9, 23)
	camera.look_at(submarine.global_position)
	var hud_layer := CanvasLayer.new()
	add_child(hud_layer)
	hud = Label.new()
	hud.position = Vector2(26, 22)
	hud.add_theme_font_size_override("font_size", 23)
	hud.add_theme_color_override("font_color", Color("#d8ffff"))
	hud_layer.add_child(hud)
	_refresh_hud()


func _setup_environment() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color("#06283d")
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color("#3290aa")
	env.reflected_light_source = Environment.REFLECTION_SOURCE_DISABLED
	env.fog_enabled = true
	env.fog_density = 0.025
	env.fog_light_color = Color("#15768c")
	world.environment = env
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, 15, 0)
	sun.light_color = Color("#54b9d4")
	sun.light_energy = 0.75
	add_child(sun)


func _create_world() -> void:
	var floor := StaticBody3D.new()
	floor.position = Vector3(0, -1.15, 0)
	add_child(floor)
	var box := BoxMesh.new()
	box.size = Vector3(64, 2.0, 64)
	_add_visual(box, floor, Vector3.ZERO, Color("#31585a"))
	var collider := CollisionShape3D.new()
	var floor_shape := BoxShape3D.new()
	floor_shape.size = box.size
	collider.shape = floor_shape
	floor.add_child(collider)
	for i in range(19):
		var angle := float(i) * TAU / 19.0
		var radius := 10.0 + float(i % 4) * 4.0
		var spot := Vector3(cos(angle) * radius, -0.15, sin(angle) * radius)
		var rock := SphereMesh.new()
		rock.radius = 0.8 + float(i % 3) * 0.38
		rock.height = rock.radius * 2.0
		_add_visual(rock, self, spot, Color("#496e78"))
	for i in range(32):
		var angle := float(i) * TAU / 32.0
		var radial := 7.0 + float((i * 7) % 19)
		var coral := CylinderMesh.new()
		coral.top_radius = 0.15
		coral.bottom_radius = 0.4
		coral.height = 1.1 + float(i % 3) * 0.6
		_add_visual(coral, self, Vector3(cos(angle) * radial, 0, sin(angle) * radial), Color("#e28599"))


func _add_visual(mesh: Mesh, parent: Node3D, offset: Vector3, tint: Color) -> MeshInstance3D:
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.position = offset
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.7
	visual.material_override = material
	parent.add_child(visual)
	return visual


func _create_collectibles() -> void:
	var positions := [
		Vector3(-10, 2, 3), Vector3(12, 4, -7),
		Vector3(-8, 6, -16), Vector3(17, 2, 15),
		Vector3(0, 8, -23)
	]
	for pos in positions:
		var pearl := SphereMesh.new()
		pearl.radius = 0.55
		pearl.height = 1.1
		var gem := _add_visual(pearl, self, pos, Color("#74ffe5"))
		var material := gem.material_override as StandardMaterial3D
		material.emission_enabled = true
		material.emission = Color("#50e9e5")
		collectibles.append(gem)


func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		return
	if not finished:
		var drain_rate: float = Rules.oxygen_rate_at_depth(submarine.global_position.y)
		oxygen = Rules.consume_oxygen(oxygen, delta, drain_rate)
		for gem in collectibles:
			gem.rotate_y(delta)
			if Rules.can_collect(submarine.global_position.distance_to(gem.global_position)):
				gem.queue_free()
				collectibles.erase(gem)
				collected += 1
				oxygen = Rules.replenish_oxygen(oxygen)
				break
		if collected == 5:
			finished = true
			result = "MISSAO COMPLETA! Pressione R para reiniciar."
		elif oxygen <= 0.0:
			finished = true
			result = "OXIGENIO ESGOTADO! Pressione R para tentar novamente."
	_refresh_hud()
	if is_instance_valid(camera) and is_instance_valid(submarine):
		var target := submarine.global_position + Vector3(0, 6.0, 10.5)
		camera.global_position = camera.global_position.lerp(target, clampf(delta * 2.2, 0.0, 1.0))
		camera.look_at(submarine.global_position)


func _refresh_hud() -> void:
	if not is_instance_valid(hud):
		return
	var depth: float = maxf(0.0, 10.0 - submarine.global_position.y)
	var rate: float = Rules.oxygen_rate_at_depth(submarine.global_position.y)
	var remaining: int = int(ceil(Rules.estimated_oxygen_seconds(oxygen, rate)))
	hud.text = "SUBMARINE ABYSS  •  EXPEDICAO 01\nPEROLAS: %d / 5      OXIGENIO: %d%%\nPROFUNDIDADE: %.1f m (simulada)   ESTIMATIVA: %ds\nWASD: navegar   A/D: girar   Q/E: subir/descer   R: reiniciar\n%s" % [collected, int(oxygen), depth, remaining, result]
