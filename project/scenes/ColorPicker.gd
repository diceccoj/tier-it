extends ColorPicker

@onready var player = $"../../Player"


func _ready():
	pass #color = player.get_color()
	



func _on_color_changed(color):
	player.set_color(color)
