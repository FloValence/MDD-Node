define ['jquery', 'underscore', 'backbone','helpers','collections/DoseSets','views/ChooseDoseSetSelect'], ($, _, Backbone, Helpers, DoseSets, ChooseDoseSetSelect) ->

	class ShowDoseSetForm extends Backbone.View
		el : '.showDoseSets'
	
		initialize: ->
			@favCollec = new DoseSets()
	
			# Balise select
			@setSelector = @$el.find '#doseSetSelector'
			@favSetSelector = @$el.find '#favSetSelector'
			# Emplacement du nom du favoris dans le boutons Ajout aux favoris
			@setTitle = @$el.find 'span.setTitle'
			@favAddRemove = @$el.find('button.fav span.addRemove')[0]
			@favAuxDes = @$el.find('button.fav span.auxDes')[0]
			@favNumber = @$el.find('span.favNum')[0]
			@hasFavs = @$el.find('span.hasFavs')[0]
	
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
			Helpers.event.trigger 'DoseSets:renderAll'
	
		renderOne: (e)->
			e.preventDefault()
			# Signale l'événement 'renderOne'
			Helpers.event.trigger 'DoseSets:renderOne', @setSelector.val()
	
		createFavCollec: ->
			@collection.each (model)=>
				if model.attributes.favorited
					@favCollec.add( model )
					
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
			selectView = new ChooseDoseSetSelect { 'model' : model }
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
			Helpers.event.trigger 'DoseSets:renderSome', f
	
		renderOneFav: ->
			# Signaler que l'on demande un rendu d'un set
			Helpers.event.trigger 'DoseSets:renderOne', @favSetSelector.val()
	
