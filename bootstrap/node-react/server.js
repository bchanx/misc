'use strict';

require('babel-core/register')({
  presets: ['es2015', 'react']
});

var express = require('express');
var favicon = require('serve-favicon');
var path = require('path');
var fs = require('fs');
var compress = require('compression');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');

var app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

var ENV = process.env.NODE_ENV || 'development';
var PORT = process.env.PORT || 3000;
var LOCAL_HOST = !!process.env.LOCAL_HOST;
app.set('env', ENV);
app.set('port', PORT);

app.use(compress());
app.use(bodyParser.json({ limit: '500mb' }));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use('/static', express.static(path.join(__dirname, 'static')));

app.locals = {
  env: ENV,
  min: ENV === 'production' ? '.min' : ''
};

// Serve favicon
app.use(favicon(__dirname + '/static/favicon' + (ENV === 'development' ? '-dev' : '') + '.ico'));

// Setup logging middleware
app.use(function (req, res, next) {
  console.log('[ ' + req.method + ' ]', req.url, req.query, req.body);
  next();
});

// No caching
app.use(function (req, res, next) {
  res.header('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.header('Pragma', 'no-cache');
  res.header('Expires', 0);
  next();
});

// Allow CORS
var allowCrossDomain = function allowCrossDomain(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Request-Method', '*');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE, OPTIONS');
  next();
};
app.use(allowCrossDomain);

// Setup custom routes
var ROUTE_DIR = './routes';
var customRoutes = fs.readdirSync(ROUTE_DIR);
customRoutes.forEach(function (r) {
  if (r.endsWith('.js')) {
    var filepath = ROUTE_DIR + '/' + r;
    var routename = '/' + (r.startsWith('index') ? '' : r.split('.js')[0]);
    app.use(routename, require(filepath).default);
  }
});

var React = require('react');
var ReactDOM = require('react-dom/server');
var Router = require('react-router');
var RoutingContext = Router.RoutingContext;
var routes = require('./app/routes').default();

app.use(function (req, res) {
  Router.match({ routes: routes, location: req.url }, function (err, redirectLocation, renderProps) {
    if (err) {
      res.status(500).send(err.message);
    } else if (redirectLocation) {
      res.status(301).redirect(redirectLocation.pathname + redirectLocation.search);
    } else if (!renderProps) {
      res.status(404).send('Not found');
    } else {
      var html = ReactDOM.renderToString(React.createElement(RoutingContext, renderProps));
      res.render('index', { html: html });
    }
  });
});

var server = app.listen(PORT, function () {
  console.log('Server running as [%s] on port [%s]', ENV, PORT);
});