extends Control

# list of items
var items = {}
# preload resource item to be able to instancitate without having to load resource every time
@onready var item_scene = preload("res://Scenes/item.tscn")

# refence to player to give to items to use
var player_reference = null

# get reference at beginning
@onready var grid = $GridContainer

# get reference to player
func initialize(player_ref) -> void:
	player_reference = player_ref

# entrypoint
func _ready() -> void:
	
	# initally hide Inventory UI and mouse cursor
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# adds an item to the list of items
# passes it a refernce to self to be able to remove it from inventory if necessary
func add_item(itemID:int) -> void:
	if player_reference == null:
		print("ERROR: please intialize Inventory with function: initialize()")
	var new_item = item_scene.instantiate()
	new_item.itemID = itemID
	new_item.inventory_reference = self
	if not _is_item_in_inventory(itemID):
		items[itemID] = 1
		grid.add_child(new_item)
	else:
		# add one to item stack
		items[itemID] += 1
		for child in grid.get_children():
			if child.itemID == itemID:
				child.update_item_stack_display(items[child.itemID])
	update_ui()

# remove item from the inventory and update UI
func remove_from_list_of_items_in_inventory(item):
	if items.get(item.itemID) == 1:
		items.erase(item.itemID) # remove item from dictionary
	else:
		items[item.itemID] -= 1
		item.update_item_stack_display(items[item.itemID])
	update_ui()

func update_ui():
	for child in grid.get_children():
		if not items.get(child.itemID):
			grid.remove_child(child)

# runs every frame
func _process(delta: float) -> void:
	# if ui_accept is pressed then toggle the visibility of the inventory UI and the mouse cursor 
	if Input.is_action_just_pressed("ui_accept"):
		visible = not visible
		if visible:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# iterate over every itemID in the inventory and check if it contains the specified one
func _is_item_in_inventory(itemID:int):
	for item in items:
		if item == itemID:
			return true
	return false
