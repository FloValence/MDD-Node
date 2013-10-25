// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['backbone'], function(Backbone) {
    var DoseSet, _ref;
    return DoseSet = (function(_super) {
      __extends(DoseSet, _super);

      function DoseSet() {
        _ref = DoseSet.__super__.constructor.apply(this, arguments);
        return _ref;
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
  });

}).call(this);
