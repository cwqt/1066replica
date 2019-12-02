import express 	 				from "express"
import 'dotenv/config';

import routes 	 				from "./routes";
import db								from "./db"

const app = express();

(async () => {
	await db.connectToDatabase()
	app.set('trust proxy', 1);
	app.listen(3000, () => {
	  console.log('\nListening on 3000')
	})
		
	app.use("/auth", 		routes.auth)
	app.use("/users", 	routes.users)
	app.use("/login", 	routes.login)
	app.use("/logout", 	routes.logout)
})();
