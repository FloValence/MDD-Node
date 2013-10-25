application_root = __dirname
express = require 'express'
http = require 'http'
#db = require 'mongoose'
dbServer = require './routes/dbServer'

doses = dbServer.doses
doseSets = dbServer.doseSets

path = require 'path'
app = express()

###
mongoose = require 'mongoose'
uristring =
	process.env.MONGOLAB_URI ||
	process.env.MONGOHQ_URL ||
	'mongodb://localhost/MDD_db'

theport = process.env.PORT || 5000

mongoose.connect uristring, (err, res)->
  if (err)
    console.log ('ERROR connecting to: ' + uristring + '. ' + err)
  else
    console.log ('Succeeded connected to: ' + uristring)


DoseSet = mongoose.model 'DoseSet', new mongoose.Schema
	title: String
	date: String
	url: String
	all: String
	selected: String
	tags: String
	favorited: Boolean

Dose = mongoose.model 'Dose', new mongoose.Schema
	comments_count: Number
	created_at: String
	did: Number
	height: Number
	image_400_url: String
	image_teaser_url: String
	image_url: String
	likes_count: Number
	player: Object
	rebound_source_id: Number
	rebounds_count: Number
	short_url: String
	title: String
	url: String
	views_count: Number
	width: Number
###

app.configure ->
	#app.use compass()
	app.use express.bodyParser()
	app.use express.methodOverride()
	app.use app.router
	app.use express.static path.join application_root, '../public/'
	app.use express.errorHandler { dumpExceptions: true, showStack: true }
	app.set 'port', process.env.PORT || 3000
	app.set 'views', path.join application_root, '../views'
	app.set 'view engine', 'jade'

jadeConf =
	index:
		globals:
			title: 'My Daily Dose'

app.get '/', (req, res)->
	res.render 'index'#, jadeConf.index

# doseSets route
app.get '/doseSet', doseSets.oneDoseSet
app.get '/api/doseSets', doseSets.findAll
app.get '/api/doseSets/:id', doseSets.findById
app.put '/api/doseSets/:id', doseSets.updateOne
app.post '/api/doseSets', doseSets.addOne
app.delete '/api/doseSets', doseSets.deleteOne

# doses route
app.get '/dose', doses.oneDose
app.get '/api/doses', doses.findAll
app.get '/api/doses/:id', doses.findById
app.put '/api/doses/:id', doses.updateOne
app.post '/api/doses', doses.addOne
app.delete '/api/doses', doses.deleteOne

###
app.get '/doseSet', (req, res)->
	res.send('One DoseSet')

app.get '/api/doseSets', (req, res)->
	DoseSet.find (err, doseSets)->
		res.send doseSets

app.get '/api/doseSets/:id', (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		if (!err)
			res.send doseSet

app.put '/api/doseSets/:id', (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		doseSet.title = req.body.title
		doseSet.all = req.body.all
		doseSet.favorited = req.body.favorited
		doseSet.save (err)->
			if !err
				console.log "updated doseSet"
			res.send doseSet


app.post '/api/doseSets', (req, res)->
	doseSet = new DoseSet {
		title: req.body.title
		all: req.body.all
		favorited: req.body.favorited
	}
	doseSet.save (err)->
		if !err
			console.log "created doseSet"
		res.send doseSet


app.delete '/api/doseSets/:id', (req, res)->
	DoseSet.findById req.params.id, (err, doseSet)->
		doseSet.remove (err)->
			if !err
				console.log "removed doseSet"
				res.send ''

# doses
app.get '/dose', (req, res)->
	res.send('One Dose')

app.get '/api/doses', (req, res)->
	Dose.find (err, doses)->
		res.send doses

app.get '/api/doses/:id', (req, res)->
	Dose.findById req.params.id, (err, dose)->
		if !err
			res.send dose
		else
			console.log err

app.put '/api/doses/:id', (req, res)->
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

app.post '/api/doses', (req, res)->
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



app.delete '/api/doses/:id', (req, res)->
	Dose.findById req.params.id, (err, dose)->
		dose.remove (err)->
			if !err
				console.log "removed dose"
				res.send ''
###
#

app.get '/todo', (req, res)->
	res.render 'todo', {title: "MongoDB Backed TODO App"}

app.get '/api/todos', (req, res)->
	Todo.find (err, todos)->
		res.send todos


app.get '/api/todos/:id', (req, res)->
	Todo.findById req.params.id, (err, todo)->
		if (!err)
			res.send todo

app.put '/api/todos/:id', (req, res)->
	Todo.findById req.params.id, (err, todo)->
		todo.text = req.body.text
		todo.done = req.body.done
		todo.order = req.body.order
		todo.save (err)->
			if !err
				console.log "updated"
			res.send(todo)

app.post '/api/todos', (req, res)->
	todo
	todo = new Todo {
		text: req.body.text
		done: req.body.done
		order: req.body.order
	}
	todo.save (err)->
		if !err
			console.log "created"
	res.send todo


app.delete '/api/todos/:id', (req, res)->
	Todo.findById req.params.id, (err, todo)->
		todo.remove (err)->
			if !err
				console.log "removed"
				res.send ''

###

###

http.createServer(app).listen(app.get('port'), ->
    console.log "Express server listening on port " + app.get 'port'
)
#app.listen 3000
