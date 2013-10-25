define ['jquery', 'underscore', 'backbone','helpers','models/DoseSet','collections/Doses'], ($, _, Backbone, Helpers, DoseSet, Doses) ->
	class CreateDoseSetForm extends Backbone.View
		el: '#createDoseSet'
		initialize: ->
	
		events:
			'submit' : 'fetchDoses'
	
		fetchDoses: (e)->
			e.preventDefault()
			# Choix du nombre de doses
			doseNumber = 5
			@doseNumberInput = @doseNumberInput || @$el.find('.doseNumber')
			$.trim(@doseNumberInput.val())
			if !(isNaN(@doseNumberInput.val()) ) && @doseNumberInput.val() > 0 && $.trim(@doseNumberInput.val()) != ''
				doseNumber = @doseNumberInput.val()
			else
				alert ('Choisissez un nombre de dose pour votre Set')
				return
			# Choix de la page
			pageNumber = 1
			@dosePageInput = @dosePageInput || @$el.find('.doseOld')
			$.trim(@doseNumberInput.val())
			if !(isNaN(@dosePageInput.val())) && @dosePageInput.val() > 0 && $.trim(@dosePageInput.val()) != ''
				pageNumber= @dosePageInput.val()
			else
				alert ('Choisissez l\'anciènneté du set, entre 1 et 100')
				return
			# Construction de l'url
			url = "http://api.dribbble.com/shots/everyone?page=" + pageNumber + "&per_page=" + doseNumber + "&callback=?"
	
			#Création récupération des doses pour le doseSet
			doses = new Doses()
			doses.url = url
			successDoses = new Doses()
			dosesDone = 1
			doses.fetch({
						success: =>
							doses.url = '/api/doses'
	
							#Enregistre ( avec un un Save() ) toutes les doses
							doses.forEach (model)=>
								model.attributes['did'] = model.attributes['id']
								delete model.attributes['id']
								model.save {}, {
									success: (model, response)->
										console.log response
								}
								model.fetch {
									success: (res1, res2)=>
										successDoses.add res1
										if dosesDone == doses.length
											@createDoseSet(successDoses, {wait : true })
										else
											dosesDone += 1
								}
	
							console.log(successDoses)
							#@createDoseSet(successDoses)
				})
	
		createDoseSet: (doses)->
			console.log doses
			ids = []
			_.each(doses.models, (model) =>
				ids.push(model.get('_id'))
			)
			# En cas de non renseignement de titre par l'utilisateur
			alternativeTitle = doses.first().get('title')
			# Crée un alias pour l'input du titre
			@titleInput = @titleInput || @$el.find('.doseSetTitle')
	
			# Création du set
			doseSet = new DoseSet {
				all : ids
				#'all' : models, # TODO : n'envoyer que les ids et récupérer les données depuis les doses sauvées en base
				#'id' : Helpers.DoseSetsID +=1,
				#'idd' : Helpers.DoseSetsID,
				'title' : @titleInput.val() || alternativeTitle || 'UnTitled',
				'date' : new Date()
			}
	
			# Ajout à la collec et sauver en base
			console.log doseSet
			@collection.create(doseSet)
