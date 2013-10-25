models = require './models'

User = models.User

exports.oneUser = (req, res)->
	res.send 'One User'

exports.findAll = (req, res)->
	User.find (err, users)->
		res.send users

exports.findById = (req, res)->
	User.findById req.params.id, (err, user)->
		if !err
			res.send user

exports.updateOne = (req, res)->
	User.findById req.params.id, (err, user)->
		user.name = req.body.name
		user.email = req.body.email
		user.dosesets = req.body.dosesets
		user.active = req.body.active
		user.save (err)->
			if !err
				console.log "updated user"
			res.send user


exports.addOne = (req, res)->
	user = new User
		name: req.body.name
		email: req.body.email
		dosesets: req.body.dosesets
		active: req.body.active
	user.save (err)->
		if !err
			console.log "created user"
		res.send user


exports.deleteOne = (req, res)->
	User.findById req.params.id, (err, user)->
		user.remove (err)->
			if !err
				console.log "removed user"
				res.send ''

