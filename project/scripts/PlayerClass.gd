class_name Player


var email : String
var username : String
var in_rooms : Array
var color : String
var avatar_num : int

var profile = {
	"username" : {},
	"in_rooms" : {},
	"color" : {},
	"avatar_num" : {}
}

#retrieve info from Firebase
func get_player_from_email(_email:String, http:HTTPRequest) -> void:
	self.email = _email
	Firebase.get_document("users/" + self.email, http)


#sending info to firebase during account creation
func publish_info_first(http:HTTPRequest):
	profile.username = username
	profile.color = color
	profile.avatar_num = 1 
	Firebase.save_document("users/?documentId%s" % self.email, profile, http)


#sending info to firebase after creating account
func publish_info(http:HTTPRequest):
	profile.username = { "stringValue" : username }
	profile.color = { "stringValue" : color }
	profile.avatar_num = { "integerValue" : 1 }
	Firebase.update_document("users/"+email, profile, http)
