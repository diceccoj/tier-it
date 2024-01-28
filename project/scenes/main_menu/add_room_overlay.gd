extends Panel

@onready var room_name = $"../RoomName"
@onready var room_code = $"../RoomCode"
@onready var submit = $"../Submit"
@onready var error_message = $"../ErrorMessage"
@onready var parent = $".."


var room_collection : FirestoreCollection
var player_collection : FirestoreCollection

var root_scene : Control

var no_errors : bool = true


#yes this code was very messy I was just learning how to make these things work now im too lazy to change it :/


func _ready():
	#get references to collections and connect it to error handling
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)
	player_collection = Firebase.Firestore.collection("players")
	player_collection.error.connect(error_handling)

#three requests, pull room data, update room data, and update player data
func _on_submit_pressed():
	if (room_name.text in User.in_rooms):
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
		
		#update user/room data
		var user_dict : Dictionary = {
			"id" : User.id,
			"username" : User.username,
			"color" : "#0000ff",
			"avatar_num" : 1
		}
		document.doc_fields.players.append(user_dict)
		User.in_rooms.append(room_name.text)
		task = room_collection.update(room_name.text, document.doc_fields)
		finished_task = await task.update_document
		if (no_errors): 
			await User.publish()
			if (no_errors):
				root_scene.refresh_list()
				parent.queue_free()
		if(!no_errors):
			error_handling("", "", "") #fields don't matter
	no_errors = true

func error_handling(code, status, message):
	no_errors = false
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	if (status == "NOT_FOUND"):
		error_message.text = "Room not found. Try a different name!"
	else:
		error_message.text = "Something went wrong. Try again later!"

