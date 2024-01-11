extends Control

@onready var email = $Email
@onready var password = $Password
@onready var login = $Login
@onready var error_message = $ErrorMessage
@onready var http = $HTTPRequest

@onready var save_email = $SaveEmail
@onready var save_password = $SavePassword
@onready var autosave = AutoSave.new()

const autosave_dir : String = "user://autosave/"
const autosave_path : String = autosave_dir + "autosave.tres"
const main_menu = "res://scenes/main_menu/main_menu.tscn"
const general_error_overlay = "res://scenes/other/general_error_overlay.tscn"

#true if getting player info. false if simply logging in
var fetching_info : bool = false

func _ready():
	#verify save directory and load content
	DirAccess.make_dir_absolute(autosave_dir)
	if(!ResourceLoader.exists(autosave_path)):
		ResourceSaver.save(autosave, autosave_path)
	else:
		autosave = ResourceLoader.load(autosave_path)
		email.text = autosave.email
		password.text = autosave.password
	


#manages http request outcomes
func _on_http_request_request_completed(result, response_code, headers, body):
	if (!fetching_info):
		var json = JSON.new()
		var response_body = json.parse_string(body.get_string_from_utf8())
		if (response_code != 200):
			error_message.text = Firebase.prettier_error_message(response_body.error.message)
		else:
			fetching_info = true
			User.player.get_player_from_email(email.text, http)
	else: #fetching_info == true
		#if change scenes if info retrieved successfully
		match response_code:
			404:
				self.add_child(load(general_error_overlay).instantiate())
			200:
				get_tree().change_scene_to_file(main_menu)
		fetching_info = false

#sends signal to start http request for login
func _on_login_pressed():
	Firebase.login(email.text, password.text, http)


#saves email/password for quick load on future start times
func _on_save_email_pressed():
	autosave.email = email.text
	ResourceSaver.save(autosave, autosave_path)

func _on_save_password_pressed():
	autosave.password = password.text
	ResourceSaver.save(autosave, autosave_path)
