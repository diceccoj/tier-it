extends Control

@onready var avatar = $Avatar
@onready var overlay = $Overlay
@onready var label = $Label



func set_items(color:Color, av:Texture2D, name:String):
	overlay.modulate = color
	avatar.texture = av
	label.text = name

func set_color(color:Color):
	overlay.modulate = color

func get_color():
	return overlay.modulate

func set_username(name:String):
	label.text = name
	
func get_username():
	return label.text
	
func set_avatar(image:Texture2D):
	avatar.texture = image

