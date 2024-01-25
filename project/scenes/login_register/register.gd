extends Control


@onready var email = $Email
@onready var username = $Username
@onready var password = $Password
@onready var confirm_password = $ConfirmPassword
@onready var error_message = $ErrorMessage




func _ready():
	#connecting success and fail functions
	Firebase.Auth.signup_succeeded.connect(on_signup_succeeded)
	Firebase.Auth.signup_failed.connect(on_signup_failed)



func _on_register_pressed():
	if (len(username.text) > 9):
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "Username must be 9 characters or less"
	elif (password.text != confirm_password.text):
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "The two password fields don't match"
	elif(username.text == ""):
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "Username can't be empty"
	else:
		error_message.add_theme_color_override("font_color", Color(0x909090ff))
		error_message.text = "Creating Account..."
		Firebase.Auth.signup_with_email_and_password(email.text, password.text)


func on_signup_succeeded(auth):
	error_message.text = "Storing Player Data..."
	await create_and_store_data()

	

func on_signup_failed(code, message):
	error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
	error_message.text = Firebase.prettier_error_message(message)

#if localid exists, create and store new player data to firestore
func create_and_store_data():
	var auth = Firebase.Auth.auth
	if (auth.localid):
		var player_dict : Dictionary = {
			"username" : username.text, 
			"in_rooms" : []
		}
		var collection : FirestoreCollection = Firebase.Firestore.collection("players")
		collection.error.connect(general_error)
		collection.add(auth.localid, player_dict)
		
		error_message.add_theme_color_override("font_color", Color(0x29873dff))
		error_message.text = "Account Created!"
	else: #auth.localid doesn't exist
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = "Error getting new player id"

func general_error(code, status, message):
	get_tree().change_scene_to_file("res://scenes/other/fatal_error_scene.tscn")
