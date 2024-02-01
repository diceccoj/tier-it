extends Control

const player_list : String = "res://scenes/room_menu/player_list_overlay.tscn"

@onready var admin = $Admin
@onready var room_code = $"Share the room code!/RoomCode"
@onready var room_name = $RoomName
@onready var player_decal = $Player


func _ready():
	#checking if theres a loading error
	if(len(Room.players) == 0):
		self.add_child(load("res://scenes/other/somethings_wrong_overlay.tscn").instantiate())
		return
	
	#admin is always the first player listed
	if (User.id == Room.players[0].id):
		admin.text = "Admin"
	
	#finding the user id and setting the player object to the corresponding information
	for i in range(0, len(Room.players)):
		if (User.id == Room.players[i].id):
			Room.user_index = i
			break
	
	var player_object = Player.new()
	player_object.set_info_with_dict(Room.user_object())
	player_decal.set_items_with_player(player_object)
	
	room_name.text = Room.room_name
	if (Room.room_code == ""):
		room_code.text = "(no room code)"
	else:
		room_code.text = Room.room_code


func _on_player_list_pressed():
	var pl = load(player_list).instantiate()
	pl.get_child(0).root_scene = self
	self.add_child(pl)
