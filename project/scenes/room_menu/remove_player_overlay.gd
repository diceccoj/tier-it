extends Panel


var player_to_remove : Player
var player_overlay : Control
@onready var parent = $".."

@onready var loading_message = $"../LoadingMessage"


func _ready():
	Room.room_error.connect(error)
	player_to_remove.player_error.connect(error)

#pull room and clear player from the database
func _on_yes_pressed():
	loading_message.add_theme_color_override("font_color", Color(0x909090ff))
	loading_message.text = "Loading..."
	#grab room info
	player_to_remove.grab_info_from_id(player_to_remove.id)
	await Room.pull_info(Room.room_name)
	#erase data and publish
	Room.players.erase(player_to_remove.id)
	player_to_remove.in_rooms.erase(Room.room_name)
	player_to_remove.publish()
	await Room.publish()
	#remove self
	player_overlay.empty_player_grid()
	await player_overlay.refresh_players()
	parent.queue_free()


func error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
