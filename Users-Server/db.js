import { MongoClient } 	from "mongodb"

var _db;

module.exports = {
  connectToDatabase: function() {
  	return new Promise((resolve, reject) => {
	    MongoClient.connect(process.env.MONGO_URI,  { useNewUrlParser: true }, function( err, client ) {
	  	  if (err) return console.log(err)
	      _db  = client.db('db');
	    	resolve()
	    });
  	})
  },

  getDb: function() {
    return _db;
  }
};