import bcrypt     from "bcrypt"
import jwt        from "jsonwebtoken"

import { Router } from 'express';
import db         from "../db"
const router = Router();

//generate token
router.post("/:username", async (req, res) => {
  var username = req.params.username
  
  //see if user exists
  var user = await db.findUser(username)
  if (user == null) {
    return res.json({"message":"User not found"})
  }

  //encoded with username such that token can used on this user
  var token = jwt.sign({
    data: username,
    exp: Math.floor(Date.now() / 1000) + (3600*24), //1 day
  }, process.env.PRIVATE_KEY);

  return res.json({"data": token})
})

//token validation
router.get("/:username", async (req, res) => {
  var username = req.params.username

  // see if user exists
  var user = await db.findUser(username)
  if (user == null) { return res.json({"message": "User not found"})}

  var token = req.headers["x-access-token"]
  if (!token) { return res.json({"message": "No token provided"}) }

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

  //if all checks passed, token is valid!
  return res.json({"data":true})
})

export default router;
