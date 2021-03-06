// Generated by CoffeeScript 1.6.3
(function() {
  var Dose, models;

  models = require('./models');

  Dose = models.Dose;

  exports.oneDose = function(req, res) {
    return res.send('One Dose');
  };

  exports.findAll = function(req, res) {
    return Dose.find(function(err, doses) {
      return res.send(doses);
    });
  };

  exports.findById = function(req, res) {
    return Dose.findById(req.params.id, function(err, dose) {
      if (!err) {
        return res.send(dose);
      } else {
        return console.log(err);
      }
    });
  };

  exports.updateOne = function(req, res) {
    return Dose.findById(req.params.id, function(err, dose) {
      dose.title = req.body.title;
      dose.comments_count = req.body.comments_count;
      dose.created_at = req.body.created_at;
      dose.did = req.body.did;
      dose.height = req.body.height;
      dose.image_400_url = req.body.image_400_url;
      dose.image_teaser_url = req.body.image_teaser_url;
      dose.image_url = req.body.image_url;
      dose.likes_count = req.body.likes_count;
      dose.player = req.body.player;
      dose.rebound_source_id = req.body.rebound_source_id;
      dose.rebounds_count = req.body.rebounds_count;
      dose.short_url = req.body.short_url;
      dose.url = req.body.url;
      dose.views_count = req.body.views_count;
      dose.width = req.body.width;
      return dose.save(function(err) {
        if (!err) {
          console.log("updated dose");
        } else {
          console.log(err);
        }
        return res.send(dose);
      });
    });
  };

  exports.addOne = function(req, res) {
    var dose;
    console.log('essaie de post');
    dose = new Dose({
      title: req.body.title,
      comments_count: req.body.comments_count,
      created_at: req.body.created_at,
      did: req.body.did,
      height: req.body.height,
      image_400_url: req.body.image_400_url,
      image_teaser_url: req.body.image_teaser_url,
      image_url: req.body.image_url,
      likes_count: req.body.likes_count,
      player: req.body.player,
      rebound_source_id: req.body.rebound_source_id,
      rebounds_count: req.body.rebounds_count,
      short_url: req.body.short_url,
      url: req.body.url,
      views_count: req.body.views_count,
      width: req.body.width
    });
    dose.save(function(err) {
      if (!err) {
        return console.log("created dose");
      } else {
        return console.log(err);
      }
    });
    return res.send(dose);
  };

  exports.deleteOne = function(req, res) {
    return Dose.findById(req.params.id, function(err, dose) {
      return dose.remove(function(err) {
        if (!err) {
          console.log("removed dose");
          return res.send('');
        }
      });
    });
  };

}).call(this);
