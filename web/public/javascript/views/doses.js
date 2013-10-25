// Generated by CoffeeScript 1.6.3
(function() {
  var _ref, _ref1, _ref2, _ref3, _ref4,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  MDD.Views.App = (function(_super) {
    __extends(App, _super);

    function App() {
      _ref = App.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    App.prototype.initialize = function() {
      var createView, displayView, setNumber, showView;
      if (this.collection.length > 0 && MDD.Helpers.DoseSetsID === 0) {
        setNumber = this.collection.length - 1;
        MDD.Helpers.DoseSetsID = this.collection.models[setNumber].id;
      }
      createView = new MDD.Views.CreateFormDoseSet({
        collection: this.collection
      });
      showView = new MDD.Views.ShowFormDoseSets({
        collection: this.collection
      });
      return displayView = new MDD.Views.DisplayDoseSets({
        collection: this.collection
      });
    };

    return App;

  })(Backbone.View);

  MDD.Views.CreateFormDoseSet = (function(_super) {
    __extends(CreateFormDoseSet, _super);

    function CreateFormDoseSet() {
      _ref1 = CreateFormDoseSet.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    CreateFormDoseSet.prototype.el = '#createDoseSet';

    CreateFormDoseSet.prototype.initialize = function() {};

    CreateFormDoseSet.prototype.events = {
      'submit': 'fetchDoses'
    };

    CreateFormDoseSet.prototype.fetchDoses = function(e) {
      var doseNumber, doses, dosesDone, pageNumber, successDoses, url,
        _this = this;
      e.preventDefault();
      doseNumber = 5;
      this.doseNumberInput = this.doseNumberInput || this.$el.find('.doseNumber');
      $.trim(this.doseNumberInput.val());
      if (!(isNaN(this.doseNumberInput.val())) && this.doseNumberInput.val() > 0 && $.trim(this.doseNumberInput.val()) !== '') {
        doseNumber = this.doseNumberInput.val();
      } else {
        alert('Choisissez un nombre de dose pour votre Set');
        return;
      }
      pageNumber = 1;
      this.dosePageInput = this.dosePageInput || this.$el.find('.doseOld');
      $.trim(this.doseNumberInput.val());
      if (!(isNaN(this.dosePageInput.val())) && this.dosePageInput.val() > 0 && $.trim(this.dosePageInput.val()) !== '') {
        pageNumber = this.dosePageInput.val();
      } else {
        alert('Choisissez l\'anciènneté du set, entre 1 et 100');
        return;
      }
      url = "http://api.dribbble.com/shots/everyone?page=" + pageNumber + "&per_page=" + doseNumber + "&callback=?";
      doses = new MDD.Collections.Doses();
      doses.url = url;
      successDoses = new MDD.Collections.Doses();
      dosesDone = 1;
      return doses.fetch({
        success: function() {
          doses.url = '/api/doses';
          doses.forEach(function(model) {
            model.attributes['did'] = model.attributes['id'];
            delete model.attributes['id'];
            model.save({}, {
              success: function(model, response) {
                return console.log(response);
              }
            });
            return model.fetch({
              success: function(res1, res2) {
                successDoses.add(res1);
                if (dosesDone === doses.length) {
                  return _this.createDoseSet(successDoses, {
                    wait: true
                  });
                } else {
                  return dosesDone += 1;
                }
              }
            });
          });
          return console.log(successDoses);
        }
      });
    };

    CreateFormDoseSet.prototype.createDoseSet = function(doses) {
      /*doses.fetch {success: (res1, res2)->
      								console.log res1
      								console.log res2
      			}
      */

      var alternativeTitle, doseSet, ids,
        _this = this;
      console.log(doses);
      ids = [];
      _.each(doses.models, function(model) {
        return ids.push(model.get('_id'));
      });
      alternativeTitle = doses.first().get('title');
      this.titleInput = this.titleInput || this.$el.find('.doseSetTitle');
      doseSet = new MDD.Models.DoseSet({
        all: ids,
        'title': this.titleInput.val() || alternativeTitle || 'UnTitled',
        'date': new Date()
      });
      console.log(doseSet);
      return this.collection.create(doseSet);
    };

    return CreateFormDoseSet;

  })(Backbone.View);

  MDD.Views.ShowFormDoseSets = (function(_super) {
    __extends(ShowFormDoseSets, _super);

    function ShowFormDoseSets() {
      this.changeSelect = __bind(this.changeSelect, this);
      _ref2 = ShowFormDoseSets.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    ShowFormDoseSets.prototype.el = '.showDoseSets';

    ShowFormDoseSets.prototype.initialize = function() {
      this.favCollec = new MDD.Collections.DoseSets();
      this.setSelector = $('#doseSetSelector');
      this.favSetSelector = $('#favSetSelector');
      this.setTitle = $('span.setTitle');
      this.favAddRemove = $('button.fav span.addRemove')[0];
      this.favAuxDes = $('button.fav span.auxDes')[0];
      this.favNumber = $('span.favNum')[0];
      this.hasFavs = $('span.hasFavs')[0];
      this.createSelects(this.collection, this.setSelector);
      this.setSelector.on('change', this.changeSelect);
      this.collection.on('change : favorited', this.changeSelect);
      this.collection.on('add', this.newSelect, this);
      this.createFavCollec();
      this.changeSelect();
      return this.changeFavNumber();
    };

    ShowFormDoseSets.prototype.events = {
      'click .loadAll': 'renderAll',
      'click .delete': 'deleteDoseSet',
      'click .fav': 'changeFavs',
      'click .remFav': 'changeFavs',
      'click .showFavs': 'renderAllFavs',
      'click .oneFav': 'renderOneFav',
      'submit': 'renderOne'
    };

    ShowFormDoseSets.prototype.renderAll = function() {
      return MDD.Helpers.event.trigger('DoseSets:renderAll');
    };

    ShowFormDoseSets.prototype.renderOne = function(e) {
      e.preventDefault();
      return MDD.Helpers.event.trigger('DoseSets:renderOne', this.setSelector.val());
    };

    ShowFormDoseSets.prototype.createFavCollec = function() {
      var _this = this;
      this.collection.each(function(model) {
        if (model.attributes.favorited) {
          return _this.favCollec.add(model);
        }
      });
      return this.createSelects(this.favCollec, this.favSetSelector);
    };

    ShowFormDoseSets.prototype.createSelects = function(collection, select) {
      var _this = this;
      return collection.each(function(model) {
        return _this.addInSelect(model, select);
      });
    };

    ShowFormDoseSets.prototype.newSelect = function(model) {
      var _this = this;
      return model.fetch({
        success: function(res) {
          return _this.addInSelect(res, _this.setSelector);
        }
      });
    };

    ShowFormDoseSets.prototype.addInSelect = function(model, select) {
      var selectView;
      selectView = new MDD.Views.SelectDoseSets({
        'model': model
      });
      return select.append(selectView.render());
    };

    ShowFormDoseSets.prototype.deleteDoseSet = function() {
      var d, f;
      d = this.collection.get(this.setSelector.val());
      f = this.favCollec.get(this.setSelector.val());
      d.destroy();
      return f.destroy();
    };

    ShowFormDoseSets.prototype.changeSelect = function() {
      this.setTitle.html(this.setSelector.find(':selected').attr('name'));
      if (this.collection.get(this.setSelector.val())) {
        if (this.collection.get(this.setSelector.val()).get('favorited')) {
          this.favAddRemove.innerHTML = 'Retirer';
          return this.favAuxDes.innerHTML = 'des';
        } else {
          this.favAddRemove.innerHTML = 'Ajouter';
          return this.favAuxDes.innerHTML = 'aux';
        }
      }
    };

    ShowFormDoseSets.prototype.changeFavs = function(e) {
      select;
      var select;
      if (e.currentTarget === $('.fav')[0]) {
        select = this.setSelector;
      } else if (e.target === $('.remFav')[0]) {
        select = this.favSetSelector;
      }
      if (this.collection.get(select.val()).get('favorited')) {
        this.removeFromFavs();
      } else {
        this.addToFavs();
        this.addInSelect(this.collection.get(select.val()), this.favSetSelector);
      }
      return this.changeFavNumber();
    };

    ShowFormDoseSets.prototype.changeFavNumber = function() {
      var n;
      n = (this.collection.where({
        'favorited': true
      })).length;
      this.favNumber.innerHTML = n;
      if (n > 0) {
        return this.hasFavs.innerHTML = 's';
      } else {
        return this.hasFavs.innerHTML = '';
      }
    };

    ShowFormDoseSets.prototype.addToFavs = function() {
      this.collection.get(this.setSelector.val()).set({
        'favorited': true
      }).save();
      return this.favCollec.add(this.setSelector.val());
    };

    ShowFormDoseSets.prototype.removeFromFavs = function() {
      this.collection.get(this.setSelector.val()).set({
        'favorited': false
      }).save();
      return this.favCollec.remove(this.setSelector.val());
    };

    ShowFormDoseSets.prototype.renderAllFavs = function() {
      var f;
      f = this.collection.where({
        'favorited': true
      });
      return MDD.Helpers.event.trigger('DoseSets:renderSome', f);
    };

    ShowFormDoseSets.prototype.renderOneFav = function() {
      return MDD.Helpers.event.trigger('DoseSets:renderOne', this.favSetSelector.val());
    };

    return ShowFormDoseSets;

  })(Backbone.View);

  MDD.Views.SelectDoseSets = (function(_super) {
    __extends(SelectDoseSets, _super);

    function SelectDoseSets() {
      _ref3 = SelectDoseSets.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    SelectDoseSets.prototype.tagName = 'option';

    SelectDoseSets.prototype.initialize = function() {
      this.model.on('add', this.render, this);
      this.model.on('destroy', this.unrender, this);
      this.model.on('change : favorited', this.unFav, this);
      this.el.value = this.model.id;
      return this.$el.attr('name', this.model.toJSON().title);
    };

    SelectDoseSets.prototype.render = function() {
      return this.$el.html(MDD.Helpers.tmpl_render('OptionSet', {
        doseSet: this.model.toJSON()
      }, this));
    };

    SelectDoseSets.prototype.unrender = function() {
      return this.remove();
    };

    SelectDoseSets.prototype.unFav = function() {
      if (this.model.get('favorited') === false && this.el.parentElement === $('#favSetSelector')[0]) {
        return this.remove();
      }
    };

    return SelectDoseSets;

  })(Backbone.View);

  MDD.Views.DisplayDoseSets = (function(_super) {
    __extends(DisplayDoseSets, _super);

    function DisplayDoseSets() {
      _ref4 = DisplayDoseSets.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    DisplayDoseSets.prototype.el = '.shot-list';

    DisplayDoseSets.prototype.initialize = function() {
      MDD.Helpers.event.on('DoseSets:renderAll', this.renderAll, this);
      MDD.Helpers.event.on('DoseSets:renderOne', this.renderOne, this);
      return MDD.Helpers.event.on('DoseSets:renderSome', this.renderSome, this);
    };

    DisplayDoseSets.prototype.renderAll = function() {
      var _this = this;
      if (!this.collection.models[0]) {
        return this.$el.html('<h2>Il n\'y a pas encore de Set, <br> Créez en un !</h2>');
      } else {
        this.$el.html('<h2>Tous vos Sets : </h2>');
        return _.each(this.collection.models, function(doses) {
          return _.each(doses.get('all').split(','), function(doseid) {
            var dose;
            console.log(doseid);
            dose = new MDD.Models.Dose({
              _id: doseid
            });
            return dose.fetch({
              success: function() {
                return _this.$el.append(MDD.Helpers.tmpl_render('dose', {
                  'dose': dose.toJSON()
                }, _this));
              }
            });
          });
        });
      }
    };

    DisplayDoseSets.prototype.renderOne = function(id) {
      var doseSet,
        _this = this;
      doseSet = new MDD.Models.DoseSet({
        id: id
      });
      return doseSet.fetch({
        success: function() {
          _this.$el.html('<h2>' + _this.collection.get(id).get('title') + '</h2>');
          return _.each(_this.collection.get(id).get('all').split(','), function(doseid) {
            var dose;
            console.log(doseid);
            dose = new MDD.Models.Dose({
              _id: doseid
            });
            return dose.fetch({
              success: function() {
                return _this.$el.append(MDD.Helpers.tmpl_render('dose', {
                  'dose': dose.toJSON()
                }, _this));
              }
            });
          });
        }
      });
    };

    DisplayDoseSets.prototype.renderSome = function(models) {
      var _this = this;
      if (!models[0]) {
        return this.$el.html('<h2>Il n\'y a pas de favoris !</h2>');
      } else {
        this.$el.html('<h2>Vos Sets favoris : </h2>');
        return _.each(models, function(doses) {
          return _.each(doses.get('all').split(','), function(doseid) {
            var dose;
            dose = new MDD.Models.Dose({
              _id: doseid
            });
            return dose.fetch({
              success: function() {
                return _this.$el.append(MDD.Helpers.tmpl_render('dose', {
                  'dose': dose.toJSON()
                }, _this));
              }
            });
          });
        });
      }
    };

    return DisplayDoseSets;

  })(Backbone.View);

}).call(this);
