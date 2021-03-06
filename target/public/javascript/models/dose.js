// Generated by CoffeeScript 1.6.3
(function() {
  var _ref, _ref1, _ref2, _ref3,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  MDD.Models.Dose = (function(_super) {
    __extends(Dose, _super);

    function Dose() {
      _ref = Dose.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Dose.prototype.idAttribute = "_id";

    Dose.prototype.urlRoot = '/api/doses';

    return Dose;

  })(Backbone.Model);

  MDD.Models.DoseSet = (function(_super) {
    __extends(DoseSet, _super);

    function DoseSet() {
      _ref1 = DoseSet.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    DoseSet.prototype.idAttribute = "_id";

    DoseSet.prototype.urlRoot = '/api/doseSets';

    DoseSet.prototype.defaults = {
      title: 'UnTitled',
      date: '635644800000',
      url: 'florian.valence.free.fr/MDD',
      all: [],
      selected: [],
      tags: [],
      favorited: false
    };

    DoseSet.prototype.initialize = function() {};

    return DoseSet;

  })(Backbone.Model);

  MDD.Collections.Doses = (function(_super) {
    __extends(Doses, _super);

    function Doses() {
      _ref2 = Doses.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    Doses.prototype.model = MDD.Models.Dose;

    Doses.prototype.base = "http://api.dribbble.com/shots/everyone?page=";

    Doses.prototype.url = '/api/doses';

    Doses.prototype.parse = function(resp, xhr) {
      return resp.shots;
    };

    return Doses;

  })(Backbone.Collection);

  MDD.Collections.DoseSets = (function(_super) {
    __extends(DoseSets, _super);

    function DoseSets() {
      _ref3 = DoseSets.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    DoseSets.prototype.model = MDD.Models.DoseSet;

    DoseSets.prototype.url = '/api/doseSets';

    return DoseSets;

  })(Backbone.Collection);

}).call(this);
