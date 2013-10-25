class MDD.Views.App extends Backbone.View

	initialize: ->
		# Récupére l'id effectif du dernier set
		if @collection.length > 0 && MDD.Helpers.DoseSetsID == 0
			setNumber = @collection.length - 1
			MDD.Helpers.DoseSetsID = @collection.models[setNumber].id

		# Création des différentes vues en passant MDD.MyDaily en paramètre
		createView = new MDD.Views.CreateFormDoseSet({ collection : @collection })
		showView = new MDD.Views.ShowFormDoseSets({ collection : @collection })
		displayView = new MDD.Views.DisplayDoseSets({ collection : @collection })

# Formulaire pour la création de doses
class MDD.Views.CreateFormDoseSet extends Backbone.View
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
		doses = new MDD.Collections.Doses()
		doses.url = url
		successDoses = new MDD.Collections.Doses()
		dosesDone = 1
		doses.fetch({
					success: =>
						doses.url = '/api/doses'

						#Enregistre ( avec un un Save() ) toutes les doses
						#_.each doses.models, (model) =>
						doses.forEach (model)=>
							model.attributes['did'] = model.attributes['id']
							delete model.attributes['id']
							#console.log model.attributes
							#doses.create model.attributes
							model.save {}, {
								success: (model, response)->
									console.log response
								}
							model.fetch {success: (res1, res2)=>
								successDoses.add res1
								if dosesDone == doses.length
									@createDoseSet(successDoses, {wait : true })
								else
									dosesDone += 1
							}

						console.log(successDoses)
						#@createDoseSet(successDoses)
					})

	createDoseSet: (doses)-> # models = []
		###doses.fetch {success: (res1, res2)->
								console.log res1
								console.log res2
			}###
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
		doseSet = new MDD.Models.DoseSet {
			all : ids
			#'all' : models, # TODO : n'envoyer que les ids et récupérer les données depuis les doses sauvées en base
			#'id' : MDD.Helpers.DoseSetsID +=1,
			#'idd' : MDD.Helpers.DoseSetsID,
			'title' : @titleInput.val() || alternativeTitle || 'UnTitled',
			'date' : new Date()
		}

		# Ajout à la collec et sauver en base
		console.log doseSet
		@collection.create(doseSet)


		## ajouter la suppression des selects pour les fav,plus l'affichage d'un seul fav
