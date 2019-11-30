import bcrypt     from "bcrypt"
import jwt        from "jsonwebtoken"

import { Router } from 'express';
const router = Router();

//generate token
router.post("/:username", (req, res) => {
  username = req.params.username

  //see if user exists
  db.collection("users").findOne({"name": username}, function(err, r) {
    if (r !== null) {
      //encoded with username such that token can used on this user
      var token = jwt.sign({
        data: username,
        exp: Math.floor(Date.now() / 1000) + (3600*24), //1 day
      }, process.env.PRIVATE_KEY);

      return res.json({"data": token})
    } else {
      return res.json({"message": "User not found"})
    }
  })
})

//token validation
router.get("/:username", (req, res) => {
  username = req.params.username
  token = req.headers["x-access-token"]
  if (!token) { return res.json({"message": "No token provided"}) }

  //check if token is for this user
  var tokenIsForUser = jwt.decode(token, process.env.PRIVATE_KEY).data == username ? true : false
  if (!tokenIsForUser) {
    return res.json({"message": "Invalid token for this user"})
  }

  //check if token is valid
  db.collection("users").findOne({"name": username}, function(err, r) {
    if (r != null) {
      var tokenIsValid = jwt.verify(token, process.env.PRIVATE_KEY);

      if (tokenIsValid) {
        // check if token is blacklisted
        db.collection("blacklisted_tokens").findOne({"token": token}, function(err, r) {
          if (r == null) {
            return res.json({"message": "Valid token", "data": true})
          } else {
            return res.json({"message":"Black-listed token"})
          }
        })
      } else {
        return res.json({"message": "Invalid token"})
      }
    } else {
      return res.json({"message": "User not found"})
    }
  })
})

export default router;
