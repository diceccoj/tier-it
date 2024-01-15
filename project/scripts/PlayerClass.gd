class_name Player


var id : String
var username : String
var in_rooms : Array
var color : String
var avatar_num : int
var no_errors : bool = true




func grab_info_from_id(_id:String):
	#grabbing info
	var collection : FirestoreCollection = Firebase.Firestore.collection("players")
	var task : FirestoreTask = collection.get_doc(_id)
	var finished_task : FirestoreTask = await task.task_finished
	var document = finished_task.document
	
	#setting info
	self.username = document.doc_fields.username
	self.in_rooms = document.doc_fields.in_rooms
	self.color = document.doc_fields.color
	self.avatar_num = document.doc_fields.avatar_num
	self.id = _id


func publish():
	var player_dict : Dictionary = {
	"username" : self.username,
	"in_rooms" : self.in_rooms,
	"color" : self.color,
	"avatar_num" : self.avatar_num
	}
	var collection : FirestoreCollection = Firebase.Firestore.collection("players")
	collection.error.connect(general_error)
	var task : FirestoreTask = collection.update(self.id, player_dict)
	
#for other scenes to look at if something goes wrong
func general_error(code, status, message):
	self.no_errors = false
