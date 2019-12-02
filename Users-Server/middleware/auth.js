import jwt  from "jsonwebtoken"
import db   from "../db"

// middleware/wrap.js
module.exports = async (req, res, next) => {
  var token = req.headers["x-access-token"]
  var username = req.params.username
  if (!token) { return res.json({"message": "No token provided"}) }

  // see if user exists
  var user = await db.findUser(username)
  if (user == null) { return res.json({"message": "User not found"})}

  // if admin, let them do whatever the hell they want
  if (user.isAdmin) { next(); }

  //check if token is even valid
  var tokenIsValid
  try {
    tokenIsValid = jwt.verify(token, process.env.PRIVATE_KEY);
  } catch(err) {
    return res.json({"message": err.message})
  }
  if (!tokenIsValid) { return res.json({"message":"Token is invalid"}) } 
  
  //check if token is blacklisted
  var tokenIsBlacklisted = await db.findBlacklistedToken(token)
  if (tokenIsBlacklisted) { return res.json({"message":"Token is blacklisted"}) } 
  
  //check if provided token is for this user
  var tokenIsForUser = jwt.decode(token, process.env.PRIVATE_KEY).data == username ? true : false
  if (!tokenIsForUser) { return res.json({"message": "Invalid token for this user"}) }

  //if all checks passed, pass onto route execution since authorised
	next();
};