define ['backbone', 'models/Dose'], (Backbone, Dose)->

	class Doses extends Backbone.Collection
	
		model: Dose
		base: "http://api.dribbble.com/shots/everyone?page="
		#url: "http://api.dribbble.com/shots/everyone?page=1&per_page=5&callback=?"
		url: '/api/doses'
		parse: (resp, xhr)->
			return resp.shots
			