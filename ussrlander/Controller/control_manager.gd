extends Node3D

signal rocket_position_updated(in_rocket_position: Vector3)

signal control_vector_updated(in_start_control_vector: Vector3, in_end_control_vector: Vector3)
signal control_vector_started(in_start_control_vector: Vector3)
signal control_vector_ended(in_end_control_vector: Vector3)

var start_control_vector: Vector3 = Vector3.ZERO
var end_control_vector: Vector3 = Vector3.ZERO

func set_control_vector(in_start_control_vector: Vector3, in_end_control_vector: Vector3):
	start_control_vector = in_start_control_vector
	end_control_vector = in_end_control_vector
	emit_signal("control_vector_updated", start_control_vector, end_control_vector)
	
func set_control_started(in_start_control_vector: Vector3):
	start_control_vector = in_start_control_vector
	emit_signal("control_vector_started", start_control_vector)

func set_control_ended(in_end_control_vector: Vector3):
	end_control_vector = in_end_control_vector
	emit_signal("control_vector_ended", end_control_vector)
	
func update_rocket_position(in_rocket_position: Vector3):
	emit_signal("rocket_position_updated", in_rocket_position)
