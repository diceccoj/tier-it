extends Control

@onready var avatar = $Avatar
@onready var overlay = $Overlay
@onready var label = $Label

var player : Player



func _ready():
	player = Player.new()

#triggered whenever a change is made
func update_visuals():
	if (player != null):
		overlay.modulate = Color.html(player.color)
		label.text = player.username
		avatar.texture = load("res://images/tier list/avatar/Layer %s.png" % player.avatar_num)


#get/set functions
func set_items_with_player(pl:Player):
	player = pl
	self.update_visuals()
	

func set_items(us:String, av:int, clr:String):
	self.set_username(us)
	self.set_avatar(av)
	self.set_color(Color.html(clr))

func set_color(color:Color):
	overlay.modulate = color
	player.color = color.to_html()

func get_color():
	return overlay.modulate

func set_username(name:String):
	label.text = name
	player.username = name
	
func get_username():
	return label.text
	
func set_avatar(image_num : int):
	player.avatar_num = image_num
	avatar.texture = load("res://images/tier list/avatar/Layer %s.png" % image_num)

