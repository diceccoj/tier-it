extends Node

@onready var question : String
@onready var players : Array #dictionaries of every player who has been in room at time of list creation (given id and username)
@onready var player_objects : Array
@onready var has_voted : Array #boolean array determining if player at same index in "players" has voted

signal error() #signal for general errors

signal copy_error() #signal for whe

#always done immediately after a Room.pull()
func create_active(_question:String):
	var al_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/active_lists_collection")
	al_collection.error.connect(general_error)
	
	#making dictionary
	var _has_voted : Array = []
	var _players : Array = []
	for dict in Room.players:
		_players.append({
			"id" : dict.id,
			"username" : dict.username,
			"points" : 0
		})
		_has_voted.append(false)
	var active_dict : Dictionary = {
		"has_voted" : _has_voted,
		"players" : _players
	}
	
	#push changes
	Room.active_lists.append(_question)
	Room.publish()
	await al_collection.add(_question, active_dict)

#push to active lists sub collection in room
func publish_active():
	var list_dict : Dictionary = {
		"players" : players,
		"has_voted" : has_voted
	}
	var al_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/active_lists_collection")
	al_collection.error.connect(general_error)
	var task : FirestoreTask = al_collection.update(question, list_dict)
	var finished_task = await task.task_finished

#grab info of list (is_active: true for active, false for inactive)
#note: inactive players don't have a
func pull(q:String, is_active:bool):
	#grab info
	var al_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/active_lists_collection")
	al_collection.error.connect(general_error)
	var task : FirestoreTask = al_collection.get_doc(q)
	var finished_task = await task.task_finished
	
	#set given info to variables
	var document : FirestoreDocument = finished_task.document
	question = document.doc_name
	players = document.doc_fields.players
	if (document.doc_fields.has_voted != null): #doesn't exist in inactive lists
		has_voted = document.doc_fields.has_voted
	
	#setting player objects (many possibilities)
	for i in range(0, len(players) - 1):
		
		#if player is at exact index as Room.player
		if (players[i].id == Room.players[i].id):
			player_objects[i] = Room.player_objects[i]
			break
		
		#if player is in Room.players but at wrong index
		var j : int = in_room_players(players[i].id)
		if (j != -1):
			player_objects[i] = Room.player_objects[j]
		
		#player has left room (make dummy player object)
		else:
			var new_dict : Dictionary = {
				"id" : players[i].id,
				"username" : players[i].username,
				"color" : "#0000ff",
				"avatar_num" : 1,
				"points" : players[i].points
			}
			var temp = Player.new()
			temp.set_info_with_dict(new_dict)
			player_objects[i] = temp

#deactivate list (always done after List.pull())
func deactivate():
	await Room.pull()
	
	#initialization
	var al_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/active_lists_collection")
	al_collection.error.connect(general_error)
	var il_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/inactive_lists_collection")
	il_collection.error.connect(general_error)
	
	#make changes and create inactive dict (same as active lists but with out the is_voted array)
	Room.active_lists.erase(question)
	Room.inactive_lists.push_front(question)
	var inactive_dict : Dictionary = {
		"players" : players
	}
	
	#push changes
	Room.publish()
	al_collection.delete("question")
	await il_collection.add("question", inactive_dict)


#delete inactive list (always done after a List.pull())
func delete():
	await Room.pull()
	
	#initialization
	var il_collection : FirestoreCollection = Firebase.Firestore.collection("rooms/" + Room.room_name + "/inactive_lists_collection")
	il_collection.error.connect(general_error)
	
	#make changes
	Room.inactive_lists.erase(question)
	
	#push changes
	Room.publish()
	await il_collection.delete(question)

#checks if player is in Room.players. Returns index if true
func in_room_players(_id : String) -> int:
	for i in range(0, len(Room.players) - 1):
		if (_id == Room.players[i].id):
			return i
	return -1

func general_error(code, status, message):
	error.emit()
