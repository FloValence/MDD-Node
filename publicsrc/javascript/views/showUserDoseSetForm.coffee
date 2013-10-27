define ['jquery',
        'underscore',
        'backbone',
        'helpers',
        'collections/DoseSets',
        'views/ChooseUserSelect',
        'collections/Users'],
($, _, Backbone, Helpers, DoseSets, ChooseUserSelect, Users) ->

  class ShowUserDoseSetForm extends Backbone.View
    el : '.showUserDoseSets'
    
    initialize: ->
      @userSelector = @$el.find '.userSelector'
      @users = @options.users
      console.log this
      @createSelects @users, @userSelector
      
    createSelects: (collection, select)->
      # Pour chaque model de la collection...
      collection.each (model) =>
				# ... Envoie le model pour ajout aux select
        @addInSelect model, select
      
    addInSelect: (model, select)->
      selectView = new ChooseUserSelect { 'model' : model }
      # On ajoute au select le rendu
      select.append selectView.render()