# Formulaire pour l'affichage des doses
class MDD.Views.ShowFormDoseSets extends Backbone.View
	el : '.showDoseSets'

	initialize: ->
		@favCollec = new MDD.Collections.DoseSets()

		# Balise select
		@setSelector = $('#doseSetSelector')
		@favSetSelector = $('#favSetSelector')
		# Emplacement du nom du favoris dans le boutons Ajout aux favoris
		@setTitle = $('span.setTitle')
		@favAddRemove = $('button.fav span.addRemove')[0]
		@favAuxDes = $('button.fav span.auxDes')[0]
		@favNumber = $('span.favNum')[0]
		@hasFavs = $('span.hasFavs')[0]

		# Création des options des selects avec les données déjà en bases
		@createSelects @collection, @setSelector

		# Écouter le changement de l'option choisi pour mettre à jour le bouton ajout aux favs
		@setSelector.on 'change', @changeSelect
		@collection.on 'change : favorited', @changeSelect

		# Ecoute l'ajout à la collection pour mettre à jour la combo
		@collection.on 'add', @newSelect, this

		@createFavCollec()
		@changeSelect()
		@changeFavNumber()

	events:
		'click .loadAll' : 'renderAll'
		'click .delete' : 'deleteDoseSet'
		'click .fav' : 'changeFavs'
		'click .remFav' : 'changeFavs'
		'click .showFavs' : 'renderAllFavs'
		'click .oneFav' : 'renderOneFav'
		'submit' : 'renderOne'

	renderAll: ->
		# Signale l'événement 'renderAll'
		MDD.Helpers.event.trigger 'DoseSets:renderAll'

	renderOne: (e)->
		e.preventDefault()
		# Signale l'événement 'renderOne'
		MDD.Helpers.event.trigger 'DoseSets:renderOne', @setSelector.val()

	createFavCollec: ->
		#faved = []
		#@favCollec = new MDD.Collections.DoseSets()
		@collection.each (model)=>
			if model.attributes.favorited
				#faved.push(model)
				@favCollec.add( model )
				#@favCollec.get( model.get('id') ).set( {'favlist' : true} )
		#@favCollec = new MDD.Collections.DoseSets(faved)
		#@favCollec.fetch()
		@createSelects @favCollec, @favSetSelector

	createSelects: (collection, select)->
		# Pour chaque model de la collection...
		collection.each (model) =>
			# ... Envoie le model pour ajout aux select
			@addInSelect model, select

	newSelect: (model)->
		#model.attributes.id = model.attributes._id
		#console.log model.attributes.all
		#model.save()
		model.fetch {
			success: (res)=>
				@addInSelect res, @setSelector
		}


	addInSelect: (model, select)->
		selectView = new MDD.Views.SelectDoseSets { 'model' : model }
		# On ajoute au select le rendu
		select.append selectView.render()

	deleteDoseSet: ->
		if confirm "Voulez-vous supprimer " + @setSelector.find(':selected').text() + " ?"
			# Récupération du set sélectionné
			d = @collection.get @setSelector.val()
			f = @favCollec.get @setSelector.val()
			# Suppréssion en base
			d.destroy()
			f.destroy()

	changeSelect: =>
		# Récupération du titre de l'option sélectionnée
		@setTitle.text @setSelector.find(':selected').attr('name')

		# Définir si l'action du bouton favoris propose un ajout ou un retrait
		if @collection.get(@setSelector.val())
			if @collection.get(@setSelector.val()).get('favorited')
				@favAddRemove.innerHTML = 'Retirer'
				@favAuxDes.innerHTML = 'des'
			else
				@favAddRemove.innerHTML = 'Ajouter'
				@favAuxDes.innerHTML = 'aux'

	changeFavs: (e)->
		select
		if e.currentTarget == $('.fav')[0]
			select = @setSelector
		else if e.target == $('.remFav')[0]
			select = @favSetSelector
		# Vérifie s'il faut lancer la fonction d'ajout ou de retrait des favoris
		if @collection.get(select.val()).get('favorited')
			@removeFromFavs()
		else
			@addToFavs()
			@addInSelect @collection.get(select.val()), @favSetSelector

		@changeFavNumber()

	changeFavNumber: ->
		# Récupère le nombre de fovoris
		n = (@collection.where { 'favorited' : true }).length

		# Met à jour la phrase d'information
		@favNumber.innerHTML = n
		if n > 0
			@hasFavs.innerHTML = 's'
		else
			@hasFavs.innerHTML = ''

	addToFavs: ->
		# Définir le parametre favori à true
		@collection.get(@setSelector.val()).set({ 'favorited' : true }).save()
		# Ajouter à la collection des favoris
		@favCollec.add(@setSelector.val())

	removeFromFavs: ->
		# Définir le parametre favori à false
		@collection.get(@setSelector.val()).set({ 'favorited' : false }).save()
		# Retrait du set de la collection des favoris
		@favCollec.remove(@setSelector.val())

	renderAllFavs: ->
		# Récupération des sets ajoutés aux favoris
		f = @collection.where {'favorited' : true}
		MDD.Helpers.event.trigger 'DoseSets:renderSome', f

	renderOneFav: ->
		# Signaler que l'on demande un rendu d'un set
		MDD.Helpers.event.trigger 'DoseSets:renderOne', @favSetSelector.val()


# Une option dans la combo select
class MDD.Views.SelectDoseSets extends Backbone.View
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
		@$el.html( MDD.Helpers.tmpl_render('OptionSet', { doseSet : @model.toJSON() }, this) )

	unrender: ->
		@remove()

	unFav: ->
		# Si c'est un favori le retirer de la liste
		if (@model.get('favorited') == false && @el.parentElement == $('#favSetSelector')[0])
			@remove()

# Affichage des doses
class MDD.Views.DisplayDoseSets extends Backbone.View
	el: '.shot-list'

	initialize: ->
		# Ecoute les événements 'renderAll' et 'renderOne' pour appeler les fonction respectives
		MDD.Helpers.event.on 'DoseSets:renderAll', @renderAll, this
		MDD.Helpers.event.on 'DoseSets:renderOne', @renderOne, this
		MDD.Helpers.event.on 'DoseSets:renderSome', @renderSome, this

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
					console.log doseid
					# ... ajouter le rendu du template
					##@$el.append( MDD.Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
					dose = new MDD.Models.Dose {_id: doseid}
					dose.fetch {
						success: ()=>
							@$el.append MDD.Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
					}

	renderOne: (id)->
		# Retrait des anciennes doses affichées
		#@$el.empty()
		doseSet = new MDD.Models.DoseSet({id : id})
		doseSet.fetch {
			success: ()=>
				#console.log @collection.where({did : id})
				@$el.html '<h2>' + @collection.get(id).get('title') + '</h2>'
				# Pour chaque dose du set sélectionné
				_.each @collection.get(id).get('all').split(','), (doseid) =>
					console.log doseid
					# Ajout du rendu du template
					##@$el.append( MDD.Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
					dose = new MDD.Models.Dose {_id: doseid}
					dose.fetch {
						success: ()=>
							@$el.append MDD.Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
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
					##@$el.append( MDD.Helpers.tmpl_render('dose', { 'dose' : dose }, this) )
					dose = new MDD.Models.Dose {_id: doseid}
					dose.fetch {
						success: ()=>
							@$el.append MDD.Helpers.tmpl_render('dose', { 'dose' : dose.toJSON() }, this)
					}







































