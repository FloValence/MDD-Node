define ['backbone'], (Backbone)->
  class Router extends Backbone.Router
    routes:
      '': 'index',
      'contacts/:id/edit': 'editContact',
      'test/:id': 'test'
	
    index: ->
      console.log 'IndexPage'
	
    test: (id)->
      console.log 'TestPage : ' + id


