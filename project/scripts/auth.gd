extends Node

var webApiKey : String = "insert_here"
var loginUrl : String = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + webApiKey
var signupUrl  : String = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="           + webApiKey
var action : int = 0 #0 - nothing, 1 - login, 2 - register


#login and signup
func _loginSignup(url:String, email:String, password:String):
	var http = $HTTPRequest
	var jsonObject = JSON.new()
	var body = jsonObject.stringify({'email' : email, 'password' : password})
	var headers = ['Content-Type: application/json']
	
	var error = await http.request(url, headers,  HTTPClient.METHOD_POST, body)


#seeing if http request is completed
func _on_http_request_request_completed(result, response_code, headers, body):
	
	var response = JSON.parse_string(body.get_string_from_utf8())
	#login successful
	if (response_code == 200):
		if (action == 1):
			get_tree().change_scene_to_file("res://scenes/tier_list.tscn")
		else:
			$ErrorMessage.set("theme_override_colors/font_color", Color(0x006f3aff))
			$ErrorMessage.text = "Account Created!"
	else: #any error
		print(response.error.message)
		error_passthrough($ErrorMessage, response.error.message)
	action = 0



#Login Button (In Login Scene)
func _on_login_pressed():
	var email = $Email.text
	var password = $Password.text
	action = 1
	_loginSignup(loginUrl, email, password)



#Register Button (In Register Scene)
func _on_register_pressed():
	if($Password.text == $ConfirmPassword.text):
		var email = $Email.text
		var password = $Password.text
		action = 2
		_loginSignup(signupUrl, email, password)
	else:
		$ErrorMessage.text = "Confirmed Password Doesn't Match!"






#MAKING ERROR MESSAGES PRETTIER
func error_passthrough(label:Label, error:String):
	var new_error_message : String = ""
	
	if (error == "INVALID_EMAIL"):
		new_error_message = "Invalid Email. Try again!"
	elif (error == "MISSING_PASSWORD"):
		new_error_message = "Please fill in Password."
	elif (error == "INVALID_LOGIN_CREDENTIALS"):
		new_error_message = "Wrong Password or Account Does Not Exist"
	elif (error == "TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."): #wow
		new_error_message = "Account Temporarily Disabled. Too Many Requests Sent"
	elif (error == "WEAK_PASSWORD : Password should be at least 6 characters"): #wow
		new_error_message = "Password Must Be At Least 6 Characters"
	elif (error == "EMAIL_EXISTS"): #wow
		new_error_message = "Account Already Exists For This Email"
	else:
		new_error_message = error
	label.text = new_error_message



