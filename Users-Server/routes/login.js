import { Router } from 'express';
const router = Router();

router.get("/:username", async (req, res) => {
  var username = req.params.username
  var password = req.query.password
  if (!password) { return res.json({"message": "No password provided"}) }

  //see if user exists
  var user = await db.findUser(username)
  if (user == null) { return res.json({"message": "User not found"}) }  

  //check if already logged in
  if (user.isLoggedIn) { return res.json({"message":"User already logged in"})}

  //Check password against hash
  var isCorrect = bcrypt.compareSync(password, user.hash)
  if (!isCorrect) {return res.json({"message":"Incorrect password"})}

  //Log the user in
  db.collection("users").update({"_id": user._id}, {"$set": {"isLoggedIn": true}}, function(err, r) {
    return res.json({"message": "Logged in!", "data": true})      
  })
})

export default router;
