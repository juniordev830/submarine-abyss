extends CharacterBody3D
class_name AbyssSubmarine

const SPEED := 7.0
const TURN_SPEED := 1.6
const DIVE_SPEED := 4.0

func _ready() -> void:
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.height = 3.2
	capsule.radius = 0.75
	shape.shape = capsule
	shape.rotation.x = PI / 2.0
	add_child(shape)

	var hull := CapsuleMesh.new()
	hull.radius = 0.75
	hull.height = 3.2
	_part(hull, Vector3.ZERO, Vector3(PI / 2.0, 0, 0), Color("#ffd45a"))
	var window := SphereMesh.new()
	window.radius = 0.35
	window.height = 0.7
	_part(window, Vector3(0, 0.22, -1.2), Vector3.ZERO, Color("#37d8f1"))
	var tail := BoxMesh.new()
	tail.size = Vector3(2.3, 0.12, 1.0)
	_part(tail, Vector3(0, 0, 1.25), Vector3.ZERO, Color("#e38c39"))
	var fin := BoxMesh.new()
	fin.size = Vector3(0.15, 0.95, 0.80)
	_part(fin, Vector3(0, 0.77, 0.65), Vector3.ZERO, Color("#e7a13f"))
	var lamp := OmniLight3D.new()
	lamp.light_color = Color("#7feaff")
	lamp.light_energy = 1.2
	lamp.omni_range = 8.0
	lamp.position = Vector3(0, 0.25, -1.1)
	add_child(lamp)


func _part(mesh: Mesh, offset: Vector3, angles: Vector3, tint: Color) -> void:
	var visual := MeshInstance3D.new()
	visual.mesh = mesh
	visual.position = offset
	visual.rotation = angles
	var mat := StandardMaterial3D.new()
	mat.albedo_color = tint
	mat.metallic = 0.4
	mat.roughness = 0.25
	visual.material_override = mat
	add_child(visual)


func _physics_process(delta: float) -> void:
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		rotation.y += TURN_SPEED * delta
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		rotation.y -= TURN_SPEED * delta
	var travel := 0.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		travel += 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		travel -= 1.0
	var dive := 0.0
	if Input.is_key_pressed(KEY_E):
		dive += 1.0
	if Input.is_key_pressed(KEY_Q):
		dive -= 1.0
	velocity = -global_transform.basis.z * travel * SPEED + Vector3.UP * dive * DIVE_SPEED
	move_and_slide()
	global_position.x = clampf(global_position.x, -28.0, 28.0)
	global_position.z = clampf(global_position.z, -28.0, 28.0)
	global_position.y = clampf(global_position.y, 0.4, 10.0)
