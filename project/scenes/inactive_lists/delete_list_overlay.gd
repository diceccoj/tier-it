extends Panel


#will be passed by parent scene
var index : int
var root_scene : Control
@onready var parent = $".."


func _on_yes_pressed():
	Room.room_error.connect(general_error)
	
	var lo = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	
	#pull latest info, make changes, and push to database
	await Room.pull_info(Room.room_name)
	Room.inactive_lists.remove_at(index)
	await Room.publish_specific("inactive_lists")
	
	#close overlays and refresh list
	root_scene.fill_list_container()
	lo.queue_free()
	parent.queue_free()



func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
