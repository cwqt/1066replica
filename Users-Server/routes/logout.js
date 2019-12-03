import { Router } from 'express';
import db         from "../db"

const router = Router();

//user could potentially create several tokens
//this would only blacklist sent token
//we should assume the client overrwrites its local tokens
//so other generated tokens are thrown away...
router.get('/:username', async (req, res) => {
  var username = req.params.username
  var token    = req.headers["x-access-token"]
  if (!token)    { return res.json({"message": "No token provided"}) }

  //find the user
  var user = await db.findUser(username)
  if (user == null) { res.json({"message":"User does not exist"}) }

  //blacklist the token
  var _db = db.getDb()
  _db.collection("blacklisted_tokens").insertOne({"token":token}, function(err, r) {
    //set user status to logged out
    _db.collection("users").update({"_id":user._id}, {"$set": {"isLoggedIn": false}}, function(err, r) {
      return res.json({"message": "Logged out", "data": true})
    }) 
  })
})

export default router;
