extends Panel

@onready var room_name = $"../RoomName"
@onready var room_code = $"../RoomCode"
@onready var submit = $"../Submit"
@onready var error_message = $"../ErrorMessage"

var room_collection : FirestoreCollection
var player_collection : FirestoreCollection

var root_scene : Control

var no_errors : bool = true

func _ready():
	#get references to collections and connect it to error handling
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)
	player_collection = Firebase.Firestore.collection("players")
	player_collection.error.connect(error_handling)

#three requests, pull room data, update room data, and update player data
func _on_submit_pressed():
	if (room_name.text in User.player.in_rooms):
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "You're already in this room!"
		return
	var task : FirestoreTask = room_collection.get_doc(room_name.text)
	var finished_task = await task.task_finished
	
	if (no_errors): #pull room data and update fields (abort if room code doesn't match)
		var document = finished_task.document
		
		#denying user access over specific conditions
		if (room_code.text != document.doc_fields.code):
			error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
			error_message.text = "You don't have the right code!"
			return
		elif (len(document.doc_fields.players) >= 20):
			error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
			error_message.text = "This room has reached the max amount of players!"
			return
		
		#update user data
		document.doc_fields.players.append(User.player.id)
		User.player.in_rooms.append(room_name.text)
		task = room_collection.update(room_name.text, document.doc_fields)
		finished_task = await task.update_document
		if (no_errors): 
			await User.player.publish()
			if (User.player.no_errors):
				error_message.add_theme_color_override("font_color", Color(0x29873dff))
				error_message.text = "Room Added! Exit and click refresh"
			else:
				error_handling("", "", "") #fields don't matter
				User.player.no_errors = true
	no_errors = true

func error_handling(code, status, message):
	no_errors = false
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	no_errors = false
	if (status == "NOT_FOUND"):
		error_message.text = "Room not found. Try a different name!"
	else:
		error_message.text = "Something went wrong. Try again later!"

