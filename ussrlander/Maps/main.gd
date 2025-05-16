extends Node3D

@onready var rocket = $Rocket
@onready var ui = $UI
@onready var camera = $Camera3D

func _ready():
	ui.rocket = rocket
	camera.rocket = rocket
	camera.set_offset(rocket)
