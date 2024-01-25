extends Node

#stores user data for easy access if program

var id : String
var username : String
var in_rooms : Array

func grab_info_from_id(_id:String):
	#grabbing info
	var collection : FirestoreCollection = Firebase.Firestore.collection("players")
	var task : FirestoreTask = collection.get_doc(_id)
	var finished_task : FirestoreTask = await task.task_finished
	var document = finished_task.document
	
	#setting info
	self.username = document.doc_fields.username
	self.in_rooms = document.doc_fields.in_rooms
	self.id = _id

func publish():
	var player_dict : Dictionary = {
	"username" : username,
	"in_rooms" : in_rooms
	}
	var collection : FirestoreCollection = Firebase.Firestore.collection("players")
	var task : FirestoreTask = collection.update(self.id, player_dict)

