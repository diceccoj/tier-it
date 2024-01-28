extends Control


#keeps track of which objects are currently selected by the player
@onready var selected_player : Node
@onready var selected_placement : Node
@onready var players = $PlayerPanel/Players
@onready var rankings = $RankingPanel/ScrollContainer/Rankings
@onready var question = $Question

#overlays
var tutorial = "res://scenes/ranking_players/tutorial_overlay.tscn"
var are_you_sure = "res://scenes/ranking_players/are_you_sure_overlay.tscn"
var unselected_players = "res://scenes/ranking_players/unselected_players_overlay.tscn"

func _ready():
	var game_button = load("res://scenes/ranking_players/player_decal_game_button.tscn")
	var placement = load("res://scenes/ranking_players/placement.tscn")
	
	#empty any existing nodes
	
	question.text = List.question
	
	#setting player objects to buttons and setting up rankings
	var gb : Control
	var pl : Control
	for i in range(0, len(List.player_objects)):
		gb = game_button.instantiate()
		gb.set_items_with_player(List.player_objects[i], i)
		gb.root_scene = self
		players.add_child(gb)
		pl = placement.instantiate()
		rankings.add_child(pl)
		pl.set_placement(i+1)
		pl.root_scene = self



#changes selected player
#if already filled swaps all relevant values: parents, placed values, then deselects them both
func set_selected_player(player:Node):
	if(selected_player == null):
		selected_player = player
	else: 
		var temp : bool = selected_player.placed
		selected_player.set_placed(player.placed)
		player.set_placed(temp)
		
		var p1 : Node = selected_player.get_parent()
		var p2 : Node = player.get_parent()
		
		p1.remove_child(selected_player)
		p2.remove_child(player)
		p1.add_child(player)
		p2.add_child(selected_player)
		
		selected_player.toggle_button()
		player.toggle_button()
	
	check_for_placing()


#moves already selected player back to 'players' node
func move_back_to_players(player:Node):
	if (player.placed):
		var p : Control = player.get_parent_control()
		p.remove_child(player)
		players.add_child(player)
		player.set_placed(false)

#sets selected placement
func set_selected_placement(placement:Node):
	if(selected_placement == null):
		selected_placement = placement
	else:
		selected_placement.toggle_button()
		selected_placement = placement
	check_for_placing()

#checks to see if selected player can be moved to placement
func check_for_placing():
	if(selected_player != null and selected_placement != null):
		if(selected_placement.empty_status()):
			var p : Node = selected_player.get_parent()
			p.remove_child(selected_player)
			selected_placement.get_child(2).add_child(selected_player)
		selected_placement.toggle_button()
		selected_player.toggle_button()
		remove_selected_placement()
		remove_selected_player()

func remove_selected_player():
	selected_player = null

func remove_selected_placement():
	selected_placement = null



#gives players any necessary warnings and submits info
func _on_submit_pressed():
	if (players.get_child_count() != 0):
		var upo = load(unselected_players).instantiate()
		upo.get_child(0).root_scene = self
		add_child(upo)
	else:
		var ayso = load(are_you_sure).instantiate()
		ayso.get_child(0).root_scene = self
		add_child(ayso)

#submits answers to Firestore
func submit():
	await Room.pull_info(Room.room_name)
	
	#change User's voted value to true
	List.has_voted[List.find_player_index(User.id)] = true
	
	#change point counts
	var increment : int
	var player_index : int
	for node in rankings.get_children():
		increment = node.placement
		player_index = node.player_slot.get_child(0).player_index
		List.points[player_index] += increment
	
	#push changes (if everyone has voted, deactivate)
	var everyone_has_voted : Array #an array of all trues
	for i in range(0, len(List.players)):
		everyone_has_voted.append(true)
	if(List.has_voted == everyone_has_voted):
		var temp = List.active_lists.find(question.text)
		List.deactivate(temp)
	else:
		Room.publish_specific("active_lists")
