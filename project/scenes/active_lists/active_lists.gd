extends Control

#overlay
const add_list_overlay = "res://scenes/active_lists/add_list_overlay.tscn"

#subscene
const active_list_button = "res://subscenes/active-inactive-lists/active_list_button.tscn"

#nodes
@onready var add_list = $AddList
@onready var lists = $RoomPanel/ScrollContainer/Lists


func _ready():
	for l in lists.get_children():
		l.root_scene = self

func _on_add_list_pressed():
	var alo = load(add_list_overlay)
	self.add_child(alo.instantiate())
