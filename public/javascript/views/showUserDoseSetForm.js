// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'underscore', 'backbone', 'helpers', 'collections/DoseSets', 'views/ChooseDoseSetSelect', 'collections/Users'], function($, _, Backbone, Helpers, DoseSets, ChooseDoseSetSelect, Users) {
    var ShowUserDoseSetForm, _ref;
    return ShowUserDoseSetForm = (function(_super) {
      __extends(ShowUserDoseSetForm, _super);

      function ShowUserDoseSetForm() {
        _ref = ShowUserDoseSetForm.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      return ShowUserDoseSetForm;

    })(Backbone.View);
  });

}).call(this);
