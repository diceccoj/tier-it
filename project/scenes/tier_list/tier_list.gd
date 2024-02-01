extends Node


#Tier Panels
@onready var s_grid = $"TierList/S-Tier/TierPanel/Players"
@onready var a_grid = $"TierList/A-Tier/TierPanel/Players"
@onready var b_grid = $"TierList/B-Tier/TierPanel/Players"
@onready var c_grid = $"TierList/C-Tier/TierPanel/Players"
@onready var d_grid = $"TierList/D-Tier/TierPanel/Players"
@onready var f_grid = $"TierList/F-Tier/TierPanel/Players"


#Holding Placements
var s_placements : Array
var a_placements : Array
var b_placements : Array
var c_placements : Array
var d_placements : Array
var f_placements : Array

#display thresholds (N = players who voted, m = amount of points given for first place
@onready var max = $Thresholds/Max # N*m
@onready var s_threshold = $"Thresholds/S-Threshold" # 5(N*m)/6
@onready var a_threshold = $"Thresholds/A-Threshold" # 4(N*m)/6
@onready var b_threshold = $"Thresholds/B-Threshold" # 3(N*m)/6
@onready var c_threshold = $"Thresholds/C-Threshold" # 2(N*m)/6
@onready var d_threshold = $"Thresholds/D-Threshold" #  (N*m)/6

@onready var who_voted = $WhoVoted
@onready var pop_sound = $PopSound
@onready var clapping_sound = $ClappingSound
@onready var question = $Question



#overlay
var who_voted_overlay = "res://scenes/tier_list/who_voted_overlay.tscn"
var player_decal = load("res://scenes/other/player_decal.tscn")

func _ready():
	question.text = List.question
	
	#calculating thresholds and setting the indictators to let people know
	var voted_count = List.has_voted.count(true)
	var best_score = len(List.players) - 1
	var max_val = voted_count * best_score
	var s_thresh_val = round(5*(voted_count * best_score)/6)
	var a_thresh_val = round(4*(voted_count * best_score)/6)
	var b_thresh_val = round(3*(voted_count * best_score)/6)
	var c_thresh_val = round(2*(voted_count * best_score)/6)
	var d_thresh_val = round(1*(voted_count * best_score)/6)
	
	max.text = str(max_val)
	s_threshold.text = str(s_thresh_val)
	a_threshold.text = str(a_thresh_val)
	b_threshold.text = str(b_thresh_val)
	c_threshold.text = str(c_thresh_val)
	d_threshold.text = str(d_thresh_val)
	
	await sort_list_players()
	#initiate players objects and assign them to tier lists
	var pd : Node
	for i in range(0, len(List.points)):
		pd = player_decal.instantiate()
		if (List.points[i] >= s_thresh_val):
			s_grid.add_child(pd)
		elif (List.points[i] >= a_thresh_val):
			a_grid.add_child(pd)
		elif (List.points[i] >= b_thresh_val):
			b_grid.add_child(pd)
		elif (List.points[i] >= c_thresh_val):
			c_grid.add_child(pd)
		elif (List.points[i] >= d_thresh_val):
			d_grid.add_child(pd)
		else:
			f_grid.add_child(pd)
		pd.set_items_with_player(List.player_objects[i])
		pd.set_points(List.points[i])



#sorts List.player_objects and List.players along with the points category (insertion sort - descending order)
func sort_list_players():
	var temp_point : int
	var temp_po : Player
	var temp_player : Dictionary
	var temp_hv : int
	var index : int
	for i in range(1, len(List.points)):
		temp_point = List.points[i]
		temp_po = List.player_objects[i]
		temp_player = List.players[i]
		temp_hv = List.has_voted[i]
		index = i - 1
		while (index >= 0 and temp_point < List.points[index]):
			List.points[index + 1] = List.points[index]
			List.player_objects[index + 1] = List.player_objects[index]
			List.players[index + 1] = List.players[index]
			List.has_voted[index + 1] = List.has_voted[index]
			index -=1
		List.points[index + 1] = temp_point
		List.player_objects[index + 1] = temp_po
		List.players[index + 1] = temp_player
		List.has_voted[index + 1] = temp_hv
	List.points.reverse()
	List.players.reverse()
	List.player_objects.reverse()
	List.has_voted.reverse()




func _on_who_voted_pressed():
	self.add_child(load(who_voted_overlay).instantiate())
