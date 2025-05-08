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

var local_start_control_vector := Vector3.ZERO
var start_control_vector := Vector3.ZERO
var end_control_vector := Vector3.ZERO

const STABILIZER_FORCE = 0.5
const MAX_ANGULAR_SPEED = 1.5
const PULL_POWER = 20.0  # масштаб силы
const MAX_FORCE = 50.0
# end sprint control

func _ready() -> void:
	ControlManager.connect("control_vector_updated", Callable(self, "_on_control_vector_updated"))
	ControlManager.connect("control_vector_started", Callable(self, "_on_control_vector_started"))
	ControlManager.connect("control_vector_ended", Callable(self, "_on_control_vector_ended"))
	
func _integrate_forces(state: PhysicsDirectBodyState3D):
	if state.angular_velocity.length() > MAX_ANGULAR_SPEED:
		state.angular_velocity = angular_velocity.normalized() * MAX_ANGULAR_SPEED
	#state.angular_velocity *= 0.95
	return

func _process(delta: float) -> void:
	var global_start_point = global_transform * local_start_control_vector
	var control_vector = end_control_vector - global_start_point
	var force_strength = control_vector.length() * 2.0
	var direction = control_vector.normalized()
	var final_force = direction * force_strength
	#apply_central_force(final_force)
	apply_force(final_force, global_transform.affine_inverse() * global_start_point)
	
	DebugDraw3D.draw_sphere(start_control_vector, 0.2, Color.RED)
	DebugDraw3D.draw_sphere(end_control_vector, 0.2, Color.GREEN)
	DebugDraw3D.draw_line(end_control_vector, global_start_point, Color.RED)
	
	DebugDraw3D.draw_sphere(global_start_point, 0.2, Color.PURPLE)

func _on_control_vector_started(in_start_control_vector: Vector3):
	print("_on_control_vector_started")
	local_start_control_vector = to_local(in_start_control_vector)
	
func _on_control_vector_ended(in_end_control_vector: Vector3):
	print("_on_control_vector_ended")
	local_start_control_vector = Vector3.ZERO
	start_control_vector = Vector3.ZERO
	end_control_vector = Vector3.ZERO

func _on_control_vector_updated(in_start_control_vector: Vector3, in_end_control_vector: Vector3):
	start_control_vector = in_start_control_vector
	end_control_vector = in_end_control_vector
