# Eats teacup-views and spits html

gulp      = require 'gulp'
through   = require 'through2'
rename    = require "gulp-rename"

defaults  = require './defaults'

options = defaults 'html',
  sources     : 'html/**/*'
  destination : 'build/'

module.exports = options

gulp.task 'html', ->
  gulp
    .src options.sources, read: no
    .pipe through.obj (file, enc, done) ->
      # each file should be a module containing Teacup View instance
      # i.e. a function, that when called returns HTML string
      require.cache[file.path] = null # Clear cache, otherwise watch will always produce same output
      view = require file.path
      html = do view
      file.contents = new Buffer html
      @push file
      do done
    .pipe rename extname: '.html'
    .pipe gulp.dest destinations.html
