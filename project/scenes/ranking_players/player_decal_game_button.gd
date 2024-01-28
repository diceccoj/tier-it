extends Control

var player_id : String
var root_scene : Control
var placed : bool = false
var player_index : int
@onready var button = $BlankButton

func set_items_with_player(pl:Player, i:int):
	player_id = pl.id
	player_index = i
	get_child(0).set_items_with_player(pl)



#sets root_scene's selected player field
#if decal is already placed, player goes back to the the unplaced pool
func _on_blank_button_toggled(toggled_on):
	if(toggled_on and !placed):
		root_scene.set_selected_player(self)
	if(toggled_on and placed):
		root_scene.move_back_to_players(self)
		toggle_button()
	if(!toggled_on and root_scene.selected_player == self):
		root_scene.remove_selected_player()

func toggle_button():
	button.button_pressed = !button.button_pressed

#changes the placed value and changes modulate accordingly
func set_placed(to_be_placed:bool):
	placed = to_be_placed
