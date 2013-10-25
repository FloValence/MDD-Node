define ['jquery','underscore','backbone'], ($, _, Backbone) ->
	class MDD.Models.Dose extends Backbone.Model
		idAttribute: "_id"
		urlRoot: '/api/doses' #+ @_id || ''
		#localStorage: new Store("Doses")
	
	class MDD.Models.DoseSet extends Backbone.Model
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
	
	class MDD.Models.User extends Backbone.Model
		idAttribute: "_id"
		urlRoot: '/api/users'
		
		default:
			name: 'John Doe'
			active: true
		
	class MDD.Collections.Doses extends Backbone.Collection
	
		model: MDD.Models.Dose
		base: "http://api.dribbble.com/shots/everyone?page="
		#url: "http://api.dribbble.com/shots/everyone?page=1&per_page=5&callback=?"
		url: '/api/doses'
		parse: (resp, xhr)->
			return resp.shots
	
	class MDD.Collections.DoseSets extends Backbone.Collection
		model: MDD.Models.DoseSet
		#localStorage: new Store("DoseSets")
		url: '/api/doseSets'
	
	class MDD.Collections.Users extends Backbone.Collection
		model: MDD.Models.User
		url: '/api/users'
	






