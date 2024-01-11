extends TextureRect

@export var image_num : int
@export var player : Control


func _ready():
	var str 
	texture = load("res://images/tier list/avatar/Layer %s.png" % image_num)

func _on_button_pressed():
	if (player != null):
		player.set_avatar(image_num)
