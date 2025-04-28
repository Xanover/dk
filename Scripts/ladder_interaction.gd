extends Area2D

# reference to player
var _player_reference = null

# pass reference to player
func initialize(player_ref) -> void:
	_player_reference = player_ref


func _on_body_entered(body: Node2D) -> void:
	_player_reference.is_on_ladder = true
	print("on ladder")


func _on_body_exited(body: Node2D) -> void:
	_player_reference.is_on_ladder = false
	print("off ladder")
