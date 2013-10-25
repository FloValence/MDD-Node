models = require './models'

DoseSet = models.DoseSet

exports.oneDoseSet = (req, res)->
	res.send 'One DoseSet'

exports.findAll = (req, res)->
	DoseSet.find (err, doseSets)->
		res.send doseSets

exports.findById = (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		if !err
			res.send doseSet

exports.updateOne = (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		doseSet.title = req.body.title
		doseSet.all = req.body.all
		doseSet.favorited = req.body.favorited
		doseSet.save (err)->
			if !err
				console.log "updated doseSet"
			res.send doseSet


exports.addOne = (req, res)->
	doseSet = new DoseSet
		title: req.body.title
		all: req.body.all
		favorited: req.body.favorited
	doseSet.save (err)->
		if !err
			console.log "created doseSet"
		res.send doseSet


exports.deleteOne = (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		doseSet.remove (err)->
			if !err
				console.log "removed doseSet"
				res.send ''

