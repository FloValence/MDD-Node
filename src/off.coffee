application_root = __dirname
express = require 'express'
http = require 'http'
#db = require 'mongoose'
dbServer = require './routes/dbServer'

doses = dbServer.doses
doseSets = dbServer.doseSets

path = require 'path'
app = express()

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
			heu: 'ok'
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		