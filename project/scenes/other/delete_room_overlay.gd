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
	
	if (no_errors): #pull room data and update fields (abort if room code doesn't match)
		var document = finished_task.document
		if (len(document.doc_fields.players) == 1): #delete if no players exist after delete
			User.player.in_rooms.erase(room_name)
			task = room_collection.delete(room_name)
			finished_task = await task.delete_document
		else: #normal delete
			document.doc_fields.players.erase(User.player.id)
			User.player.in_rooms.erase(room_name)
			task = room_collection.update(room_name, document.doc_fields)
			finished_task = await task.update_document
		
		if (no_errors): #update user data
			await User.player.publish()
			if (User.player.no_errors):
				error_message.add_theme_color_override("font_color", Color(0x29873dff))
				error_message.text = "Room removed! Exit and click refresh"
			else:
				error_handling("", "", "") #fields don't matter
				User.player.no_errors = true
	no_errors = true


func error_handling(code, status, message):
	no_errors = false
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	error_message.text = "Something went wrong. Try again later!"
