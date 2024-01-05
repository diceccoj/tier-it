extends Control

const player_list : String = "res://scenes/room_menu/player_list_overlay.tscn"





func _on_player_list_pressed():
	var pl = load(player_list).instantiate()
	pl.get_child(0).root_scene = self
	self.add_child(pl)
