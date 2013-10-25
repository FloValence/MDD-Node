define ['backbone'], (Backbone) ->
	class Dose extends Backbone.Model
		idAttribute: "_id"
		urlRoot: '/api/doses' #+ @_id || ''
		#localStorage: new Store("Doses")