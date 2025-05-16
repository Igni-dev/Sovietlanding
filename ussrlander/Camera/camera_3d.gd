extends Camera3D

# https://www.youtube.com/watch?v=ZCb12AHKMfE
@export var mouse_sensibility: float = 0.005

@onready var rocket = null

var offset = Vector3.ZERO

func _ready() -> void:
	if not rocket:
		return
	#print("rocket", rocket.global_transform.origin)
	#print("camera", global_transform.origin)
	#offset = global_transform.origin - rocket.global_transform.origin
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	print(global_transform.origin)
	if not rocket:
		return
	#global_transform.origin = rocket.global_transform.origin + offset
	
	
func set_offset(target: Node3D):
	offset = global_transform.origin - target.global_transform.origin
#func _unhandled_input(event: InputEvent) -> void:
	#if event is InputEventMouseMotion:
		#rotation.y -= event.relative.x * mouse_sensibility
		#rotation.y = wrapf(rotation.y, 0.0, TAU)
		#
		#rotation.x -= event.relative.y * mouse_sensibility
		#rotation.y = clamp(rotation.x, -PI/2, PI/4)
