define ['jquery', 'underscore', 'backbone','helpers','models/User','collections/Users'], ($, _, Backbone, Helpers, User, Users) ->
	class CreateDoseSetForm extends Backbone.View
		el: '#createUser'
		initialize: ->
			@userName = @$el.find('.userName')
			@userEmail = @$el.find('.userEmail')
	
		events:
			'submit' : 'controlFields'


		controlFields: (e)->
			e.preventDefault()
			if !($.trim(@userName.val()) == '')
				name = @userName.val()
				#alert 'Le nom d\'utilisateur est ' + @userName.val()
			else
				alert 'Veuillez entrer un nom d\'utilisateur'
				return
			if !($.trim(@userEmail.val()) == '')
				email = @userEmail.val()
				#alert 'L\'email de l\'utilisateur est ' + @userEmail.val()
			else
				alert 'Veuillez entrer une adresse mail'
				return

# Création du set
			user = new User {
				email : email
				name : name
				active : true
				dosesets : ''
			}
	
			# Ajout à la collec et sauver en base
			console.log user
			@collection.create(user)