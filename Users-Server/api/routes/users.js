import validator  from "email-validator"
import { Router } from 'express'

import db         from "../db"
import User       from "../models/User"

import requiresToken  from "../middleware/auth"
import rateLimit      from "../middleware/rateLimit"

const router = Router();

router.get("/", (req, res) => {
  var page_size = Number(req.query.page_size) || 50
  var page_num  = Number(req.query.page_number) || 1

  if (page_size > 50) {
    return res.json({"message":"Max 50 items per page"})
  }

  var skips = page_size * (page_num - 1)

  db.getDb().collection("users")
    .find({})
    .skip(skips)
    .limit(page_size)
    .toArray(function(err, r) {
      return res.json({"data":r})
    }
  );
})

router.get("/:username", async (req, res) => {
  var username = req.params.username
  if (!username) { res.json({"message": "No username provided"}) }
  
  var user = await db.findUser(username);
  if (user != null) {
    return res.json({"data":user})
  } else {
    return res.json({"message":"User not found"})
  }
})

router.post("/:username", rateLimit, (req, res) => {
  var username = req.params.username
  var password = req.query.password
  var email    = req.query.email

  if (username.length > 16) {
    return res.json({"message":"Username must be less than 16 characters in length"})     
  }
  if (!username.match(/^[0-9a-zA-Z]+$/)) {
    return res.json({"message":"Alphanumeric characters only"})
  } 

  if (password) {
    if (password.length > 16) {
      return res.json({"message":"Password must be less than 16 characters in length"})     
    }
  } else {
    return res.json({"message":"No password provided"})
  }

  if (email) {
    if (!validator.validate(email)) {
      return res.json({"message":"Invalid e-mail address"})
    } 
  } else {
    return res.json({"message":"No e-mail address provided"})
  }

  (async () => {
    _db = db.getDb()

    let doesUserAlreadyExist = new Promise((resolve, reject) => {
      _db.collection("users").findOne({"name":username}, function(err, r) {
        if (r != null) {
          return resolve(false);
        }
        return resolve(true);
      })    
    })

    let doesEmailAlreadyExist = new Promise((resolve, reject) => {
      _db.collection("users").findOne({"email":email}, function(err, r) {
        if (r != null) {
          return resolve(false);
        }
        return resolve(true);
      })    
    })

    if (await doesUserAlreadyExist == false) {
      return res.json({"message":"User already exists"});
    }
    if (await doesEmailAlreadyExist == false) {
      return res.json({"message":"E-mail address already exists"})
    }

    user = new User(username, password, email)

    _db.collection('users').insertOne(user, function(err, r) {
      if (r.insertedCount == 1) {
        return res.status(200).json({"message":"User created!", "data": user._id})
      } 
      return res.json({"message":"User not created"})
    })
  })();
})

router.put("/:username", rateLimit, requiresToken, (req, res) => {

})

export default router;
