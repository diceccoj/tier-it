extends Panel

@onready var has_voted_grid = $"../HasVoted"
@onready var didnt_vote = $"../Didn'tVote"

#shows player who and who didn't vote on the list
func _ready():
	var player_decal = load("res://scenes/other/player_decal.tscn")
	var pl : Node
	for i in range(0, len(List.player_objects)):
		pl = player_decal.instantiate()
		if (List.has_voted[i]):
			has_voted_grid.add_child(pl)
		else:
			didnt_vote.add_child(pl)
		pl.set_items_with_player(List.player_objects[i])
