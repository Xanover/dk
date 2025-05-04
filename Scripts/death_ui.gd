extends Control
# reference to player
# has to be set by other
var player_ref = null

func intialize(player_reference) -> void:
	player_ref = player_reference

func enable_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _on_button_pressed() -> void:
	if player_ref != null:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		player_ref.position = Vector2(0,0)
		self.visible = false
