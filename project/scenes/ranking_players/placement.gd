extends Panel

var root_scene : Control
@onready var button = $Button
@onready var player_slot = $PlayerSlot
@onready var label = $Label
var placement : int


func _on_button_toggled(toggled_on):
	if (toggled_on):
		root_scene.set_selected_placement(self)
	elif(!toggled_on and root_scene.selected_placement == self):
		root_scene.remove_selected_placement()

func toggle_button():
	button.button_pressed = !button.button_pressed

func empty_status():
	return player_slot.get_child_count() == 0

func set_placement(j:int):
	placement = j
	label.text = str(placement)
	
	
