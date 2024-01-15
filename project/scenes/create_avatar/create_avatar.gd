extends Control

@onready var color_picker = $Color/ColorPicker
@onready var player = $Player
@onready var username_field = $UsernameField

var player_object : Player

func _ready():
	player_object = User.player
	player.set_items_with_player(player_object)
	color_picker.color = player_object.color
	username_field.text = player_object.username




func _on_set_avatar_pressed():
	User.player = player_object
	await User.player.publish()
