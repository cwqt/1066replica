import { MongoClient } 	from "mongodb"

var _db;

module.exports = {
  connectToDatabase: function() {
  	return new Promise((resolve, reject) => {
	    MongoClient.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true }, function( err, client ) {
	  	  if (err) return console.log(err)
	      _db  = client.db('db');
	    	resolve();
	    });
  	})
  },

  getDb: function() {
    return _db;
  },

  findUser: function(username) {
	  return new Promise((resolve, reject) => {
	    _db.collection("users").findOne({"name":username}, function(err, res) {
	    	if (err) { reject(err) }
	      resolve(res);
	    })
	  })  	
  },

 	//functionally same as findUser
  findBlacklistedToken: function(token) {
	  return new Promise((resolve, reject) => {
	    _db.collection("blacklisted_tokens").findOne({"token":token}, function(err, res) {
	    	if (err) { reject(err) }
	      resolve(res);
	    })
	  })  	  	
  }

};