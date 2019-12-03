requests = require('libs.requests')

USI = {}
USI._URL = "http://localhost:3000"
USI.token = nil 
USI.user = nil

USI.getUser = (username) ->
	res = requests.get(USI._URL .. "/users/#{username}")
	USI.user = res.json()

USI.login = (username, password) ->
	res = requests.get(USI._URL .. "/login/#{username}?password=#{password}")
	res = res.json()
	if res.data == true
		USI.generateTokenForUser(username)
	return res.data or false, res.message or ""

USI.generateTokenForUser = (username) ->
	res = requests.post(USI._URL .. "/auth/#{username}")
	res = res.json()
	if res.data then
		USI.token = res.data
		return USI.token

USI.logout = (username) ->
	headers = {['x-access-token']: USI.token}
	res = requests.get({USI._URL .. "/logout/#{username}", headers:headers})

USI.getToken = () ->
	return USI.token

return USI