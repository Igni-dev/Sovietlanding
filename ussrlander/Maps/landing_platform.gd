extends Node3D

@onready var rocket = $Rocket
@onready var ui = $UI

func _ready():
	ui.rocket = rocket
