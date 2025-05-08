extends Node3D

const DIST = 1000
const Z_POS = 10
const CONTROL_PLANE_NORMAL = Vector3.UP
const CONTROL_PLANE_POINT_OFFSET = 5.0

var grabbed_object = null
var grab_position := Vector2()
var mouse_position := Vector2()
var target_start_position := Vector3()
var target_end_position := Vector3()

func _process(delta: float) -> void:
	if grabbed_object:
		DebugDraw3D.draw_sphere(target_start_position, 0.2, Color.RED)
		update_mouse_target_end_position(mouse_position)
		DebugDraw3D.draw_sphere(target_end_position, 0.2, Color.GREEN)
		DebugDraw3D.draw_line(target_start_position, target_end_position, Color.RED)
		
func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_position = event.position
		if grabbed_object == null:
			update_mouse_target_start_position(mouse_position)
	else:
		grabbed_object = null
			
func update_mouse_target_start_position(m_pos: Vector2):
	var start = get_viewport().get_camera_3d().project_ray_origin(m_pos)
	var end = get_viewport().get_camera_3d().project_position(m_pos, DIST)
	var query = PhysicsRayQueryParameters3D.create(start, end)
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result.is_empty() == false:
		grabbed_object = result.collider
		target_start_position = result.position

func update_mouse_target_end_position(m_pos: Vector2):
	var start = get_viewport().get_camera_3d().project_ray_origin(m_pos)
	var end = get_viewport().get_camera_3d().project_position(m_pos, DIST)
	
	var plane_origin = target_start_position - CONTROL_PLANE_NORMAL * CONTROL_PLANE_POINT_OFFSET
	var plane = Plane(CONTROL_PLANE_NORMAL, target_start_position.y)
	var intersection = plane.intersects_ray(start, end)
	if intersection:
		target_end_position = intersection
		var control_vector = target_start_position - target_end_position

func get_grab_position(m_pos: Vector2) -> Vector3:
	return get_viewport().get_camera_3d().project_position(m_pos, Z_POS)

#func draw_pull_line():
	#var direction = pull_start - pull_end
	#DebugDraw3D.draw_sphere(pull_start, 0.2, Color.GREEN)
	#DebugDraw3D.draw_sphere(pull_end, 0.2, Color.RED)
	#DebugDraw3D.draw_line(pull_start, pull_end, Color.RED)
