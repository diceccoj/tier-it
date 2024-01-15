extends ColorRect

@onready var panel = $Panel
@onready var animation_player = $AnimationPlayer

var root_scene : Control

func _ready():
	var tween = create_tween()
	panel.scale = Vector2(0, 0)
	tween.tween_property(panel, "scale", Vector2(1, 1), 0.1)
	animation_player.play("label")
