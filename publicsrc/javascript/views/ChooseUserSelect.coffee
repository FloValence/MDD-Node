define ['jquery','backbone','helpers'], ($, Backbone, Helpers) ->
	
  class ChooseUserSelect extends Backbone.View
    tagName: 'option'
	
    initialize: ->
			# Ecoute l'ajout à la collection pour mettre à jour la combo
      @model.on 'add', @render, this
      @model.on 'destroy', @unrender, this
      # On applique l'id à l'option
      @el.value = @model.id
      @$el.attr 'name', @model.toJSON().title
	
    render: ->
      # Ajout de l'Option à la combo
      @$el.html Helpers.tmpl_render 'OptionUser', { user : @model.toJSON() }, this
	
    unrender: ->
      @remove()