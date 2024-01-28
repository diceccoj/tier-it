extends Panel

var root_scene : Control

func _on_audio_stream_player_finished():
	var ayso = load("res://scenes/ranking_players/are_you_sure_overlay.tscn").instantiate()
	ayso.get_child(0).root_scene = root_scene
	root_scene.add_child(ayso)
