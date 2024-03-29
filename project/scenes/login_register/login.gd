extends Control


@onready var email = $Email
@onready var password = $Password
@onready var login = $Login
@onready var error_message = $ErrorMessage

@onready var save_email = $SaveEmail
@onready var save_password = $SavePassword
@onready var autosave = AutoSave.new()

const autosave_dir : String = "user://autosave/"
const autosave_path : String = autosave_dir + "autosave.tres"
const main_menu = "res://scenes/main_menu/main_menu.tscn"

#true if getting player info. false if simply logging in
var fetching_info : bool = false
var server_info : FirestoreCollection

func _ready():
	#verify save directory and load content
	DirAccess.make_dir_absolute(autosave_dir)
	if(!ResourceLoader.exists(autosave_path)):
		ResourceSaver.save(autosave, autosave_path)
	else:
		autosave = ResourceLoader.load(autosave_path)
		email.text = autosave.email
		password.text = autosave.password
	
	#connecting success and fail functions
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)
	
	#checks if user has up to date version
	server_info = Firebase.Firestore.collection("server_info")
	server_info.error.connect(on_login_failed)





#sends signal to start http request for login
func _on_login_pressed():
	error_message.add_theme_color_override("font_color", Color(0x909090ff))
	error_message.text = "Attempting to log in..."
	Firebase.Auth.login_with_email_and_password(email.text, password.text)


#saves email/password for quick load on future start times
func _on_save_email_pressed():
	autosave.email = email.text
	ResourceSaver.save(autosave, autosave_path)

func _on_save_password_pressed():
	autosave.password = password.text
	ResourceSaver.save(autosave, autosave_path)


func on_login_succeeded(auth):
	error_message.text = "Loading..."
	grab_info_for_user()

#changes to main menu if login succeeds AND server version matches up
func grab_info_for_user() -> bool:
	var auth = Firebase.Auth.auth
	if (auth.localid):
		await User.grab_info_from_id(auth.localid)
		var finished_task = await server_info.get_doc("info").task_finished
		var document = await finished_task.document
		if (document.doc_fields.latest_version == Game.version):
			get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
			return true
		else:
			error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
			error_message.text = "Your game is out of date! Please go to the GitHub page and download the latest version!"
			return false
	else:
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "Issue getting player id"
		return false
		




func on_login_failed(code, message):
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	error_message.text =  Firebase.prettier_error_message(message)


