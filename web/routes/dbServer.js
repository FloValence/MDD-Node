// Generated by CoffeeScript 1.6.3
/*mongo = require 'mongodb'
dbhost = 'localhost'
dbport = mongo.Connection.DEFAULT_PORT
db = new mongo.Db 'MDD-Mongo', new mongo.Server dbhost, dbport, {}
#dosSetCollection = ''
db.open (error, db)->
	console.log 'Connected to mongo: ' + dbhost + ':' + dbport

#	db.collection 'doseSets', (error, collection)->
#		dosSetCollection = collection
*/


(function() {
  var mongoose, theport, uristring;

  mongoose = require('mongoose');

  exports.doses = require('./doses');

  exports.doseSets = require('./doseSets');

  uristring = process.env.MONGOLAB_URI || process.env.MONGOHQ_URL || 'mongodb://localhost/MDD_db';

  theport = process.env.PORT || 5000;

  mongoose.connect(uristring, function(err, res) {
    if (err) {
      return console.log('ERROR connecting to: ' + uristring + '. ' + err);
    } else {
      return console.log('Succeeded connected to: ' + uristring);
    }
  });

}).call(this);
