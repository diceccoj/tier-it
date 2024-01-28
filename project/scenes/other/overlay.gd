extends ColorRect

@onready var panel = $Panel
@onready var close_button = $Panel/CloseButton


var root_scene : Control


func _ready():
	var tween = create_tween()
	panel.scale = Vector2(0, 0)
	tween.tween_property(panel, "scale", Vector2(1, 1), 0.1)

#detecting when button sound is played rather than button to prevent bug where button clicks without sound
func _on_audio_stream_player_finished():
	self.queue_free()
