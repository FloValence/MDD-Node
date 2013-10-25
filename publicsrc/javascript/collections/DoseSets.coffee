define ['backbone', 'models/DoseSet'], (Backbone, DoseSet)->

	class DoseSets extends Backbone.Collection
		model: DoseSet
		#localStorage: new Store("DoseSets")
		url: '/api/doseSets'
		