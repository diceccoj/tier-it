extends Control



func _on_main_menu_pressed():
	Room.no_errors = true
	get_tree().change_scene_to_file("res://scenes/title_screen/title_screen.tscn")
