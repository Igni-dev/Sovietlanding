# https://forum.godotengine.org/t/how-to-get-3d-position-of-the-mouse-cursor/28741/2

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
		update_mouse_end_control_position(mouse_position)
		ControlManager.set_control_vector(target_start_position, target_end_position)
		
func _input(event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_position = event.position
		if grabbed_object == null:
			update_mouse_start_control_position(mouse_position)
			if grabbed_object:
				ControlManager.set_control_started(target_start_position)
	else:
		if grabbed_object:
			ControlManager.set_control_ended(target_end_position)
		grabbed_object = null
			
func update_mouse_start_control_position(m_start_pos: Vector2):
	var start = get_viewport().get_camera_3d().project_ray_origin(m_start_pos)
	var end = get_viewport().get_camera_3d().project_position(m_start_pos, DIST)
	var query = PhysicsRayQueryParameters3D.create(start, end)
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	if result.is_empty() == false and result.collider is RigidBody3D:
		grabbed_object = result.collider
		target_start_position = result.position

func update_mouse_end_control_position(mouse_pos: Vector2):		
	var plane = Plane(Vector3.UP, target_start_position.y)
	var ray_origin = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var ray_direction = get_viewport().get_camera_3d().project_ray_normal(mouse_pos)
	var end_point = plane.intersects_ray(ray_origin, ray_direction)
	if end_point:
		target_end_position = end_point
		#print(plane, end_point)
		#DebugDraw3D.draw_plane(plane, Color.CORNFLOWER_BLUE, target_start_position)
		
