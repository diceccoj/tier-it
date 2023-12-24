extends TextureRect

@export var image : Texture2D
@export var player : Control


func _ready():
	texture = image

func _on_button_pressed():
	if (player != null):
		player.set_avatar(image)
