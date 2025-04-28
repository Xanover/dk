extends Area2D

@export_category("Item")
@export var itemID:int = 0
@export_category("Animation")
@export var bobbing:bool = true
@export var spinning:bool = true
@export var spinning_speed:float = 1.0
var bobbing_speed:float = 0.1
var bobbing_ambitus:float = 4.0
var bobbing_direction:int = -1
var bobbing_delta:float = 0.0

# get reference at beginning
@onready var Item_Sprite = $BobbingAnchor/Sprite2D
@onready var Card_Sprite = $BobbingAnchor/AnimatedSprite2D
@onready var Bobbing_Anchor = $BobbingAnchor # used for local position offset for animating bobbing

# entrypoint
func _ready() -> void:
	# validate or correct inputs
	bobbing_speed = abs(bobbing_speed)
	if bobbing_speed == 0:
		print("ERROR: bobbing_speed can't be 0. defaulted to 0.1")
		bobbing_speed = 0.1
	
	# set the Sprite to the specified itemID (ofc only works if all items in one tileset)
	# but check if it is valid for the ammount of possible item sprites
	var max_item_ID:int = (Item_Sprite.hframes * Item_Sprite.vframes)-1
	if itemID < 0:
		print("ERROR: invalid item ID <to small> "+str(itemID)+" defaulted to "+str(max_item_ID))
		itemID = max_item_ID
	if itemID > max_item_ID:
		print("ERROR: invalid item ID <to large> "+str(itemID)+" defaulted to 0")
		itemID = 0
	Item_Sprite.frame = itemID
	
	if spinning:
		# play spinning animation if pickup should spin and set speed
		Card_Sprite.speed_scale = spinning_speed
		Card_Sprite.play("Spinning")

# runs every frame
func _process(delta: float) -> void:
	if spinning:
		# get_frame() will eiter be 0 or 1 (since it only has two frames) wich will
		# be interpreted as bool and then inversed -> Sprite2D is only visible when AnimatedSprite2D
		# is "facing front" (aka. displaying frame 0)
		Item_Sprite.visible = not Card_Sprite.get_frame()
	if bobbing:
		# 
		Bobbing_Anchor.position.y += bobbing_speed * bobbing_direction
		bobbing_delta += bobbing_speed
		if bobbing_delta >= bobbing_ambitus:
			bobbing_direction *= -1
			bobbing_delta = 0.0

# if the player collides with this pickup then add the associated item to the players inventory and
# delete self at the end of the next frame
func _on_body_entered(body: Node2D) -> void:
	if body.name.contains("Player"):
		body.add_item_to_inventory(itemID)
		queue_free()
