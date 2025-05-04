extends RigidBody2D

# used to "reset" position to inital position
var spawnpoint:Vector2 = Vector2(0,0)

func _ready() -> void:
	# set spawnpoint to inital position at start of game
	spawnpoint = position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.death_UI.visible = true
		body.death_UI.enable_mouse()
		
		self.freeze = true
		self.global_position.y = 50
		self.linear_velocity = Vector2.ZERO
		self.gravity_scale = 0
		position = spawnpoint
		await get_tree().create_timer(2).timeout
		self.gravity_scale = 1
		self.freeze = false

func _physics_process(delta: float) -> void:
	pass
