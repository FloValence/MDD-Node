//var essaie = new MDD.Collections.Doses();

MDD.myDaily = new MDD.Collections.DoseSets();
MDD.myDaily.fetch().then(function(){
	new MDD.Views.App({ collection : MDD.myDaily });
});


//window.myDaily = new MDD.Views.App();

