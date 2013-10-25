define ['jquery', 'underscore', 'backbone','helpers','models/Dose','models/DoseSet'], ($, _, Backbone, Helpers, Dose, DoseSet) ->

	class DisplayDoseSets extends Backbone.View
		el: '.shot-list'
	
		initialize: ->
			# Ecoute les événements 'renderAll' et 'renderOne' pour appeler les fonction respectives
			Helpers.event.on 'DoseSets:renderAll', @renderAll, this
			Helpers.event.on 'DoseSets:renderOne', @renderOne, this
			Helpers.event.on 'DoseSets:renderSome', @renderSome, this
	
		renderAll: ->
			if !@collection.models[0]
				# Si il n'y a pas de set créé, prévenir l'utilisateur
				@$el.html('<h2>Il n\'y a pas encore de Set, <br> Créez en un !</h2>')
			else
				# Autrement Mettre un titre adéquat
				@$el.html('<h2>Tous vos Sets : </h2>')
				# Pour chaque doSet ...
				_.each @collection.models, (doses) =>
					# ... pour chaque dose ...
					_.each doses.get('all').split(','), (doseid) =>
						# ... ajouter le rendu du template
						##@$el.append( Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
						dose = new Dose {_id: doseid}
						dose.fetch {
							success: ()=>
								@$el.append Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
						}
	
		renderOne: (id)->
			# Retrait des anciennes doses affichées
			#@$el.empty()
			doseSet = new DoseSet({id : id})
			doseSet.fetch {
				success: ()=>
					#console.log @collection.where({did : id})
					@$el.html '<h2>' + @collection.get(id).get('title') + '</h2>'
					# Pour chaque dose du set sélectionné
					_.each @collection.get(id).get('all').split(','), (doseid) =>
						# Ajout du rendu du template
						##@$el.append( Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
						dose = new Dose {_id: doseid}
						dose.fetch {
							success: ()=>
								@$el.append Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
						}
			}
	
		renderSome: (models)->
			if !models[0]
				# Si il n'y a pas de favoris, prévenir l'utilisateur
				@$el.html '<h2>Il n\'y a pas de favoris !</h2>'
			else
				# Autrement Mettre un titre adéquat
				@$el.html '<h2>Vos Sets favoris : </h2>'
				# Pour chaque doSet ...
				_.each models, (doses) =>
					# ... pour chaque dose ...
					_.each doses.get('all').split(','), (doseid) =>
						# ... ajouter le rendu du template
						##@$el.append( Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
						dose = new Dose {_id: doseid}
						dose.fetch {
							success: ()=>
								@$el.append Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
						}
