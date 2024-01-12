extends Node

var webApiKey : String = "insert_key"
var projectId : String = "tier-it"
var client_id : String = ""
var client_secret : String = "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"

var loginUrl : String = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="        + webApiKey
var signupUrl  : String = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="                  + webApiKey
var firestoreUrl : String = "https://firestore.googleapis.com/v1/projects/YOUR_PROJECT_ID/databases/(default)/documents/" % client_id

var user_info : Dictionary = {}

var current_token = ""


#takes array of results of http requests from firebase and returns the user info in a dictionary
func get_user_info(result:Array) -> Dictionary:
	var json = JSON.new()
	var dict : Dictionary = {}
	var result_body = json.parse_string(result[3].get_string_from_ascii()) as Dictionary
	return {
		"token" : result_body.idToken,
		"id": result_body.localId
	}

#set of headers: tells server user is authenticated
func get_request_headers() -> PackedStringArray:
	return PackedStringArray([
		"Content-Type: application/json",
		"Authorization: Bearer %s" % user_info.token
	])

#generates a new JSON and makes an HTTP Request to create a new account
func signup(email:String, username:String, password:String, http:HTTPRequest):
	var body = JSON.new().stringify({
		'email' : email,
		'password' : password
		})
	var headers = ['Content-Type: application/json']
	http.request(signupUrl, headers, HTTPClient.METHOD_POST, body)
	var result = await http.request_completed as Array
	if (result[1] == 200): #if register succeeded, store player data to Firestore
		user_info = get_user_info(result)
		var player = Player.new()
		player.color = "#0000ff"
		player.email = email
		player.username = username
		player.publish_info_first(http)



#same process but for logins
func login(email:String, password:String, http:HTTPRequest):
	var body = JSON.new().stringify({
		'email' : email,
		'password' : password,
		'returnSecureToken' : true
		})
	var headers = ['Content-Type: application/json']
	http.request(loginUrl, headers, HTTPClient.METHOD_POST, body)
	var result = await http.request_completed as Array
	if (result[1] == 200):
		user_info = get_user_info(result)

#takes a dictionary and sends an HTTP request to save the document
func save_document(path:String, fields:Dictionary, http:HTTPRequest):
	var document : Dictionary = { "fields" : fields }
	var body = JSON.new().stringify(document)
	var url = firestoreUrl + path
	http.request(url, get_request_headers(), HTTPClient.METHOD_POST, body)

#self-explanitory
func get_document(path:String, http:HTTPRequest):
	var url = firestoreUrl + path
	http.request(url, get_request_headers(), HTTPClient.METHOD_GET)

#document already exists, but fields are updated
func update_document(path:String, fields:Dictionary, http:HTTPRequest):
	var document : Dictionary = { "fields" : fields }
	var body = JSON.new().stringify(document)
	var url = firestoreUrl + path
	http.request(url, get_request_headers(), HTTPClient.METHOD_PATCH, body)

#self-explanitory
func delete_document(path:String, http:HTTPRequest):
	var url = firestoreUrl + path
	http.request(url, get_request_headers(), HTTPClient.METHOD_DELETE)








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
		print(error)
		return "Unknown Error Occurred"
