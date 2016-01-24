var router = require('express').Router();
var config = require('../config');

router.get('/splash', function(req, res) {
  res.render('splash');
});

module.exports = {
  router: router
};
