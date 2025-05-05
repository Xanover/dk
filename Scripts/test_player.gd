extends CharacterBody2D

@export var speed = 200
@export var jump_speed = -500
@export var gravity = 2000

@onready var Inventory = $Camera2D/Inventory
@onready var sprite = $Sprite2D
@onready var ladder_interact = $Ladder_Interaction
@onready var death_UI = $Camera2D/Death_UI

var is_on_ladder:bool = false

func _ready() -> void:
	Inventory.initialize(self) # pass reference to self so that inventory knows which scene is player
	ladder_interact.initialize(self) # pass reference to self so that ladder knows which scene is player
	death_UI.intialize(self)
	
func add_item_to_inventory(itemID:int):
	Inventory.add_item(itemID)

func _physics_process(delta):
	# Add gravity every frame if not on ladder
	if !is_on_ladder:
		velocity.y += gravity * delta

	# Input affects x axis only
	velocity.x = Input.get_axis("ui_left", "ui_right") * speed

	move_and_slide()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = jump_speed
	
	if Input.is_action_just_pressed("ui_right"):
		sprite.flip_h = false
	
	if Input.is_action_just_pressed("ui_left"):
		sprite.flip_h = true

func setSprite(path):
	sprite.texture = load(path)
