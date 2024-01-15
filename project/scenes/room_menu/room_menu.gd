extends Control

const player_list : String = "res://scenes/room_menu/player_list_overlay.tscn"

@onready var admin = $Admin
@onready var room_code = $"Share the room code!/RoomCode"
@onready var room_name = $RoomName


func _ready():
	#admin is always the first player listed
	if (User.player.id == Room.players[0]):
		admin.text = "Admin"
		
	room_name.text = Room.room_name
	room_code.text = Room.room_code


func _on_player_list_pressed():
	var pl = load(player_list).instantiate()
	pl.get_child(0).root_scene = self
	self.add_child(pl)
