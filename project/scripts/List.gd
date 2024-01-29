extends Node

@onready var index : int #position in array
@onready var question : String
@onready var players : Array #dictionaries of every player who has been in room at time of list creation (given id and username)
@onready var player_objects : Array
@onready var has_voted : Array #boolean array determining if player at same index in "players" has voted
@onready var is_active : bool #determines if list is in active_lists (true) or inactive_lists (false)
@onready var points : Array #point count for each player at their respective index



#push to active lists sub collection in room
func publish_active():
	var list_dict : Dictionary = {
		"question" : question,
		"players" : players,
		"has_voted" : has_voted,
		"points" : points
		
	}
	Room.active_lists[index] = list_dict
	Room.publish_specific("active_lists")

#grab info of list (is_active: true for active, false for inactive)
#note: inactive players don't have a
func pull_info(_index:int, _is_active:bool):
	is_active = _is_active
	if (is_active and (_index >= 0 or _index <= len(Room.active_lists))):
		index = _index
		question = Room.active_lists[index].question
		players = Room.active_lists[index].players
		has_voted = Room.active_lists[index].has_voted
		points = Room.active_lists[index].points
	elif (!is_active and (_index >= 0 or _index <= len(Room.inactive_lists))):
		index = _index
		question = Room.inactive_lists[index].question
		players = Room.inactive_lists[index].players
		points = Room.inactive_lists[index].points
		
	#setting player objects
	#possibilities: player at index of Room.players, player in Room.players but at different index, or player not in Room.players (they since left the room)
	player_objects.clear()
	for i in range(0, len(players)):
		if (i < len(Room.players) and players[i].id == Room.players[i].id):
			player_objects.append(Room.player_objects[i])
			continue
		var j = in_room_players(players[i].id)
		if(j != -1):
			player_objects.append(Room.player_objects[j])
		else:
			var dict : Dictionary = {
				"username" : players[i].username,
				"id" : players[i].id,
				"color" : "#0000ff",
				"avatar_num" : 1
			}
			var p = Player.new()
			p.set_info_with_dict(dict)
			player_objects.append(p)
		

#delete inactive list (always done after a List.pull())
func delete():
	await Room.pull_info(Room.room_name)
	Room.inactive_lists.remove_at(index)
	Room.publish_specific("inactive_lists")

#checks if player is in Room.players. Returns index if true
func in_room_players(_id : String) -> int:
	for i in range(0, len(Room.players) - 1):
		if (_id == Room.players[i].id):
			return i
	return -1

#find player dictionary index with id in List.players
func find_player_index(_id : String) -> int:
	for i in range(len(players)):
		if (players[i].id == _id):
			return i
	return -1


#deactivate a list at index
func deactivate(_index:int):
	var dict = Room.active_lists[_index]
	
	#make changes and create inactive dict (same as active lists but with out the is_voted array)
	Room.active_lists.remove_at(_index)
	Room.inactive_lists.push_front(dict)
	
	#push changes
	Room.publish()
