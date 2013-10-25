// Generated by CoffeeScript 1.6.3
(function() {
  var app, application_root, dbServer, doseSets, doses, express, http, jadeConf, path;

  application_root = __dirname;

  express = require('express');

  http = require('http');

  dbServer = require('./routes/dbServer');

  doses = dbServer.doses;

  doseSets = dbServer.doseSets;

  path = require('path');

  app = express();

  app.configure(function() {
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express["static"](path.join(application_root, '../public/')));
    app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
    app.set('port', process.env.PORT || 3000);
    app.set('views', path.join(application_root, '../views'));
    return app.set('view engine', 'jade');
  });

  jadeConf = {
    index: {
      globals: {
        title: 'My Daily Dose',
        heu: 'ok'
      }
    }
  };

  app.get('/', function(req, res) {
    return res.render('index', jadeConf.index);
  });

  app.get('/doseSet', doseSets.oneDoseSet);

  app.get('/api/doseSets', doseSets.findAll);

  app.get('/api/doseSets/:id', doseSets.findById);

  app.put('/api/doseSets/:id', doseSets.updateOne);

  app.post('/api/doseSets', doseSets.addOne);

  app["delete"]('/api/doseSets', doseSets.deleteOne);

  app.get('/dose', doses.oneDose);

  app.get('/api/doses', doses.findAll);

  app.get('/api/doses/:id', doses.findById);

  app.put('/api/doses/:id', doses.updateOne);

  app.post('/api/doses', doses.addOne);

  app["delete"]('/api/doses', doses.deleteOne);

  http.createServer(app).listen(app.get('port'), function() {
    return console.log("Express server listening on port " + app.get('port'));
  });

}).call(this);