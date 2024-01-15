extends Node

var room_name : String
var room_code : String
var players : Array
var player_objects : Array
var active_lists : Array
var inactive_lists : Array

var no_errors : bool = true

var room_collection : FirestoreCollection
var collection_path : String


func _ready():
	room_collection = Firebase.Firestore.collection("rooms")
	room_collection.error.connect(error_handling)


func publish():
	#push changes
	var doc : Dictionary = {
		"players" : players,
		"room_code" : room_code,
		"active_lists" : active_lists,
		"inactive_lists" : inactive_lists
	}
	await room_collection.update(room_name, doc)

#pull info from collection given name
func pull_info(doc_name:String):
	
	#pull and set data
	var finished_task = await room_collection.get_doc(doc_name).task_finished
	if (no_errors):
		var document = finished_task.document
		room_name = doc_name
		room_code = document. doc_fields.code
		players = document.doc_fields.players
		active_lists = document.doc_fields.active_lists
		inactive_lists = document.doc_fields.inactive_lists
		
		#creating player objects
		var p : Player
		for id in players:
			p = Player.new()
			await p.grab_info_from_id(id)
			if (p.no_errors): player_objects.append(p)
			else:
				no_errors = false
				break




func error_handling(code, status, message):
	no_errors = false
