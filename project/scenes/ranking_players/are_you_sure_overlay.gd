extends Panel

var root_scene : Node
@onready var parent = $".."

func _ready():
	Room.room_error.connect(general_error)

#submits answers to firestore and switches to the tier list
func _on_yes_pressed():
	BGM.play_normal()
	root_scene.add_child(load("res://scenes/other/loading_overlay.tscn").instantiate())
	await root_scene.submit()
	get_tree().change_scene_to_file("res://scenes/tier_list/tier_list.tscn")


func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
