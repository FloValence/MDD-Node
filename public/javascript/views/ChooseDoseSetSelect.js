// Generated by CoffeeScript 1.6.3
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['jquery', 'backbone', 'helpers'], function($, Backbone, Helpers) {
    var ChooseDoseSetSelect, _ref;
    return ChooseDoseSetSelect = (function(_super) {
      __extends(ChooseDoseSetSelect, _super);

      function ChooseDoseSetSelect() {
        _ref = ChooseDoseSetSelect.__super__.constructor.apply(this, arguments);
        return _ref;
      }

      ChooseDoseSetSelect.prototype.tagName = 'option';

      ChooseDoseSetSelect.prototype.initialize = function() {
        this.model.on('add', this.render, this);
        this.model.on('destroy', this.unrender, this);
        this.model.on('change : favorited', this.unFav, this);
        this.el.value = this.model.id;
        return this.$el.attr('name', this.model.toJSON().title);
      };

      ChooseDoseSetSelect.prototype.render = function() {
        return this.$el.html(Helpers.tmpl_render('OptionSet', {
          doseSet: this.model.toJSON()
        }, this));
      };

      ChooseDoseSetSelect.prototype.unrender = function() {
        return this.remove();
      };

      ChooseDoseSetSelect.prototype.unFav = function() {
        if (this.model.get('favorited') === false && this.el.parentElement === $('#favSetSelector')[0]) {
          return this.remove();
        }
      };

      return ChooseDoseSetSelect;

    })(Backbone.View);
  });

}).call(this);
