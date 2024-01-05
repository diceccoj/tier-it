extends Control


#nodes
@onready var lists = $RoomPanel/ScrollContainer/Lists


func _ready():
	for l in lists.get_children():
		l.root_scene = self
