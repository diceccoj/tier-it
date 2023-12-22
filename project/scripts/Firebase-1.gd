extends Node

var webApiKey : String = "insert_key"
var loginUrl : String = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + webApiKey
var signupUrl  : String = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="           + webApiKey


var current_token = ""


#generates a new JSON and makes an HTTP Request to create a new account
func signup(email:String, password:String, http:HTTPRequest):
	var body = JSON.new().stringify({'email' : email, 'password' : password})
	var headers = ['Content-Type: application/json']
	http.request(signupUrl, headers, HTTPClient.METHOD_POST, body)
	var result = await http.request_completed as Array
	if (result[1] == 200):
		pass #will focus on this later


#same process but for logins
func login(email:String, password:String, http:HTTPRequest):
	var body = JSON.new().stringify({'email' : email, 'password' : password})
	var headers = ['Content-Type: application/json']
	http.request(loginUrl, headers, HTTPClient.METHOD_POST, body)
	var result = await http.request_completed as Array
	if (result[1] == 200):
		pass #will focus on this later



#MAKING ERROR MESSAGES PRETTIER
func prettier_error_message(error:String) -> String:
	if (error == "INVALID_EMAIL"):
		return "Invalid Email. Try again!"
	elif (error == "MISSING_PASSWORD"):
		return "Please fill in Password."
	elif (error == "INVALID_LOGIN_CREDENTIALS"):
		return "Wrong Password or Account Does Not Exist"
	elif (error == "WEAK_PASSWORD : Password should be at least 6 characters"):
		return "Password Must Be At Least 6 Characters"
	elif (error == "EMAIL_EXISTS"):
		return "Account Already Exists For This Email"
	elif (error == "TOO_MANY_ATTEMPTS_TRY_LATER : Access to this account has been temporarily disabled due to many failed login attempts. You can immediately restore it by resetting your password or you can try again later."): #wow
		return "Account Temporarily Disabled. Too Many Requests Sent"
	else:
		return error
