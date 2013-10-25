application_root = __dirname
express = require 'express'
http = require 'http'
dbServer = require './routes/dbServer'

doses = dbServer.doses
doseSets = dbServer.doseSets
users = dbServer.users

path = require 'path'
app = express()

app.configure ->
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
			heu: 'ok'

app.get '/', (req, res)->
	res.render 'index', jadeConf.index

# doseSets route
app.get '/doseSet', doseSets.oneDoseSet
app.get '/api/doseSets', doseSets.findAll
app.get '/api/doseSets/:id', doseSets.findById
app.put '/api/doseSets/:id', doseSets.updateOne
app.post '/api/doseSets', doseSets.addOne
app.delete('/api/doseSets', doseSets.deleteOne)

# doses route
app.get '/dose', doses.oneDose
app.get '/api/doses', doses.findAll
app.get '/api/doses/:id', doses.findById
app.put '/api/doses/:id', doses.updateOne
app.post '/api/doses', doses.addOne
app.delete('/api/doses', doses.deleteOne)

# users route
app.get '/user', users.oneUser
app.get '/api/users', users.findAll
app.get '/api/users/:id', users.findById
app.put '/api/users/:id', users.updateOne
app.post '/api/users', users.addOne
app.delete('/api/users', users.deleteOne)

http.createServer(app).listen(app.get('port'), ->
	console.log "Express server listening on port " + app.get 'port'
)
