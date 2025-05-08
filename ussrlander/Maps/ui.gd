extends CanvasLayer

var rocket: RigidBody3D = null

@onready var player_name_label = $PlayerNameL

func _ready():
	update_player_name()

func update_player_name():
	var name = "NoName"
	if JavaScriptBridge:
		var nickname = JavaScriptBridge.eval("getTelegramUsername();", true)
		if nickname:
			name = str(nickname)
	player_name_label.text = "Player: " + name
	
func _process(delta):
	if rocket:
		var speed = rocket.linear_velocity.length()
		$SpeedL.text = "Speed: " + str(round(speed)) + " m/s"
