extends Control

#overlay/subscene
const add_list_overlay = "res://scenes/active_lists/add_list_overlay.tscn"

#nodes
@onready var add_list = $AddList
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
	
	var alb : Control
	var active_list_button : Resource = load("res://scenes/active_lists/active_list_button.tscn")
	for i in range(0, len(Room.active_lists)):
		alb = active_list_button.instantiate()
		list_container.add_child(alb)
		alb.question = Room.active_lists[i].question
		alb.index = i
		alb.root_scene = self
		alb.update_visuals()



#bring up add list overlay
func _on_add_list_pressed():
	var alo = load(add_list_overlay).instantiate()
	alo.get_child(0).root_scene = self
	self.add_child(alo)


func _on_refresh_pressed():
	await refresh_list()

#triggered when room pull fails
func room_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
