extends Button

@export var _theme : Theme
@export var next_scene_path : String

@onready var audio_stream_player = get_child(0)



func _ready():
	theme = _theme
	



func _on_pressed():
	audio_stream_player.play()
	get_tree().change_scene_to_file(next_scene_path)


#animations

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.05, 1.05), 0.1)



func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.00, 1.00), 0.1)
