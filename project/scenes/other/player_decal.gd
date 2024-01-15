extends Control

@onready var avatar = $Avatar
@onready var overlay = $Overlay
@onready var label = $Label
@onready var point_count = $PointCount

var player : Player



func _ready():
	player = Player.new()

#triggered whenever a change is made
func update_visuals():
	if (player != null and overlay != null):
		avatar.texture = load("res://images/tier list/avatar/Layer %s.png" % player.avatar_num)
		overlay.modulate = Color.html(player.color)
		label.text = player.username
	elif (player != null): #fixing an odd bug where references are null
		get_child(0).texture = load("res://images/tier list/avatar/Layer %s.png" % player.avatar_num)
		get_child(1).modulate = Color.html(player.color)
		get_child(2).text = player.username

#get/set functions
func set_items_with_player(pl:Player):
	self.player = pl
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

