extends Panel

var room_name : String
var room_collection : FirestoreCollection
var player_collection : FirestoreCollection
var no_errors : bool = true

@onready var error_message = $"../ErrorMessage"


func _ready():
	#get references to collections and connect it to error handling
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)
	player_collection = Firebase.Firestore.collection("players")
	player_collection.error.connect(error_handling)


func _on_yes_pressed():
	var task : FirestoreTask = room_collection.get_doc(room_name)
	var finished_task = await task.task_finished
	var document = finished_task.document
	
	#erase from room data
	for dict in document.doc_fields.players:
		if (User.id == dict.id):
			document.doc_fields.players.erase(dict)
	
	#grabbing info for user and editing data
	User.in_rooms.erase(room_name)
	
	#push all changes to player and room
	User.publish()
	await room_collection.update(room_name, document.doc_fields)
	error_message.add_theme_color_override("font_color", Color(0x29873dff))
	error_message.text = "Room deleted! Exit and hit refresh!"
	



func error_handling(code, status, message):
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
