extends Control

const add_room_overlay = "res://scenes/main_menu/add_room_overlay.tscn"
const create_room_overlay = "res://scenes/main_menu/create_room_overlay.tscn"


#summon overlay and pass self as root scene for referencing
func _on_add_pressed():
	var aro = load(add_room_overlay).instantiate()
	aro.get_child(0).root_scene = self
	self.add_child(aro)
func _on_create_pressed():
	var cro = load(create_room_overlay).instantiate()
	cro.get_child(0).root_scene = self
	self.add_child(cro)



#will refresh room list
func refresh():
	pass
