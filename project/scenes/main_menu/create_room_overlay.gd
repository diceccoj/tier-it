extends Panel


var root_scene : Control

@onready var room_name = $"../Room Name"
@onready var submit = $"../Submit"
@onready var error_message = $"../ErrorMessage"
@onready var room_code = $"../Room Code"

@onready var player_collection : FirestoreCollection
@onready var room_collection : FirestoreCollection

var no_errors : bool = true

#initialize collections and connect them to error handling
func _ready():
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)

	player_collection = Firebase.Firestore.collection("players")
	player_collection.error.connect(error_handling)



func _on_submit_pressed():
	#create room (if possible)
	var user_dict : Dictionary = {
		"id" : User.id,
		"username" : User.username,
		"color" : "#0000ff",
		"avatar_num" : 1
	}
	var room_data : Dictionary = {
		"players" : [user_dict],
		"code" : room_code.text,
		"active_lists" : [],
		"inactive_lists" : []
	}
	var task : FirestoreTask = room_collection.add(room_name.text, room_data)
	await task.add_document
	if (no_errors):
		User.in_rooms.append(room_name.text)
		await User.publish()
		error_message.add_theme_color_override("font_color", Color(0x29873dff))
		error_message.text = "Room Created! Exit and click refresh"
	else: #reset no_errors
		no_errors = true



#let user know
func error_handling(code, status, message):
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	no_errors = false
	if (status == "ALREADY_EXISTS"):
		error_message.text = "This room already exists. Try a different name!"
	else:
		error_message.text = "Something went wrong. Try again later!"

