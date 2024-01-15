extends Panel

var root_scene : Control
@onready var player_grid = $"../Players"

const remove_player_overlay = "res://scenes/room_menu/player_list_overlay.tscn"
const not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"

const player_decal_button = "res://scenes/room_menu/player_decal_button.tscn"



func _ready():
	
	#making player_decal objects and load them with player information
	var decal_button : Control
	var resource : Resource = preload(player_decal_button)
	for object in Room.player_objects:
		decal_button = resource.instantiate()
		player_grid.add_child(decal_button)
		decal_button.set_items_with_player(object)
	
	for p in player_grid.get_children():
		p.root_scene = root_scene
