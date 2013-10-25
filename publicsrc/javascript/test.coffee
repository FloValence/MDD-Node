require.config
	baseUrl: "/javascript",
	paths:
		"jquery": "vendor/jquery/jquery.min"
		"underscore": "vendor/underscore-amd/underscore-min"
		"backbone": "vendor/backbone-amd/backbone-min"
	waitSeconds: 15


require ['collections/DoseSets','views/AppView'], (DoseSets, App)->

	myDaily = new DoseSets()
	myDaily.fetch().then ->
		new App(collection: myDaily)