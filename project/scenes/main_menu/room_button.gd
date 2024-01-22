extends Button

@onready var label = $HBoxContainer/Label
@onready var delete_room = $HBoxContainer/DeleteRoom
@export var label_name : String

@onready var root_scene : Control

const loading_overlay = "res://scenes/other/loading_overlay.tscn"
const delete_room_overlay = "res://scenes/other/delete_room_overlay.tscn"


func _ready():
	label.text = label_name
	
	Room.room_error.connect(room_error)

#download room data (if possible). Change to room menu if successful
func _on_pressed():
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
	root_scene.add_child(dro)

#change to fatal error scene if room emits an error signal
func room_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
