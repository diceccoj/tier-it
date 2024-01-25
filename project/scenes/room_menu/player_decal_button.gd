extends Control

var root_scene : Control


var remove_player_overlay = "res://scenes/room_menu/remove_player_overlay.tscn"
var not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"

#forwards to remove_player_overlay for list updates
var player_overlay : Control
var player_id : String

#put up a pop up that asks to delete the player from the game
func _on_blank_button_pressed():
	if (Room.players[0].id == User.id  &&  User.id != player_id):
		var rpo = load(remove_player_overlay).instantiate()
		var panel = rpo.get_child(0)
		panel.player_to_remove = player_id
		panel.player_overlay = player_overlay
		root_scene.add_child(rpo)
	elif (User.id == player_id): #do nothing if player is admin trying to get rid of himself
		pass
	else:
		root_scene.add_child(load(not_admin_overlay).instantiate())

#declare player as admin
func set_admin():
	get_child(0).get_child(3).text = "Admin"

func set_items_with_player(pl:Player):
	player_id = pl.id
	get_child(0).set_items_with_player(pl)
