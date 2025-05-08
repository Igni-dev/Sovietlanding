extends RigidBody3D

# https://github.com/DmitriySalnikov/godot_debug_draw_3d
# todo: https://www.youtube.com/watch?v=5Uc9yzj4YLY

# Параметры управления
@export var thrust_force: float = 5.0
@export var rotation_speed: float = 0.1


# start sprint control
var is_hit_rocket := false
var pulling := false
var pull_start := Vector3.ZERO
var pull_end := Vector3.ZERO

const PULL_POWER = 20.0  # масштаб силы
const MAX_FORCE = 50.0
# end sprint control

# Ограничение наклона ракеты
var pitch_limit := deg_to_rad(45.0) # максимум 45 градусов наклона

	#print("Pull Force: ", direction.length())
	
#func handle_input(delta):
	## Управление поворотами мышкой/тачпадом
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#var mouse_movement = Input.get_last_mouse_velocity()
#
		#var pitch = mouse_movement.y * -rotation_speed * delta
		#var yaw = mouse_movement.x * rotation_speed * delta
		#
		## Ограничение по углу наклона вперёд-назад
		#var new_rotation = rotation + Vector3(pitch, yaw, 0.0)
		#new_rotation.x = clamp(new_rotation.x, -pitch_limit, pitch_limit)
		#rotation = new_rotation

	# Управление ускорением вперёд
	#if Input.is_action_pressed("thrust"):
	#	apply_central_force(-transform.basis.z * thrust_force)
