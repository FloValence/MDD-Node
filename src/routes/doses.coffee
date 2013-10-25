models = require './models'

Dose = models.Dose

# doses
exports.oneDose = (req, res)->
	res.send 'One Dose'

exports.findAll = (req, res)->
	Dose.find (err, doses)->
		res.send doses

exports.findById =  (req, res)->
	Dose.findById req.params.id, (err, dose)->
		if !err
			res.send dose
		else
			console.log err

exports.updateOne = (req, res)->
	Dose.findById req.params.id, (err, dose)->
		dose.title = req.body.title
		dose.comments_count = req.body.comments_count
		dose.created_at = req.body.created_at
		dose.did = req.body.did
		dose.height = req.body.height
		dose.image_400_url = req.body.image_400_url
		dose.image_teaser_url = req.body.image_teaser_url
		dose.image_url = req.body.image_url
		dose.likes_count = req.body.likes_count
		dose.player = req.body.player
		dose.rebound_source_id = req.body.rebound_source_id
		dose.rebounds_count = req.body.rebounds_count
		dose.short_url = req.body.short_url
		dose.url = req.body.url
		dose.views_count = req.body.views_count
		dose.width = req.body.width
		dose.save (err)->
			if !err
				console.log "updated dose"
			else
				console.log err
			res.send dose

exports.addOne = (req, res)->
	console.log 'essaie de post'
	dose = new Dose {
		title: req.body.title
		comments_count: req.body.comments_count
		created_at: req.body.created_at
		did: req.body.did
		height: req.body.height
		image_400_url: req.body.image_400_url
		image_teaser_url: req.body.image_teaser_url
		image_url: req.body.image_url
		likes_count: req.body.likes_count
		player: req.body.player
		rebound_source_id: req.body.rebound_source_id
		rebounds_count: req.body.rebounds_count
		short_url: req.body.short_url
		url: req.body.url
		views_count: req.body.views_count
		width: req.body.width
	}
	dose.save (err)->
		if !err
			console.log "created dose"
		else
			console.log err
	res.send dose

exports.deleteOne = (req, res)->
	Dose.findById req.params.id, (err, dose)->
		dose.remove (err)->
			if !err
				console.log "removed dose"
				res.send ''
