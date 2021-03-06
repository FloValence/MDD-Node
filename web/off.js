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

}).call(this);
