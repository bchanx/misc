var express = require('express');
var favicon = require('serve-favicon');
var path = require('path');
var compress = require('compression');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');

var app = express();

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.set('port', (process.env.PORT || 3000));
app.set('env', (process.env.NODE_ENV || 'development'));

app.use(favicon(__dirname + '/static/favicon.ico'));
app.use(compress());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'static')));

app.locals = {
  env: app.get('env'),
  title: 'bchanx',
  min: app.get('env') === 'production' ? '.min' : ''
};

app.get('/', function (req, res) {
  res.render('index');
});

var server = app.listen(app.get('port'), function () {
  console.log('Server running as [%s] on port [%s]', app.get('env'), app.get('port'));
});
