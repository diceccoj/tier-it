extends Control

@onready var create_account = $CreateAccount
@onready var create_account_info = $CreateAccountInfo


@onready var email = $Email
@onready var username = $Username
@onready var password = $Password
@onready var confirm_password = $ConfirmPassword
@onready var error_message = $ErrorMessage

const general_error_overlay = "res://scenes/other/general_error_overlay.tscn"

var player : Player

var storing_data = false

#manages outcomes when creating account
func _on_create_account_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var response_body = json.parse_string(body.get_string_from_utf8())
	if (response_code != 200):
		error_message.add_theme_color_override("font_color", Color(0xaf0700ff))
		error_message.text = Firebase.prettier_error_message(response_body.error.message)
	elif (!storing_data): #upload user info to firestore database
		error_message.add_theme_color_override("font_color", Color(0x909090ff))
		error_message.text = "Storing Player Data..."
		storing_data = true
	else: #triggers when account has successfully been fully set up
		error_message.add_theme_color_override("font_color", Color(0x188248ff))
		error_message.text = "Account Registered"
		storing_data = false


#manages outcomes when trying to create account info (always comes after create_account)



func _on_register_pressed():
	if (password.text != confirm_password.text):
		error_message.text = "Confirmed Password Doesn't Match"
		return
	elif (len(username.text) > 9):
		error_message.text = "Username Can't be more than 9 characters"
		return
	Firebase.signup(email.text, username.text, password.text, create_account)

