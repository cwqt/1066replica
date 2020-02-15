import ObjectID from "bson-objectid"

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