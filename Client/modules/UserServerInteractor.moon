requests = require('libs.requests')

USI = {}
USI._URL = "http://localhost:3000/users"
USI.token = "" 

USI.login = (username, password) ->
  res = requests.get(USI._URL.."?page_size=50&page_number=1")
  print(inspect(res))
  print(inspect(res.json()))


print(body)


USI.logout = () ->

USI.getToken = () ->

return USI