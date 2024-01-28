extends Panel

#will be passed by parent scene
var index : int
var root_scene : Control
@onready var error_message = $"../ErrorMessage"
@onready var parent = $".."


func _ready():
	Room.room_error.connect(general_error)


func _on_yes_pressed():
	#initialization
	var lo = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	await Room.pull_info(Room.room_name)
	
	await List.deactivate(index)
	
	#refresh list and close scene
	root_scene.fill_list_container()
	parent.queue_free()
	lo.queue_free()


#error cases
func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")


