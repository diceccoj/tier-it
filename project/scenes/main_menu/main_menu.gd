extends Control

#overlays/other nodes
const add_room_overlay = "res://scenes/main_menu/add_room_overlay.tscn"
const create_room_overlay = "res://scenes/main_menu/create_room_overlay.tscn"
const room_button = "res://scenes/main_menu/room_button.tscn"

#game objects
@onready var v_box_container = $HBoxContainer/RoomPanel/ScrollContainer/VBoxContainer
@onready var username_label = $UsernameLabel

func _ready():
	refresh_list()
	username_label.text = User.username

#summon overlay and pass self as root scene for referencing
func _on_add_pressed():
	var aro = load(add_room_overlay).instantiate()
	aro.get_child(0).root_scene = self
	self.add_child(aro)

func _on_create_pressed():
	var cro = load(create_room_overlay).instantiate()
	cro.get_child(0).root_scene = self
	self.add_child(cro)



#will refresh room list
func refresh_list():
	for n in v_box_container.get_children():
		n.queue_free()
	
	var rb : Control
	for room_name in User.in_rooms:
		rb = load(room_button).instantiate()
		rb.label_name = room_name
		rb.root_scene = self
		v_box_container.add_child(rb)


func _on_back_pressed():
	Firebase.Auth.logout()


func _on_refresh_pressed():
	refresh_list()
