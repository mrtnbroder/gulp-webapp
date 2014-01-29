'use strict'

gulp            = require 'gulp'
gutil           = require 'gulp-util'

rename          = require 'gulp-rename'
autoprefixer    = require 'gulp-autoprefixer'
concat          = require 'gulp-concat'
changed         = require 'gulp-changed'
cssmin          = require 'gulp-minify-css'
csso            = require 'gulp-csso'
notify          = require 'gulp-notify'
sass            = require 'gulp-ruby-sass'
jshint          = require 'gulp-jshint'
clean           = require 'gulp-clean'
cache           = require 'gulp-cache'
uglify          = require 'gulp-uglify'
imagemin        = require 'gulp-imagemin'

http            = require 'http'
livereload      = require 'gulp-livereload'
lr              = require 'tiny-lr'
connect         = require 'connect'
open            = require 'open'
server = lr()
require('gulp-grunt')(gulp)


connect.options =
    port: 3000
    tmp: '.tmp'
    root: 'app'
    protocol: 'http'
    livereload: 35729
    hostname: 'localhost'




gulp.task 'default', ['server'],  ->


gulp.task 'server', ['watch'], ->
    app = connect()
        .use(connect.static(connect.options.tmp))
        .use(connect.static(connect.options.root))

    http.createServer(app).listen(connect.options.port)
    open(connect.options.protocol + '://' + connect.options.hostname + ':' + connect.options.port)


gulp.task 'css', ->
    gulp.src([
        '.tmp/styles/{,*/}*.css'
        'app/styles/{,*/}*.css'
    ])
        .pipe(concat('styles.css'))
        .pipe(rename('styles.min.css'))
        .pipe(autoprefixer('last 2 version'))
        .pipe(csso())
        .pipe(gulp.dest('dist/styles'))


gulp.task 'compass', ->
    gulp.src('app/styles/styles.sass')
        .pipe(sass(compass:true))
        .pipe(livereload(server))
        .pipe(gulp.dest('.tmp/styles/'))
        # .pipe(notify(message: "Compass task complete"))


gulp.task 'usemin', ['grunt-build'], ->


gulp.task 'livereload', ->
    gulp.src([
        'app/{,*/}*.html'
        '.tmp/styles/{,*/}*.css'
        'app/images/{,*/}*.{gif,jpeg,jpg,png,svg,webp}'
    ], read:false)
        .pipe(livereload(server))
        # .pipe(notify(message:'Livereload task complete'))

gulp.task 'watch', ->

    server.listen connect.options.livereload, (err) ->

        return console.log err if err

        # gulp.watch 'gulpfile.js', (event) ->
        #     console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

        gulp.watch 'app/{,*/}*.html', ['livereload'], (event) ->
            console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'

        gulp.watch 'app/styles/{,*/}*.{scss,sass}', ['compass'], (event) ->
            console.log 'File ' + event.path + ' was ' + event.type + ', running tasks...'
