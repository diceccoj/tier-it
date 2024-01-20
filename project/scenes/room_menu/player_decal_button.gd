extends Control

var root_scene : Control


var remove_player_overlay = "res://scenes/room_menu/remove_player_overlay.tscn"
var not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"

#forwards to remove_player_overlay for list updates
var player_overlay : Control

#put up a pop up that asks to delete the player from the game
func _on_blank_button_pressed():
	var player : Player = get_child(0).player
	if (Room.players[0] == User.player.id  &&  player.id != Room.players[0]):
		var rpo = load(remove_player_overlay).instantiate()
		var panel = rpo.get_child(0)
		panel.player_to_remove = player
		panel.player_overlay = player_overlay
		root_scene.add_child(rpo)
	else:
		root_scene.add_child(load(not_admin_overlay).instantiate())


func set_items_with_player(pl:Player):
	get_child(0).set_items_with_player(pl)
