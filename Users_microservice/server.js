const express       = require('express');
const bcrypt        = require('bcrypt');
const ObjectID      = require("bson-objectid");
const validator     = require("email-validator");
const jwt           = require('jsonwebtoken');
const MongoClient   = require('mongodb').MongoClient;
                      require('dotenv').config();

const app           = express();
var db

MongoClient.connect(process.env.MONGO_URI, (err, client) => {
  if (err) return console.log(err)
  db = client.db('db')
  app.listen(3000, () => {
    console.log('\nListening on 3000')
  })
})

class User {
  constructor(name, password, email) {
    this.name = name
    this.email = email
    this.salt = bcrypt.genSaltSync(10)
    this.hash = bcrypt.hashSync(password, self.salt)
    this._id = ObjectID()
    this.isAdmin = false
    this.createdAt = Date.now();
    this.icon = ""
    this.level = 0
    this.exp = 0
    this.winCount = 0
    this.gameCount = 0
  }

  json() {
    return JSON.stringify(this)
  }
}

//generate token
app.post("/auth/:username", (req, res) => {
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
app.get("/auth/:username", (req, res) => {
  username = req.params.username
  token = req.headers["x-access-token"]
  if (!token) { res.json({"message": "No token provided"}) }

  //check if token is for this user
  var tokenIsForUser = jwt.decode(token, process.env.PRIVATE_KEY).data == username ? true : false
  if (!tokenIsForUser) {
    res.json({"message": "Invalid token for this user"})
  }

  //check if token is valid
  db.collection("users").findOne({"name": username}, function(err, r) {
    if (r != null) {
      var tokenIsValid = jwt.verify(token, process.env.PRIVATE_KEY);

      if (tokenIsValid) {
        // check if token is blacklisted
        db.collection("blacklisted_tokens").findOne({"token": token}, function(err, r) {
          if (r == null) {
            res.json({"message": "Valid token", "data": true})
          } else {
            res.json({"message":"Black-listed token"})
          }
        })
      } else {
        res.json({"message": "Invalid token"})
      }
    } else {
      res.json({"message": "User not found"})
    }
  })
})


//user could potentially create several tokens
//this would only blacklist sent token
//we should assume the client overrwrites its local tokens
//so other generated tokens are thrown away...
app.get('/logout/:username', (req, res) => {
  var username = req.params.username
  var password = req.headers["x-access-token"]
  if (!token)    { res.json({"message": "No token provided"}) }

  //find the user
  db.collection("users").findOne({"name":username}, function(err, r) {
    var user = r
    if (user == null) { res.json({"message":"User does not exist"}) }
    //blacklist the token
    db.collection("blacklisted_tokens").insertOne({"token":token}, function(err, r) {
      //set user status to logged out
      db.collection("users").update({"_id":user._id}, {"$set": {"isLoggedIn": false}}, function(err, r) {
        res.json({"message": "Logged out", "data": true})
      }) 
    })
  })
})

app.get("/login/:username", (req, res) => {
  var username = req.query.username
  var password = req.query.password
  if (!password) { res.json({"message": "No password provided"}) }

  //find the user
  db.collection("users").findOne({"name":username}, function(err, r) {
    if (r != null) {
      //verify passwords match
      var isCorrect = bcrypt.compareSync(password, r.hash)
      if (isCorrect) {
        //set logged in status
        db.collection("users").update({"_id":r._id}, {"$set": {"isLoggedIn": true}}, function(e,x) {
          res.json({"message": "Logged in!", "data": true})
        }) 
      } else {
        res.json({"message": "Incorrect password"})         
      }
    } else {
      res.json({"message": "User not found"})
    }
  })
})

app.get("/users", (req, res) => {
  var page_size = Number(req.query.page_size)
  var page_num  = Number(req.query.page_number)

  if (!page_size) { res.json({"message": "No page_size provided"}) }
  if (!page_num)  { res.json({"message": "No page_number provided"}) }
  if (page_size > 50) {
    res.json({"message":"Max 50 items per page"})
  }

  var skips = page_size * (page_num - 1)

  db.collection("users")
    .find({})
    .skip(skips)
    .limit(page_size)
    .toArray(function(err, r) {
      return res.json({"data":r})
    }
  );
})

app.get("/users/:username", (req, res) => {
  var username = req.params.username
  if (!username) { res.json({"message": "No username provided"}) }

  db.collection("users").findOne({"name":username}, function(err, r) {
    if (r !== null) {
      res.json({"data":r})
    } else {
      res.json({"message":"User not found"})
    }
  })
})


app.post('/users/:username', (req, res) => {
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
    let doesUserAlreadyExist = new Promise((resolve, reject) => {
      db.collection("users").findOne({"name":username}, function(err, r) {
        if (r != null) {
          return resolve(false);
        }
        return resolve(true);
      })    
    })

    let doesEmailAlreadyExist = new Promise((resolve, reject) => {
      db.collection("users").findOne({"email":email}, function(err, r) {
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

    db.collection('users').insertOne(user, function(err, r) {
      if (r.insertedCount == 1) {
        return res.status(200).json({"message":"User created!", "data": user._id})
      } 
      return res.json({"message":"User not created"})
    })
  })();
})

