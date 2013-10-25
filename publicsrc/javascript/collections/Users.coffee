define ['backbone', 'models/User'], (Backbone, User)->

	class Users extends Backbone.Collection
		model: User
		url: '/api/users'
		