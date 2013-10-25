###mongo = require 'mongodb'
dbhost = 'localhost'
dbport = mongo.Connection.DEFAULT_PORT
db = new mongo.Db 'MDD-Mongo', new mongo.Server dbhost, dbport, {}
#dosSetCollection = ''
db.open (error, db)->
	console.log 'Connected to mongo: ' + dbhost + ':' + dbport

#	db.collection 'doseSets', (error, collection)->
#		dosSetCollection = collection
###



mongoose = require 'mongoose'
exports.doses = require './doses'
exports.doseSets = require './doseSets'
exports.users = require './users'


uristring =
	process.env.MONGOLAB_URI ||
	process.env.MONGOHQ_URL ||
	'mongodb://localhost/MDD_db'

theport = process.env.PORT || 5000

#mongoose.connect 'mongodb://localhost/MDD_db'

mongoose.connect uristring, (err, res)->
  if (err)
    console.log ('ERROR connecting to: ' + uristring + '. ' + err)
  else
    console.log ('Succeeded connected to: ' + uristring)


#mongoose.connection.on 'error', (err)->

#  console.log 'Mongoose default connection error: ' + err




