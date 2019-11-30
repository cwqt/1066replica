import { Router } from 'express';
const router = Router();

router.get("/:username", (req, res) => {
  var username = req.params.username
  var password = req.query.password
  if (!password) { return res.json({"message": "No password provided"}) }

  //find the user
  db.collection("users").findOne({"name":username}, function(err, r) {
    if (r != null) {
      if (r.isLoggedIn) {
        return res.json({"message":"User already logged in"})
      }

      //verify passwords match
      var isCorrect = bcrypt.compareSync(password, r.hash)
      if (isCorrect) {
        //set logged in status
        db.collection("users").update({"_id":r._id}, {"$set": {"isLoggedIn": true}}, function(e,x) {
          return res.json({"message": "Logged in!", "data": true})
        }) 
      } else {
        return res.json({"message": "Incorrect password"})         
      }
    } else {
      return res.json({"message": "User not found"})
    }
  })
})

export default router;
