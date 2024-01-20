extends Panel


var player_to_remove : Player
var player_overlay : Control
@onready var parent = $".."

@onready var loading_message = $"../LoadingMessage"


#pull room and clear player from the database
func _on_yes_pressed():
	loading_message.add_theme_color_override("font_color", Color(0x909090ff))
	loading_message.text = "Loading..."
	player_to_remove.grab_info_from_id(player_to_remove.id)
	await Room.pull_info(Room.room_name)
	if (Room.no_errors and player_to_remove.no_errors):
		Room.players.erase(player_to_remove.id)
		player_to_remove.erase(Room.room_name)
		player_to_remove.publish()
		await Room.publish()
		print(3)
		if (Room.no_errors and player_to_remove.no_errors):
			player_overlay.refresh_players()
			parent.queue_free()
	if (!Room.no_errors or !player_to_remove.no_errors):
		get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
	


