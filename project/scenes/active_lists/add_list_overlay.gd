extends Panel

var root_scene : Control


@onready var parent = $".."
@onready var question_field = $"../QuestionField"
@onready var random = $"../Random"
@onready var create = $"../Create"
@onready var error_message = $"../ErrorMessage"



func _ready():
	Room.room_error.connect(general_error)


#for create button
func _on_audio_stream_player_finished():
	#update database and close overlay unless error
	pass

#pick a random sample question
func _on_random_pressed():
	var rng = RandomNumberGenerator.new()
	var i = rng.randi_range(0, len(sample_questions) - 1)
	question_field.text = sample_questions[i]


func _on_create_pressed():
	#initialzation
	
	#if question is already made in room
	for dict in Room.active_lists:
		if(question_field.text == dict.question):
			error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
			error_message.text = "This question already has a list in this room"
			return
	for dict in Room.inactive_lists:
		if(question_field.text == dict.question):
			error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
			error_message.text = "This question already has a list in this room"
			return

	
	var lo = load("res://scenes/other/loading_overlay.tscn").instantiate()
	root_scene.add_child(lo)
	await Room.pull_info(Room.room_name)
	
	#making dictionary
	var _has_voted : Array = []
	var _players : Array = []
	var _points : Array = []
	for dict in Room.players:
		_players.append({
			"id" : dict.id,
			"username" : dict.username
		})
		_has_voted.append(false)
		_points.append(0)
	
	var active_dict : Dictionary = {
		"question" : question_field.text,
		"has_voted" : _has_voted,
		"players" : _players,
		"points" : _points
	}
	
	#push changes
	Room.active_lists.push_front(active_dict)
	await Room.publish_specific("active_lists")
	
	#refresh and kill overlay
	lo.queue_free()
	root_scene.fill_list_container()
	parent.queue_free()



var sample_questions = [
	"Who is the funniest?",
	"Who is the coolest?",
	"Who is most likely to kill it in a basketball game?",
	"Who is the biggest gamer?",
	"Most likely to buy something pricey and never use it",
	"Most likely to dress as Santa Claus",
	"Who falls over the most?",
	"Who reads the most?",
	"Most likely to forget to shower",
	"Comes up with the best Halloween costumes",
	"Most likely to be rickrolled",
	"Most likely to pretend to be a cat",
	"Most likely to pretend to be a dog",
	"Who has the best music taste?",
	"Who has the worst music taste?",
	"Who watches the most movies?",
	"Most likely to die first in a horror movie",
	"Most likely to brag about their grade online",
	"Who is the biggest class clown?",
	"Who will eat a whole tub of ice cream in one sitting?",
	"Who is the most basic in the group?",
	"Who has the worst taste in food?",
	"Who will lose in any game you pick?",
	"Who does the best secret santa gifts?"
]


#error cases
func general_error():
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")





