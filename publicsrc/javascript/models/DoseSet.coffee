define ['backbone'], (Backbone) ->
	
	class DoseSet extends Backbone.Model
		idAttribute: "_id"
		urlRoot: '/api/doseSets'
		#urlRoot: '/doseSet'
		#localStorage: new Store("DoseSets")
	
		defaults:
			title: 'UnTitled'
			date: '635644800000'
			url: 'florian.valence.free.fr/MDD'
			all: []
			selected: []
			tags: []
			favorited: false
	
		initialize: ->