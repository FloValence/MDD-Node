// Generated by CoffeeScript 1.6.3
(function() {
  MDD.myDaily = new MDD.Collections.DoseSets();

  MDD.myDaily.fetch().then(function() {
    return new MDD.Views.App({
      collection: MDD.myDaily
    });
  });

}).call(this);
