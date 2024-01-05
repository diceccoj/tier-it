extends Control

#overlay paths
const not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"
const remove_player_overlay = "res://scenes/room_menu/remove_player_overlay.tscn"

#variables
var root_scene : Control

func _on_button_pressed():
	if (root_scene != null):
		var rpo = load(remove_player_overlay).instantiate()
		rpo.get_child(0).player_to_remove = Player.new()
		root_scene.add_child(rpo)
	
