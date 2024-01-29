extends Button


const delete_list_overlay = "res://scenes/inactive_lists/delete_list_overlay.tscn"
@onready var audio_stream_player = $AudioStreamPlayer
@onready var index : int
@onready var delete = $HBoxContainer/Delete
@onready var label = $HBoxContainer/Label
var root_scene : Control

func _on_pressed():
	audio_stream_player.play()
	var lo : Control = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	await List.pull_info(index, false)
	get_tree().change_scene_to_file("res://scenes/tier_list/tier_list.tscn")



func _on_delete_pressed():
	if (root_scene != null):
		if (User.id != Room.players[0].id): #if user isnt admin
			root_scene.add_child(load("res://scenes/other/not_admin_overlay.tscn").instantiate())
			return
		var dlo = load(delete_list_overlay).instantiate()
		dlo.get_child(0).index = index
		dlo.get_child(0).root_scene = root_scene
		root_scene.add_child(dlo)
		

func refresh_visuals():
	label.text = Room.inactive_lists[index].question

#delete button appears/disappears on hover on either self or children
func _on_mouse_entered():
	delete.visible = true


func _on_mouse_exited():
	delete.visible = false


func _on_delete_mouse_entered():
	delete.visible = true


func _on_delete_mouse_exited():
	delete.visible = false



