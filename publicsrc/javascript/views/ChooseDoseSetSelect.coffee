define ['jquery','backbone','helpers'], ($, Backbone, Helpers) ->
	
	class ChooseDoseSetSelect extends Backbone.View
		tagName: 'option'
	
		initialize: ->
			# Ecoute l'ajout à la collection pour mettre à jour la combo
			@model.on 'add', @render, this
			@model.on 'destroy', @unrender, this
			@model.on 'change : favorited', @unFav, this
			# On applique l'id à l'option
			@el.value = @model.id
			@$el.attr( 'name', @model.toJSON().title )
	
		render: ->
			# Ajout de l'Option à la combo
			@$el.html( Helpers.tmpl_render('OptionSet', { doseSet : @model.toJSON() }, this) )
	
		unrender: ->
			@remove()
	
		unFav: ->
			# Si c'est un favori le retirer de la liste
			if (@model.get('favorited') == false && @el.parentElement == $('#favSetSelector')[0])
				@remove()