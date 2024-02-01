extends Button

@onready var label = $HBoxContainer/Label
@onready var delete_room = $HBoxContainer/DeleteRoom
@onready var label_name
@onready var root_scene : Control
@onready var audio_stream_player = $AudioStreamPlayer

const loading_overlay = "res://scenes/other/loading_overlay.tscn"
const delete_room_overlay = "res://scenes/other/delete_room_overlay.tscn"


func _ready():
	label.text = label_name

#download room data (if possible). Change to room menu if successful
func _on_pressed():
	audio_stream_player.play()
	root_scene.add_child(load(loading_overlay).instantiate())
	await Room.pull_info(label_name)
	get_tree().change_scene_to_file("res://scenes/room_menu/room_menu.tscn")


#delete button only visible if main button or itself is hovered on
func _on_mouse_entered():
	delete_room.visible = true

func _on_mouse_exited():
	delete_room.visible = false
	
func _on_delete_room_mouse_entered():
	delete_room.visible = true

func _on_delete_room_mouse_exited():
	delete_room.visible = false



#bring up popup
func _on_delete_room_pressed():
	var dro : Node = load(delete_room_overlay).instantiate()
	dro.get_child(0).room_name = label_name
	dro.get_child(0).root_scene = root_scene
	root_scene.add_child(dro)
