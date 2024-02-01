extends Node

var room_name : String
var room_code : String
var players : Array
var player_objects : Array
var active_lists : Array
var inactive_lists : Array
var user_index : int

signal room_error()

var room_collection : FirestoreCollection
var collection_path : String


func _ready():
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)

func user_object():
	return players[user_index]

func publish():
	#push changes
	var doc : Dictionary = {
		"players" : players,
		"room_code" : room_code,
		"active_lists" : active_lists,
		"inactive_lists" : inactive_lists
	}
	await room_collection.update(room_name, doc)

#publishes a specific value to the server (code is the exact name/spelling of the field being updated)
func publish_specific(val:String):
	var doc : Dictionary
	if (val == "players"):
		doc = {"players" : players}
	elif (val == "room_code"):
		doc = {"room_code" : room_code}
	elif (val == "active_lists"):
		doc = {"active_lists" : active_lists}
	elif (val == "inactive_lists"):
		doc = {"inactive_lists" : inactive_lists}
	else:
		room_error.emit()
		return
	await room_collection.update(room_name, doc)

#pull info from collection given name
func pull_info(doc_name:String):
	var finished_task = await room_collection.get_doc(doc_name).task_finished
	var document = await finished_task.document
	if(document != null):
		room_name = doc_name
		room_code = document.doc_fields.code
		players = document.doc_fields.players
		active_lists = document.doc_fields.active_lists
		inactive_lists = document.doc_fields.inactive_lists
		create_player_objects()
	else:
		room_name = ""
		room_code = ""
		players = []
		active_lists = []
		inactive_lists = []

#turns dictionaries in players to player objects
func create_player_objects():
	player_objects.clear()
	var p : Player
	for id in players:
		p = Player.new()
		await p.set_info_with_dict(id)
		player_objects.append(p)

func error_handling(code, status, message):
	if (status in ["ALREADY_EXISTS", "NOT_FOUND"]): #these are minor errors to be handled by other means
		pass
	else:
		room_error.emit()

func get_index_with_question(q:String, _is_active:bool):
	if(_is_active):
		for i in range(0, len(active_lists)):
			if(active_lists[i].question == q): return i
	else:
		for i in range(0, len(inactive_lists)):
			if(inactive_lists[i].question == q): return i
		

