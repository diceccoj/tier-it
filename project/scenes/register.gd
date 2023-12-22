extends Control

@onready var http = $HTTPRequest
@onready var username = $Username
@onready var email = $Email
@onready var password = $Password
@onready var confirm_password = $ConfirmPassword
@onready var error_message = $ErrorMessage

#manages http requests outcomes
func _on_http_request_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	var response_body = json.parse_string(body.get_string_from_utf8())
	if (response_code != 200):
		error_message.text = Firebase.prettier_error_message(response_body.error.message)
	else:
		error_message.add_theme_color_override("font_color", Color(0x188248ff))
		error_message.text = "Account Registered"


func _on_register_pressed():
	if (password.text != confirm_password.text):
		error_message.text = "Confirmed Password Doesn't Match"
		return
	Firebase.signup(email.text, password.text, http)
