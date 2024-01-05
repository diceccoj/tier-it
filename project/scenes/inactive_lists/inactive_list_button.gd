extends Button


const delete_list_overlay = "res://scenes/inactive_lists/delete_list_overlay.tscn"

@onready var label = $HBoxContainer/Label
@onready var delete = $HBoxContainer/Delete
var root_scene : Control


func _on_delete_pressed():
	if (root_scene != null):
		var dlo = load(delete_list_overlay).instantiate()
		dlo.get_child(0).list_question = "abc"
		root_scene.add_child(dlo)
		


#delete button appears/disappears on hover on either self or children
func _on_mouse_entered():
	delete.visible = true


func _on_mouse_exited():
	delete.visible = false


func _on_delete_mouse_entered():
	delete.visible = true


func _on_delete_mouse_exited():
	delete.visible = false
