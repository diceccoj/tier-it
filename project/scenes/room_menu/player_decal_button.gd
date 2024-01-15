extends Control

var root_scene : Control

@onready var player = $Player

var remove_player_overlay = "res://scenes/room_menu/remove_player_overlay.tscn"
var not_admin_overlay = "res://scenes/other/not_admin_overlay.tscn"



func _on_blank_button_pressed():
	if (Room.players[0] == User.player.id):
		var rpo = load(remove_player_overlay).instantiate()
		rpo.to_be_removed = player.player
		root_scene.add_child(rpo)
	else:
		root_scene.add_child(load(not_admin_overlay).instantiate())


func set_items_with_player(pl:Player):
	get_child(0).set_items_with_player(pl)
