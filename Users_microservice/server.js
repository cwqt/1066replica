const express 			= require('express');
const bcrypt 				= require('bcrypt');
const ObjectID 			= require("bson-objectid");
const validator 		= require("email-validator");
const MongoClient 	= require('mongodb').MongoClient

const app 					= express();

var db
const MONGO_URI = process.env.MONGO_URI

MongoClient.connect(MONGO_URI, (err, client) => {
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
		var values = this.generatePassword(password);
		this.salt = values[0]
		this.hash = values[1]

		this._id = ObjectID()
		this.isAdmin = false
		this.createdAt = Date.now();
		this.icon = ""
		this.level = 0
		this.exp = 0
		this.winCount = 0
		this.gameCount = 0
		this.token = ""
	}

	generatePassword(password) {
		var salt = bcrypt.genSaltSync(10)
		var hash = bcrypt.hashSync(password, salt)
		return [salt, hash]
	}

	json() {
		return JSON.stringify(this)
	}
}

app.get("/login", (req, res) => {
	var username = req.query.username
	var password = req.query.password

	if (!username) { res.json({"message": "No username provided"}) }
	if (!password) { res.json({"message": "No password provided"}) }

	db.collection("users").findOne({"name":username}, function(err, r) {
		if (r.length >= 1) {
			bcrypt.compareSync(password, r.hash, function(err, same) {
				if (same) {
					res.json({"message": "Logged in!", "data": true})										
				} else {
					res.json({"message": "Incorrect password"})					
				}
			});
		} else {
			res.json({"message": "User not found"})
		}
	})
})


app.get("/users", (req, res) => {
	db.collection("users").find({}).toArray(function(err, r) {
		console.log(r)
		return res.json({"data":r})
	});
})

app.post('/users', (req, res) => {
	var username = req.query.username
	var password = req.query.password
	var email		 = req.query.email

	if (username) {
		if (username.length > 16) {
			return res.json({"message":"Username must be less than 16 characters in length"})			
		}
		if (!username.match(/^[0-9a-zA-Z]+$/)) {
			return res.json({"message":"Alphanumeric characters only"})
		} 
	} else {
		return res.json({"message":"No username provided"})
	}

	if (password) {
		if (password.length > 16) {
			return res.json({"message":"Password must be less than 16 characters in length"})			
		}
	} else {
		return res.json({"message":"No password provided"})
	}

	if (email) {
		if (! validator.validate(email)) {
			return res.json({"message":"Invalid e-mail address"})
		} 
	} else {
		return res.json({"message":"No e-mail address provided"})
	}

	(async () => {
		let doesUserAlreadyExist = new Promise((resolve, reject) => {
			db.collection("users").findOne({"name":username}, function(err, r) {
				if (r != null) {
					return resolve(true);
				}
				return resolve(false);
			})		
		})

		let doesEmailAlreadyExist = new Promise((resolve, reject) => {
			db.collection("users").findOne({"email":email}, function(err, r) {
				if (r != null) {
					return resolve(true);
				}
				return resolve(false);
			})		
		})

		if (await doesUserAlreadyExist) {
			return res.json({"message":"User already exists"});
		}
		if (await doesEmailAlreadyExist) {
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




