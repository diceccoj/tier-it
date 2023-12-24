extends LineEdit

@onready var player = $"../Player"


func _ready():
	text = player.get_username()



#updates name of sample player
func _on_text_changed(new_text):
	player.set_username(new_text)
