extends Panel

var root_scene : Control
@onready var player_grid = $"../Players"
@onready var player_count = $"../PlayerCount"
@onready var overlay = $".."

const remove_player_overlay = "res://scenes/room_menu/player_list_overlay.tscn"
const not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"


const player_decal_button = "res://scenes/room_menu/player_decal_button.tscn"



func _ready():
	Room.room_error.connect(error)
	
	var loading : Control = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(loading)
	await refresh_players()
	loading.queue_free()



func refresh_players():
	#making player_decal objects and load them with player information
	if (Room.player_objects.is_empty()):
		await Room.make_player_objects()
	
	#unloading old objects
	for child in player_grid.get_children():
		child.queue_free()
	
	#creating each player object
	var decal_button : Control
	var resource : Resource = load(player_decal_button)
	for object in Room.player_objects:
		decal_button = resource.instantiate()
		object.player_error.connect(error)
		player_grid.add_child(decal_button)
		decal_button.set_items_with_player(object)
		decal_button.player_overlay = self
	for p in player_grid.get_children():
		p.root_scene = root_scene
	
	player_count.text = str(len(Room.players)) + "/20"
	
	#declaring admin
	player_grid.get_child(0).set_admin()

func error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")

func empty_player_grid():
	for child in player_grid.get_children():
		child.queue_free()


#initiate loading screen and refresh player list
func _on_refresh_pressed():
	var lso = (load("res://scenes/other/loading_overlay.tscn")).instantiate()
	root_scene.add_child(lso)
	await Room.pull_info(Room.room_name)
	refresh_players()
	lso.queue_free()
