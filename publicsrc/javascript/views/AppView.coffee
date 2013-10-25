define ['backbone','helpers','collections/Users', 'views/CreateDoseSetForm','views/ShowDoseSetForm','views/DisplayDoseSets','views/CreateUserForm','views/showUserDoseSetForm'], (Backbone, Helpers, Users, CreateDoseSetForm, ShowDoseSetForm, DisplayDoseSets, CreateUserForm, showUserDoseSetForm) ->
	class AppView extends Backbone.View
	
		initialize: ->
			# Récupére l'id effectif du dernier set
			if @collection.length > 0 && Helpers.DoseSetsID == 0
				setNumber = @collection.length - 1
				Helpers.DoseSetsID = @collection.models[setNumber].id
				
			# Liste des utilisateurs
			users = new Users()
			users.fetch().then ->
				createUserView = new CreateUserForm { collection : users }
				showUserView = new showUserDoseSetForm {users : users, dosesets : @collection}
	
			# Création des différentes vues en passant MyDaily en paramètre
			createView = new CreateDoseSetForm { collection : @collection }
			showView = new ShowDoseSetForm { collection : @collection }
			displayView = new DisplayDoseSets { collection : @collection }
