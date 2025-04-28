extends TextureRect

@export var itemID:int = 0
var inventory_reference = null
var player_reference = null

# get reference at beginning
@onready var Item_Sprite = $Sprite2D_Item
@onready var item_stack_display: RichTextLabel = $RichTextLabel

func _ready() -> void:
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
	
	# setup player reference
	player_reference = inventory_reference.player_reference
	
func update_item_stack_display(item_stack:int):
	if item_stack == 1:
		item_stack_display.text = ""
	else:
		item_stack_display.text = str(item_stack)

# called when the button is pressed
func _on_button_pressed() -> void:
	if inventory_reference != null:
		on_item_used()
		inventory_reference.remove_from_list_of_items_in_inventory(self)

# this is where the itemID is matched to see what behavior this item should have
# The reason for this apporach insead of a Inheritance based approach is to force us to load
# all heavy resources (textures, sprites, scenes, etc.) inside the player or atleast not inside here
# to avoid loading everything again on every inventory ui update.
# On the one hand this ensures that we force ourseleves to preload everything at the beginning wich
# imporoves preformance and prevents lag. On the other hand of course, it is not the nicest approach
# coding wise since you have to make sure that all cases are handeled even when new items are added.
# I still chose this approach since our small scope of 15 Items allows such freedoms.
func on_item_used() -> void:
	match itemID:
		0: # blue potion
			print("used Mana Potion")
			if player_reference != null:
				player_reference.speed = 800
		1: # black sword
			print("used Sword of Power")
		2: # hat with pruple face
			print("equiped jumpng Boots")
			if player_reference != null:
				player_reference.setSprite("res://Assets/Item_Card.png")
		3: # pocket-watch
			print("equiped magic Hat")
			if player_reference != null:
				player_reference.speed = 100
		4:
			print("used mystical Clock")
		5:
			print("collected Brick")
		6:
			print("equiped Pink Shovel")
		7:
			print("used Raw Meat")
		8:
			print("equiped Axe of Rage")
		_: # default (should never be executed)
			print("ERROR: invalid item ID < could not be found >")
