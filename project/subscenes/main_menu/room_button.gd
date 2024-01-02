extends Button

@onready var label = $HBoxContainer/Label
@onready var delete_room = $HBoxContainer/DeleteRoom
@export var label_name : String

func _ready():
	label.text = label_name

#go to the room
func _on_pressed():
	pass # Replace with function body.



#delete button only visible if main button is hovered on
func _on_mouse_entered():
	delete_room.visible = true

func _on_mouse_exited():
	delete_room.visible = false
	


#bring up popup
func _on_delete_room_pressed():
	pass # Replace with function body.





