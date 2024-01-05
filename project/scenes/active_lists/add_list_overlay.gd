extends LineEdit

@onready var overlay = $".."
@onready var random = $"../Random"
@onready var create = $"../Create"
@onready var error_message = $"../ErrorMessage"


#for create button
func _on_audio_stream_player_finished():
	#update database and close overlay unless error
	pass

#pick a random sample question
func _on_random_pressed():
	var rng = RandomNumberGenerator.new()
	var i = rng.randi_range(0, len(sample_questions) - 1)
	text = sample_questions[i]





var sample_questions = [
	"Who is the funniest?",
	"Who is the coolest?",
	"Who is most likely to dominate a basketball game?",
	"Who is the biggest gamer?",
	"Most likely to buy something pricey and never use it",
	"Most likely to dress as Santa Claus",
	"Who eats out the most",
	"Who falls over the most?",
	"Who reads the most",
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


