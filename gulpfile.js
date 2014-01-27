// Generated by CoffeeScript 1.6.3
'use strict';
var autoprefixer, cache, changed, clean, concat, connect, cssmin, csso, gulp, gutil, http, imagemin, jshint, livereload, lr, notify, open, rename, sass, server, uglify;

gulp = require('gulp');

gutil = require('gulp-util');

rename = require('gulp-rename');

autoprefixer = require('gulp-autoprefixer');

concat = require('gulp-concat');

changed = require('gulp-changed');

cssmin = require('gulp-minify-css');

csso = require('gulp-csso');

notify = require('gulp-notify');

sass = require('gulp-ruby-sass');

jshint = require('gulp-jshint');

clean = require('gulp-clean');

cache = require('gulp-cache');

uglify = require('gulp-uglify');

imagemin = require('gulp-imagemin');

http = require('http');

livereload = require('gulp-livereload');

lr = require('tiny-lr');

connect = require('connect');

open = require('open');

server = lr();

require('gulp-grunt')(gulp);

connect.options = {
  port: 3000,
  tmp: '.tmp',
  root: 'app',
  protocol: 'http',
  livereload: 35729,
  hostname: 'localhost'
};

gulp.task('default', function() {
  return gulp.run('server');
});

gulp.task('server', ['watch'], function() {
  var app;
  app = connect().use(connect["static"](connect.options.tmp)).use(connect["static"](connect.options.root));
  http.createServer(app).listen(connect.options.port);
  return open(connect.options.protocol + '://' + connect.options.hostname + ':' + connect.options.port);
});

gulp.task('css', function() {
  return gulp.src(['.tmp/styles/{,*/}*.css', 'app/styles/{,*/}*.css']).pipe(concat('styles.css')).pipe(csso()).pipe(gulp.dest('dist/styles'));
});

gulp.task('compass', function() {
  return gulp.src('app/styles/styles.sass').pipe(sass({
    compass: true
  })).pipe(livereload(server)).pipe(gulp.dest('.tmp/styles/'));
});

gulp.task('usemin', function() {
  return gulp.run('grunt-build');
});

gulp.task('livereload', function() {
  return gulp.src(['app/{,*/}*.html', '.tmp/styles/{,*/}*.css', 'app/images/{,*/}*.{gif,jpeg,jpg,png,svg,webp}']).pipe(livereload(server));
});

gulp.task('watch', function() {
  return server.listen(connect.options.livereload, function(err) {
    if (err) {
      return console.log(err);
    }
    gulp.watch('app/{,*/}*.html', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
      return gulp.run('livereload');
    });
    return gulp.watch('app/styles/{,*/}*.{scss,sass}', function(event) {
      console.log('File ' + event.path + ' was ' + event.type + ', running tasks...');
      return gulp.run('compass');
    });
  });
});