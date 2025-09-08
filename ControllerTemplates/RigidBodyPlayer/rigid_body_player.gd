extends RigidBody3D

class_name RigidBodyPlayer

@export var network_position : Vector3
@export var shape_cast : ShapeCast3D
@export var synchronizer : MultiplayerSynchronizer

const DEFAULT_SPEED = 5.0
const DEFAULT_JUMP_VELOCITY = 4.5

func _ready() -> void:
	network_position = position
	pass

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority():
		if position.distance_to(network_position) <= 8.0:
			position = position.lerp(network_position, min(12 * delta, 1.0))
		else:
			position = network_position
		return

	#if is_on_floor():
		#velocity.y = 0
	#velocity += get_gravity() * delta

	if Input.is_key_pressed(KEY_SPACE) and shape_cast.is_colliding():
		#apply_central_impulse(Vector3(0.0, 1.0, 0.0) * DEFAULT_JUMP_VELOCITY)
		linear_velocity.y = DEFAULT_JUMP_VELOCITY

	if Input.is_key_pressed(KEY_V):
		#apply_central_impulse(Vector3(0.0, 1.0, 0.0) * DEFAULT_JUMP_VELOCITY)
		linear_velocity.y = DEFAULT_JUMP_VELOCITY

	var key_input : Vector3
	key_input.x = float(Input.is_key_pressed(KEY_D)) - float(Input.is_key_pressed(KEY_A))
	key_input.z = float(Input.is_key_pressed(KEY_S)) - float(Input.is_key_pressed(KEY_W))
	key_input = get_viewport().get_camera_3d().global_basis * key_input
	key_input.y = 0
	key_input = key_input.normalized()
	var movement : Vector3 = key_input * DEFAULT_SPEED
	var current_xz_velocity : Vector3 = Vector3(linear_velocity.x, 0.0, linear_velocity.z)
	if current_xz_velocity.length() <= DEFAULT_SPEED:
		linear_velocity.x = movement.x
		linear_velocity.z = movement.z

	network_position = position
	pass
