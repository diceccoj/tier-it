extends Control


@onready var label = $HBoxContainer/Label
@onready var view_list = $HBoxContainer/ViewList
@onready var deactivate = $HBoxContainer/Deactivate
@onready var audio_stream_player = $AudioStreamPlayer

var question : String
var index : int
@onready var root_scene : Control

const deactivate_list_overlay = "res://scenes/active_lists/deactivate_list_overlay.tscn"
const already_voted_overlay = "res://scenes/active_lists/already_voted_overlay.tscn"
const not_in_room_overlay = "res://scenes/active_lists/not_in_room_overlay.tscn"



func update_visuals():
	if(question != null):
		label.text = question

#go to the tier list ranking
func _on_pressed():
	audio_stream_player.play()
	var lo : Control = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	await List.pull_info(index, true)
	var player_index : int = List.find_player_index(User.id)
	lo.queue_free()
	
	#if player isn't in the tier list
	if (player_index == -1):
		root_scene.add_child(load(not_in_room_overlay).instantiate())
	#if player already voted
	elif List.has_voted[player_index]:
		root_scene.add_child(load(already_voted_overlay).instantiate())
	else:
		get_tree().change_scene_to_file("res://scenes/ranking_players/ranking_players.tscn")
	


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
	var lo : Control = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	await List.pull_info(index, true)
	get_tree().change_scene_to_file("res://scenes/tier_list/tier_list.tscn")

func _on_deactivate_pressed():
	if (root_scene != null):
		if (User.id != Room.players[0].id): #bring popup if user isn't admin
			root_scene.add_child(load("res://scenes/other/not_admin_overlay.tscn").instantiate())
		else:
			var dlo = load(deactivate_list_overlay).instantiate()
			dlo.get_child(0).index = index
			dlo.get_child(0).root_scene = root_scene
			root_scene.add_child(dlo)


func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")


