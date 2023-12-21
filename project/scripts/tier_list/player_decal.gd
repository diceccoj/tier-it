extends Control

@onready var avatar = $Avatar
@onready var overlay = $Overlay
@onready var label = $Label



func set_items(color:Color, av:Texture2D, name:String):
	overlay.modulate = color
	avatar.texture = av
	label.text = name


