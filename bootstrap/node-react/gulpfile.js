var gulp = require('gulp');
var path = require('path');
var browserify = require('browserify');
var babelify = require('babelify');
var envify = require('envify');
var watchify = require('watchify');
var source = require('vinyl-source-stream');
var merge = require('merge-stream');
var nodemon = require('gulp-nodemon');
var order = require('gulp-order');
var concat = require('gulp-concat');
var cssmin = require('gulp-cssmin');
var autoprefixer = require('gulp-autoprefixer');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var stylus = require('gulp-stylus');
var streamify = require('gulp-streamify');
var gutil = require('gulp-util');
var babel = require('gulp-babel');
var spawn = require('child_process').spawn;

var ENV = 'development';
const DIST_DIR = 'static/dist';
const JS_DIR = DIST_DIR + '/js';
const CSS_DIR = DIST_DIR + '/css';
const VENDOR_DEPS = [
  'react',
  'react-dom',
  'react-router',
  'react-select',
  'react-timer-mixin',
  'classnames',
  'superagent'
];

var handleError = function(err) {
  console.log(err.toString());
  this.emit('end');
};

var normalize = function(str) {
  return str.replace(/\//g, '-');
};

///// STYLESHEETS /////

var STYLUS = [
  'main'
];

gulp.task('stylus', function() {
  var styls = STYLUS.map(function(s) {
    return gulp.src('stylesheets/stylus/' + s + '.styl')
      .pipe(stylus())
      .on('error', handleError)
      .pipe(rename(normalize(s) + '.css'))
      .pipe(gulp.dest('stylesheets/gulp'));
  });
  return merge(styls);
});

gulp.task('css', function() {
  var css = STYLUS.map(function(c) {
    return gulp.src('stylesheets/gulp/' + normalize(c) + '.css')
      .pipe(autoprefixer({
        browsers: ['last 2 versions'],
        cascade: false
      }))
      .pipe(gulp.dest(CSS_DIR))
      .pipe(cssmin())
      .pipe(rename({
        extname: '.min.css'
      }))
      .pipe(gulp.dest(CSS_DIR));
  });
  return merge(css);
});

gulp.task('others', function() {
  return gulp.src('bower_components/Ionicons/fonts/*')
    .pipe(gulp.dest(CSS_DIR + '/fonts'));
});

gulp.task('lib.css', function() {
  // Copy css dependencies that need to be minified
  var minify = [
    'bower_components/normalize-css/normalize.css'
  ].map(function(css) {
    return gulp.src(css)
      .pipe(cssmin())
      .pipe(rename({
        extname: '.min.css'
      }))
      .pipe(gulp.dest(CSS_DIR + '/lib'));
  });

  // Copy other css dependencies
  var deps = [
    'bower_components/Ionicons/css/ionicons.css'
  ].map(function(css) {
    return gulp.src(css).pipe(gulp.dest(CSS_DIR + '/lib'));
  });

  return merge(minify.concat(deps));
});

gulp.task('deps.css', ['lib.css', 'others'], function() {
  return gulp.src([CSS_DIR + '/lib/*.css', '!' + CSS_DIR + '/lib/deps.css'])
    .pipe(concat('deps.css'))
    .pipe(gulp.dest(CSS_DIR + '/lib'));
});

gulp.task('stylus-css', ['stylus'], function() {
  gulp.start('css');
});

gulp.task('stylesheets', ['deps.css', 'stylus', 'stylus-css']);

///// SCRIPTS /////

gulp.task('deps.js', function() {
  // Gopy other js dependencies
  var deps = [
    'bower_components/jquery/dist/jquery.min.js'
  ].map(function(dep) {
    return gulp.src(dep).pipe(gulp.dest(JS_DIR + '/lib'));
  });

  return merge(deps);
});

gulp.task('js', function() {
  var js = [
    'main'
  ].map(function(s) {
    return gulp.src('scripts/' + s + '.js')
      .pipe(rename(normalize(s) + '.js'))
      .pipe(gulp.dest(JS_DIR))
      .pipe(uglify())
      .pipe(rename({
        extname: '.min.js'
      }))
      .pipe(gulp.dest(JS_DIR));
  });

  return merge(js);
});

gulp.task('vendor', function() {
  var envs = ['development', 'production'];
  envs = envs.map(function(env) {
    var vendor = browserify({ debug: false })
      .require(VENDOR_DEPS)
      .transform(envify, {
        NODE_ENV: env
      })
      .bundle()
      .pipe(source('vendor.js'));
    if (env === 'production') {
      vendor = vendor.pipe(streamify(uglify({ mangle: true })))
      .pipe(rename({
        extname: '.min.js'
      }));
    }
    vendor = vendor.pipe(gulp.dest(JS_DIR));
    return vendor;
  });
  return merge(envs);
});

gulp.task('browserify', function() {
  var envs = {
    development: null,
    production: null
  };
  Object.keys(envs).forEach(function(env) {
    var bundler = browserify('app/main.js', { debug: false });
    if (env === 'development') {
      bundler = watchify(bundler);
    }
    bundler = bundler.external(VENDOR_DEPS)
      .transform(babelify, {
        presets: ['es2015', 'react']
      })
      .transform(envify, {
        NODE_ENV: env
      });
    if (env === 'development') {
      bundler = bundler.on('update', rebundle);
    }
    envs[env] = bundler;
  });
  return rebundle();

  function rebundle() {
    var start = Date.now();
    Object.keys(envs).forEach(function(env) {
      var vendor = envs[env]
        .bundle()
        .on('error', function(err) {
          gutil.log(gutil.colors.red(err.toString()));
        })
        .on('end', function() {
          gutil.log(gutil.colors.green('Finished rebundling in', (Date.now() - start) + 'ms.'));
        })
        .pipe(source('bundle.js'));
      if (env === 'production') {
        vendor = vendor
          .pipe(streamify(uglify({ mangle: true })))
          .pipe(rename({
            extname: '.min.js'
          }));
      }
      vendor = vendor.pipe(gulp.dest(JS_DIR));
    });
    return envs.development;
  }
});

gulp.task('server', function() {
  gulp.src('app.js')
    .pipe(babel({
      presets: ['es2015', 'react']
    }))
    .pipe(rename('server.js'))
    .pipe(gulp.dest('./'));
});

gulp.task('scripts', ['deps.js', 'js', 'vendor', 'browserify', 'server']);

///// WATCH && RUN /////

gulp.task('watch', function() {
  gulp.watch('stylesheets/stylus/*.*', ['stylus']);
  gulp.watch('stylesheets/gulp/*.css', ['css']);
  gulp.watch('scripts/**/*.js', ['js']);
  gulp.watch('app.js', ['server']);
});

gulp.task('start', ['stylesheets', 'scripts', 'watch'], function() {
  nodemon({
    script: 'server.js',
    env: {
      NODE_ENV: process.argv.indexOf('--production') >= 0 ? 'production' : 'development',
      LOCAL_HOST: true
    },
    watch: ['routes/', 'server.js', JS_DIR + '/bundle.js']
  });
});

gulp.task('build', ['stylesheets', 'scripts'], function() {
  gutil.log(gutil.colors.green('Build finished!'));
  process.exit(0);
});

gulp.task('default', function() {
  var process;
  var restart = function() {
    if (process) {
       process.kill();
    }
    var flags = ['start'];
    if (ENV === 'production') {
      flags.push('--production');
    }
    process = spawn('gulp', flags, {
      stdio: 'inherit'
    });
  }

  gulp.watch('gulpfile.js', restart);
  restart();
});

gulp.task('prod', function() {
  ENV = 'production';
  gulp.start('default');
});
