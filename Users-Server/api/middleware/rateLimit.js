import rateLimit from "express-rate-limit"

const limiter = rateLimit({
	windowMs: 15 * 60 * 1000, // 15 minutes
	max: 99, // limit each IP to 5 requests per windowMs
	message: {"message":"Too many requests, try later"},
	handler: function (req, res, next) {
    res.status(this.statusCode).send(this.message);
    next();
	}
})

module.exports = limiter