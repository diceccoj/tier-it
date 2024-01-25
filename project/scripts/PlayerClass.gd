class_name Player


var id : String
var username : String
var color : String
var avatar_num : int
var points : int = 0

var no_errors : bool = true

signal player_error()


#used for getting info
func set_info_with_dict(dict:Dictionary):
	id = dict.id
	username = dict.username
	color = dict.color
	avatar_num = dict.avatar_num

func export_dict():
	var dict : Dictionary = {
		"id" : self.id,
		"username" : self.username,
		"color" : self.color,
		"avatar_num" : self.avatar_num
	}
	return dict

#add points to current total
func add_points(new_points : int):
	points += new_points

#for other scenes to look at if something goes wrong
func general_error(code, status, message):
	player_error.emit()
