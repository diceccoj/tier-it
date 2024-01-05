extends Control


@onready var label = $HBoxContainer/Label
@onready var view_list = $HBoxContainer/ViewList
@onready var deactivate = $HBoxContainer/Deactivate

const ranking = ""
const tier_list = ""
const deactivate_list_overlay = "res://scenes/active_lists/deactivate_list_overlay.tscn"
@onready var root_scene : Control

func _ready():
	pass

#go to the tier list
func _on_pressed():
	pass # Replace with function body.



#buttons only visible if main button or one of its children is hovered on
func _on_mouse_entered():
	view_list.visible = true
	deactivate.visible = true


func _on_mouse_exited():
	view_list.visible = false
	deactivate.visible = false

func _on_view_list_mouse_entered():
	view_list.visible = true
	deactivate.visible = true


func _on_view_list_mouse_exited():
	view_list.visible = false
	deactivate.visible = false


func _on_deactivate_mouse_entered():
	view_list.visible = true
	deactivate.visible = true


func _on_deactivate_mouse_exited():
	view_list.visible = false
	deactivate.visible = false




# go to list / bring up popup
func _on_view_list_pressed():
	pass # Replace with function body.

func _on_deactivate_pressed():
	if (root_scene != null):
		var dlo = load(deactivate_list_overlay).instantiate()
		dlo.get_child(0).list_question = "abc"
		root_scene.add_child(dlo)
	


