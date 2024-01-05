extends Panel

var root_scene : Control
@onready var players = $"../Players"

func _ready():
	for p in players.get_children():
		p.root_scene = root_scene
