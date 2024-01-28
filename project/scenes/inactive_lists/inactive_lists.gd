extends Control

@onready var list_container = $RoomPanel/ScrollContainer/Lists



func _ready():
	Room.room_error.connect(room_error)
	fill_list_container()
	

#pull room info tp update active lists
func refresh_list():
	var lo : Control = load("res://scenes/other/loading_overlay.tscn").instantiate()
	add_child(lo)
	await Room.pull_info(Room.room_name)
	fill_list_container()
	lo.queue_free()

#clear list container (if needed) and refill it with new question list
func fill_list_container():
	for child in list_container.get_children():
		child.queue_free()
	
	var ilb : Control
	var inactive_list_button : Resource = load("res://scenes/inactive_lists/inactive_list_button.tscn")
	for i in range(0, len(Room.inactive_lists)):
		ilb = inactive_list_button.instantiate()
		list_container.add_child(ilb)
		ilb.index = i
		ilb.refresh_visuals()
		ilb.root_scene = self
		ilb.refresh_visuals()



#bring up add list overlay

func _on_refresh_pressed():
	await refresh_list()

#triggered when room pull fails
func room_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
