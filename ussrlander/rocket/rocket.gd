extends RigidBody3D

# https://github.com/DmitriySalnikov/godot_debug_draw_3d
# todo: https://www.youtube.com/watch?v=5Uc9yzj4YLY

var local_start_control_vector := Vector3.ZERO
var local_end_control_vector := Vector3.ZERO
var global_end_control_vector := Vector3.ZERO

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
	
	if local_start_control_vector.is_equal_approx(Vector3.ZERO) \
		or local_end_control_vector.is_equal_approx(Vector3.ZERO):
		return
	# hack to normilize high
	#local_end_control_vector.y = local_start_control_vector.y
	var global_start_point = global_transform * local_start_control_vector
	
	# use origin global end point from the input.
	# do not convert it in local space. global_transform went byzzeng.
	#var global_end_point = global_transform * local_end_control_vector
	var global_end_point = global_end_control_vector
	var control_vector = global_end_point - global_start_point
	var force_strength = control_vector.length() * 0.2
	var direction = control_vector.normalized()
	var final_force = direction * force_strength

	apply_force(final_force, global_transform.affine_inverse() * global_start_point)
	
	DebugDraw3D.draw_sphere(global_start_point, 0.1, Color.GREEN)
	DebugDraw3D.draw_sphere(global_end_point, 0.1, Color.PURPLE)
	var LineColor = Color.RED
	
	if local_start_control_vector.y == local_end_control_vector.y:
		LineColor = Color.GREEN
	DebugDraw3D.draw_line(global_end_point, global_start_point, LineColor)
	
	var arrow_size = 0.2
	var arrow_scale = 2
	DebugDraw3D.draw_arrow(global_start_point, global_start_point + Vector3.UP * arrow_scale, Color.GREEN, arrow_size)
	DebugDraw3D.draw_arrow(global_start_point, global_start_point + Vector3.FORWARD * arrow_scale, Color.RED, arrow_size)
	DebugDraw3D.draw_arrow(global_start_point, global_start_point + Vector3.RIGHT * arrow_scale, Color.BLUE, arrow_size)
	
	DebugDraw3D.draw_arrow(global_end_point, global_end_point + Vector3.UP * arrow_scale, Color.GREEN, arrow_size)
	DebugDraw3D.draw_arrow(global_end_point, global_end_point + Vector3.FORWARD * arrow_scale, Color.RED, arrow_size)
	DebugDraw3D.draw_arrow(global_end_point, global_end_point + Vector3.RIGHT * arrow_scale, Color.BLUE, arrow_size)

func _on_control_vector_started(in_start_control_vector: Vector3):
	#print("_on_control_vector_started")
	local_start_control_vector = to_local(in_start_control_vector)
	
func _on_control_vector_ended(in_end_control_vector: Vector3):
	#print("_on_control_vector_ended")
	local_start_control_vector = Vector3.ZERO
	local_end_control_vector = Vector3.ZERO

func _on_control_vector_updated(in_start_control_vector: Vector3, in_end_control_vector: Vector3):
	local_end_control_vector = to_local(in_end_control_vector)
	global_end_control_vector = in_end_control_vector
