define ['jquery','underscore','backbone'], ($, _, Backbone) ->
	
	Helpers = {}
	
	Helpers.event = _.extend {}, Backbone.Events
	
	#Template simple
	Helpers.template = (id)->
		_.template($('#'+ id).html())
	
	#Template partial
	Helpers.tmpl_render = (tmpl_name, tmpl_data, that)->
		if ( !@tmpl_render.tmpl_cache )
			@tmpl_render.tmpl_cache = {}
	
		if ( ! @tmpl_render.tmpl_cache[tmpl_name] )
			tmpl_dir = 'templates'
			tmpl_url = tmpl_dir + '/' + tmpl_name + '.html'
			tmpl_string = ''
			$.ajax({
				url: tmpl_url
				method: 'GET'
				async: false
				success: (data) =>
					tmpl_string = data
			});
			@tmpl_render.tmpl_cache[tmpl_name] = _.template tmpl_string
		@tmpl_render.tmpl_cache[tmpl_name] tmpl_data
	
	#Changement du template en moustache
	_.templateSettings.interpolate = /\{\{(.+?)\}\}/g
	_.templateSettings.escape = /\{\{\{(.+?)\}\}\}/g
	
	#Dernière Id des doseSets pour incrémentation
	Helpers.DoseSetsID = 0
	
	
	window.log = ->
		log.history = log.history or []
		log.history.push arguments_
		if @console
			arguments_.callee = arguments_.callee.caller
			a = [].slice.call(arguments_)
			(if typeof console.log is "object" then log.apply.call(console.log, console, a) else console.log.apply(console, a))
	
	((b) ->
		c = ->
		d = "assert,count,debug,dir,dirxml,error,exception,group,groupCollapsed,groupEnd,info,log,timeStamp,profile,profileEnd,time,timeEnd,trace,warn".split(",")
		a = undefined
	
		while a = d.pop()
			b[a] = b[a] or c
	) (->
		try
			console.log()
			return window.console
		catch err
			return window.console = {}
	)()
	
	Helpers