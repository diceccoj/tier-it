extends Control

@onready var color_picker = $Color/ColorPicker
@onready var player = $Player
@onready var username_field = $UsernameField

var player_object : Player

func _ready():
	player_object = Player.new()
	player_object.set_info_with_dict(Room.user_object())
	player.set_items_with_player(player_object)
	color_picker.color = player_object.color
	username_field.text = player_object.username
	
	#setting up error signals
	player_object.player_error.connect(general_error)
	Room.room_error.connect(general_error)



#convert player object into a dictionary and upload it to player list
func _on_set_avatar_pressed():
	var dict : Dictionary = player_object.export_dict()
	Room.players[Room.user_index] = dict
	await Room.publish()

func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
