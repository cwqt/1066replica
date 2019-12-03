requests = require('libs.requests')

USI = {}
USI._URL = "http://localhost:3000"
USI.token = nil 
USI.user = nil

USI.getUser = (username) ->
	res = requests.get(USI._URL .. "/users/#{username}")
	return res.json()

USI.setUser = (user) ->
	log.usi("Set user:\n#{inspect(user)}")
	USI.user = user

USI.login = (username, password) ->
	res = requests.get(USI._URL .. "/login/#{username}?password=#{password}")
	res = res.json()
	if res.data == true
		USI.generateTokenForUser(username)
		USI.setUser(USI.getUser(username))
	return res.data or false, res.message or ""

USI.generateTokenForUser = (username) ->
	res = requests.post(USI._URL .. "/auth/#{username}")
	res = res.json()
	if res.data then
		log.usi("Got token: #{res.data}")
		USI.token = res.data
		return USI.token

USI.logout = (username) ->
	if USI.user
		headers = {['x-access-token']: USI.token}
		res = requests.get({USI._URL .. "/logout/#{username}", headers:headers})
		res = res.json()
		if res.data
			USI.user = nil
			log.usi("Logged out #{username}")
		return res.data or false, res.message or ""

USI.getToken = () ->
	return USI.token

return USI