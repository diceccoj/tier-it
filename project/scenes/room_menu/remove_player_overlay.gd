extends Panel


var player_to_remove : String #their id
var player_overlay : Control
@onready var parent = $".."

@onready var loading_message = $"../LoadingMessage"

func _ready():
	Room.room_error.connect(error)

#pull room and clear player from the database
func _on_yes_pressed():
	#making loading message
	loading_message.add_theme_color_override("font_color", Color(0x909090ff))
	loading_message.text = "Loading..."
	
	#grab room info
	await Room.pull_info(Room.room_name)
	
	#grabbing info for room and erasing player data
	for i in range(0, len(Room.players) - 1):
		if (player_to_remove == Room.players[i].id):
			Room.player_objects.remove_at(i)
			Room.players.remove_at(i)
			break
	
	#grabbing info for user and editing data
	var collection : FirestoreCollection = Firebase.Firestore.collection("players")
	collection.error.connect(player_error)
	var task : FirestoreTask = collection.get_doc(player_to_remove)
	var finished_task : FirestoreTask = await task.task_finished
	var document = finished_task.document
	print(Room.room_name)
	document.doc_fields.in_rooms.erase(Room.room_name)
	
	#push all changes to player and room
	collection.update(player_to_remove, document.doc_fields)
	await Room.publish()
	
	#remove self from scene tree
	player_overlay.empty_player_grid()
	await player_overlay.refresh_players()
	parent.queue_free()


func error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")

#same as the function above for different kind of signal
func player_error(code, status, message):
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
